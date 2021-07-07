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

## Running Axon Server EE in Kubernetes using Singleton StatefulSets

**Note** We at AxonIQ are aware that many of our customners run Axon Server in Kubernetes or want to run it there. The files in this directory are to help you on your way with developing a deployment plan based on "Singleton StatefulSets". For more information, please [read this article](https://axoniq.io/blog-overview/revisiting-axon-server-in-containers).

### Deployment Plan

The deployment plan for the files in this directory is as follows:

* Every Axon Server node will be deployed as a `StatefulSet` scaled to 1 (one) instance.
* Every Axon Server node will have a "Headless Service" associated with it, with the same name as the `StatefulSet`. This will make Kubernetes create a DNS entry with this same name, in a subdomain named after the `NameSpace`, suffixed with "`svc.cluster.local`"
* A common secret for the system token
* A common secret for the license
* A common properties file is deployed as a `ConfigMap`, which sets:

    - The domain (and internal domain) to the FQDN of the `NameSpace`
    - The autocluster options for contexts "`_admin`" and "`default`", and the first node using the FQDN of the Headless Service
    - Access-control to enabled with an internal token
    - The internal token path is set pointing at the associated secret
    - The license path is set pointing at the associated secret

### How to deploy

First deploy the secrets and ConfigMap with:

```text
$ ./deploy-secrets axonserver-1 running-ee
```

