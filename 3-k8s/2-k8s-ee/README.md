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

## Running Axon Server EE in Kubernetes

**Note** We at AxonIQ are aware that many of our customners run Axon Server in Kubernetes or want to run it there.
The files in this directory are to help you on your way, but there are so many things you might want to tune, that we do
not want to present this as **the definitive best way.**

The `create-secrets.sh` script will generate de `axonserver.properties` ConfigMap, license secret, and system-token secret, given a service name and namespace.

To deploy using a "`LoadBalancer`" service for the UI, use:

```bash
$ kubectl create ns test-ee
namespace/test-ee created
$ ./create-secrets.sh axonserver test-ee
secret/axonserver-license created
secret/axonserver-token created
configmap/axonserver-properties created
$ kubectl apply -f axonserver-sts.yml -n test-ee
statefulset.apps/axonserver created
$ kubectl apply -f axonserver-svc.yml -n test-ee
service/axonserver-gui created
service/axonserver created
$ 
```

To deploy with an Ingress, use:

```bash
$ kubectl create ns test-ee
namespace/test-ee created
$ ./create-secrets.sh axonserver test-ee
secret/axonserver-license created
secret/axonserver-token created
configmap/axonserver-properties created
$ kubectl apply -f axonserver-sts.yml -n test-ee
statefulset.apps/axonserver created
$ kubectl apply -f axonserver-ing.yml -n test-ee
service/axonserver-gui created
service/axonserver created
ingress.networking.k8s.io/axonserver created
$ 
```

The Ingress supplied maps to hostname "`axonserver`", so please make sure that is defined in your hosts file. To create your first user, you can do the following:

```bash
$ ../../axonserver-cli.jar users -t $(cat ../../axonserver.token) -S http://axonserver:80
Name
$ ../../axonserver-cli.jar register-user -t $(cat ../../axonserver.token) -S http://axonserver:80 -u admin -p test -r ADMIN@_admin
$ ../../axonserver-cli.jar users -t $(cat ../../axonserver.token) -S http://axonserver:80
Name
admin
$
```

You can now login with username "`admin`" and password "`test`", and in the "Overview" tab watch how the cluster grows when you scale it to 3 nodes with:

```bash
$ kubectl scale sts axonserver -n test-ee --replicas=3
statefulset.apps/axonserver scaled
$
```