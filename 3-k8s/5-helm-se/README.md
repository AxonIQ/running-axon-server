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

# Deploy Axon Server (Single node) with Helm v3

See the provided chart.

## Docker Desktop Ingress controller

The 1-node Kubernetes cluster that comes with Docker Desktop can handle a "`LoadBalancer`" type service, but not very well. (Session affinity does not work yet) An alternative is to use an Ingress Controller, but [the installation guide for NGINX](https://kubernetes.github.io/ingress-nginx/deploy/) only mentions Docker for Mac. The command below installs the controller, and an Ingress will correctly refer to it when deployed, but I have not yet been able to get this to work in Windows with the WSL 2 version of Docker Desktop.

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/cloud/deploy.yaml
```

## Minikube

For Minikube you can enable the "ingress" addon, which will allow the deployment of Ingresses.