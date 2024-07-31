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

## Kubernetes in Docker Desktop

The Community Edition of Docker Desktop can expose services locally in two ways: using a "`LoadBalancer`" type service or using an ingress.

### Exposing services locally using a LoadBalancer

The loadbalancer provided by Docker Desktop is easy to configure, but has some shortcomings that you should be aware of: It will always use "`localhost`" to expose the service, and session affinity does not work. (at the moment) The first means that having two services with a "`LoadBalancer`" type service will get you into trouble, as only the first can claim it. The second means that if your application is scaled and wants the browser to be stateful (for example use a login), then your app must be able to deal with the round-robin distribution of requests. If you have a complex UI, this may result in all backend calls made on a page going to different pods, and you UI needs to cache the actual user credentials to login on all calls, or provide a way to share the session cookie. Axon Server with access control enabled requires session affinity to work, so this option will not work in that case.

### Exposing services locally using an Ingress

The single-node Kubernetes cluster that comes with Docker Desktop has no built-in Ingress controller, which means any Ingress you deploy will never receive any requests. Luckily the standard NGINX Ingress Controller runs fine, but you need to add it manually. How to do this is described in [the NGINX Ingress Controller documentation](https://kubernetes.github.io/ingress-nginx/deploy/#docker-for-mac). Note that this page refers to "Docker for Mac", but it works fine on Windows as well. (Tested on Docker with WSL 2 backend) Basically, you should run this command:

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/cloud/deploy.yaml
```

Please note that you can even do this *after* deploying the Ingress.

For the Ingress, you should add some annotations:

```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: hello-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/affinity: cookie
    # Use affinity-mode "balanced" to allow rebalancing, "persistent" otherwise.
    nginx.ingress.kubernetes.io/affinity-mode: persistent
spec:
  rules:
  - host: hello-ingress
    http:
      paths:
      - backend:
          serviceName: hello-kube
          servicePort: 80
```

The Ingress shown above will require you to add hostname "hello-ingress" to your hosts file, "`/etc/hosts`" on Linux and macOS, "`C:\WINDOWS\System32\drivers\etc\hosts`" on Windows.

## Running Axon Server in Kubernetes

For Kubernetes we'll run Axon Server as a StatefulSet.

* [**Running Axon Server (Single node) in Kubernetes**](./1-k8s-se)
* [**Running Axon Server (Cluster) in Kubernetes**](./2-k8s-ee)
* [**Running Axon Server (Cluster) in Kubernetes using Singleton StatefulSets**](./3-k8s-ee-ssts)
* [**Installing Axon Server EE with Helm v3**](./4-helm-se)
