## Running Axon Server EE in Kubernetes

**Note** We at AxonIQ are aware that many of our customners run Axon Server in Kubernetes or want to run it there.
The files in this directory are to help you on your way, but there are so many things you might want to tune, that we do
not want to present this as **the definitive best way.**

The `create-secrets.sh` script will generate de `axonserver.properties` ConfigMap, license secret, and system-token secret, given a service name and namespace. The example "svc" file uses "axonserver" for the headless service, so that is what you should use for this particular example.


