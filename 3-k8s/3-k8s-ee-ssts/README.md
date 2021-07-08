<!-- Copyright 2020 AxonIQ B.V.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License. -->

# Running Axon Server EE in Kubernetes using Singleton StatefulSets

**Note** We at AxonIQ are aware that many of our customners run Axon Server in Kubernetes or want to run it there. The files in this directory are to help you on your way with developing a deployment plan based on "Singleton StatefulSets". For more information, please [read this article](https://axoniq.io/blog-overview/revisiting-axon-server-in-containers).

## Deployment Plan

The deployment plan for the files in this directory is as follows:

* The cluster will be deployed in `NameSpace` "`running-ee`".
* Every Axon Server node will be deployed as a `StatefulSet` scaled to 1 (one) instance.
* Every Axon Server node will have a "Headless Service" associated with it, with the same name as the `StatefulSet`. This will make Kubernetes create a DNS entry with this same name, in a subdomain named after the `NameSpace`, suffixed with "`svc.cluster.local`"
* A common secret for the system token
* A common secret for the license
* A common properties file is deployed as a `ConfigMap`, which sets:

    - The domain (and internal domain) to "`running-ee.svc.cluster.local`".
    - The autocluster options for contexts "`_admin`" and "`default`", and the first node using the FQDN of the Headless Service
    - Access-control to enabled with an internal token
    - The internal token path is set pointing at the associated secret
    - The license path is set pointing at the associated secret

The nodes will be named "`axonserver-1`", "`axonserver-2`", and "`axonserver-3`". Each will get a "Headless Service" with the same name, ensuring we get DNS entries for them. The nodes will also get these names as their hostname, so clients will be prompted to use these names as well:

| Node name  <br/> (StatefulSet)  | Pod | Headless <br/> Service | FQDN |
| :---         | :---           | :---         | :---                                      |
| axonserver-1 | axonserver-1-0 | axonserver-1 | axonserver-1.running-ee.svc.cluster.local |
| axonserver-2 | axonserver-2-0 | axonserver-2 | axonserver-2.running-ee.svc.cluster.local |
| axonserver-3 | axonserver-3-0 | axonserver-3 | axonserver-3.running-ee.svc.cluster.local |


## How to deploy

First deploy the secrets and ConfigMap with:

```text
$ ./deploy-secrets axonserver-1 running-ee
Generating files

Generating axonserver.properties

Creating Namespace if needed

namespace/running-ee created

Creating/updating Secrets and ConfigMap

secret/axoniq-license created
secret/axonserver-token created
configmap/axonserver-properties created
$
```

Now we can deploy the individual nodes:

```text
$ for i in $(seq 3) ; do ./deploy-axonserver.sh axonserver-${i} test-cluster running-ee ; done
Generating files

Generating axonserver-1.yml

Deploying/updating StatefulSet

statefulset.apps/axonserver-1 created
service/axonserver-1 created
Generating files

Generating axonserver-2.yml

Deploying/updating StatefulSet

statefulset.apps/axonserver-2 created
service/axonserver-2 created
Generating files

Generating axonserver-3.yml

Deploying/updating StatefulSet

statefulset.apps/axonserver-3 created
service/axonserver-3 created
```

Now we need a service to access the UI and REST ports:

```text
$ ./deploy-service-lb.sh test-cluster running-ee
Generating files

Generating axonserver-svc.yml

Deploying/updating LoadBalancer Service

service/axonserver-gui created
$
```

**NOTE** As mentioned before, on Docker for Desktop the LoadBalancer service won't work correctly, but we can access e.g. node "`axonserver-1`" using port forwarding:

```text
$ kubectl port-forward axonserver-1-0 8024:8024 -n running-ee
Forwarding from 127.0.0.1:8024 -> 8024
Forwarding from [::1]:8024 -> 8024
```

## Testing the cluster

Now we can access the node with the default URL of "http://localhost:8024" in the case of port forwarding, or on the LoadBalancer's public IP otherwise, to create an admin user:

```text
$ java -jar ../../axonserver-cli.jar register-user -t $(cat ../../axonserver.token) -u admin -p $(cat ../../axonserver.token) -r ADMIN@_admin
$
```

You can now log on to the UI and register the quick-test app. Supposing this returned a token "`7e2d10a3-8dbe-4552-be50-f6568568794a`", you can now run it:

```text
$ kubectl run axonserver-quicktest --image=axoniq/axonserver-quicktest:4.4-SNAPSHOT --env AXON_AXONSERVER_SERVERS=axonserver-1,axonserver-2,axonserver-3 --env AXON_AXONSERVER_TOKEN=7e2d10a3-8dbe-4552-be50-f6568568794a --env SPRING_PROFILES_ACTIVE=axonserver --attach stdout -n running-ee --rm
If you don't see a command prompt, try pressing enter.
2021-07-08 08:15:03.600  INFO 1 --- [           main] i.a.t.q.c.QuickAxonServerConfiguration   : Setting up routing policy on a AxonServerCommandBus.
2021-07-08 08:15:03.926  INFO 1 --- [           main] i.a.a.c.impl.AxonServerManagedChannel    : Requesting connection details from axonserver-1:8124
2021-07-08 08:15:04.136  INFO 1 --- [           main] i.a.a.c.impl.AxonServerManagedChannel    : Successfully connected to axonserver-1:8124
2021-07-08 08:15:04.143  INFO 1 --- [           main] i.a.a.connector.impl.ControlChannelImpl  : Connected instruction stream for context 'default'. Sending client identification
2021-07-08 08:15:04.149  INFO 1 --- [           main] i.a.a.c.command.impl.CommandChannelImpl  : CommandChannel connected, 0 command handlers registered
2021-07-08 08:15:04.155  INFO 1 --- [           main] i.a.a.c.command.impl.CommandChannelImpl  : Registered handler for command io.axoniq.testing.quicktester.msg.TestCommand
2021-07-08 08:15:04.341  INFO 1 --- [mandProcessor-0] i.a.testing.quicktester.TestHandler      : handleCommand(): src = "QuickTesterApplication.getRunner", msg = "Hi there! It is Thu Jul 08 08:15:04 GMT 2021.".
2021-07-08 08:15:04.933  INFO 1 --- [.quicktester]-0] i.a.testing.quicktester.TestHandler      : handleEvent(): msg = "QuickTesterApplication.getRunner says: Hi there! It is Thu Jul 08 08:15:04 GMT 2021.".
2021-07-08 08:15:24.956  INFO 1 --- [           main] i.a.a.c.query.impl.QueryChannelImpl      : QueryChannel connected, 0 registrations resubscribed
pod "axonserver-quicktest" deleted
$
```

The example above:

1. Uses the public image "`axoniq/axonserver-quicktest:4.4-SNAPSHOT`", which has been built using the Axon Framework version 4.4
2. Passes a list containing all three nodes to the client, so if one if unavailable it will try the next one
3. Passes the token that the UI gave
4. Sets the Quick Tester's profile to "`axonserver`", so it will not use a in-memory eventstore but actually connect to Axon Server.

## Cleaning up

The script "`cleanup.sh`" will remove all files generated from the tamplates. To delete the cluster you can just run "`kubectl delete ns running-ee`".
