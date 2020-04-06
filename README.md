# Running Axon Server

The files in this repo accompany the "Running Axon Server" Blog series.

1. [**local**](./local) contains scripts and configuration files for running Axon Server as a local process.
1. [**docker**](./docker) contains the files for "pure" Docker.
1. [**docker-compose**](./docker-compose) is for running with Docker-compose.
1. [**k8s**](./k8s) is all about Kubernetes deployments.
1. The [**ee-image**](./ee-image) directory contains the files for making an Axon Server EE Docker image.
1. Finally, the [**Axon Server QuickTest**](./axonserver-quicktest) directory provides a small app to verify that Axon Server is up and running.

Please make sure a copy of the JAR files is in this (central) directory, named:

* The Axon Server SE jar file: `axonserver.jar`
* The Axon Server CLI jar file: `axonserver-cli.jar`
* The Axon Server EE jar file (if applicable): `axonserver-ee.jar`
