# Running Axon Server

The files in this repo accompany the "Running Axon Server" Blog series.

* [**local**](./local) contains scripts and configuration files for running Axon Server as a local process.
* [`docker`] contains the files for "pure" Docker.
* [`docker-compose`] is for running with Docker-compose.
* [`k8s`] is all about Kubernetes deployments.
* The [`ee-image`] directory contains the files for making an Axon Server EE Docker image.

Please make sure a copy of the JAR files is in this (central) directory, named:

* The Axon Server SE jar file: `axonserver.jar`
* The Axon Server CLI jar file: `axonserver-cli.jar`
* The Axon Server EE jar file (if applicable): `axonserver-ee.jar`
