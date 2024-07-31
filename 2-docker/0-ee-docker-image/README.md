## An Axon Server Docker image

AxonIQ provides a ready to use [Axon Server image](https://hub.docker.com/r/axoniq/axonserver). There are two images available: one with Axon Server running as the user "`root`" and one with Axon Server running as user "`axonserver`". Both images are based on the "eclipse-temurin" images. They include a (limited) shell that allows you to connect "into" the running image and perform some commands. 

* The "`root`" image of version X.Y.Z is available as "`axoniq/axonserver:X.Y.Z`". This image is particularly useful for running in Docker Desktop, as it will not have any trouble creating files and directories as user "`root`".
* The "`nonroot`" image of version X.Y.Z is available as "`axoniq/axonserver-enterprise:X.Y.Z-nonroot`". This image is more secure and useful in Kubernetes and OpenShift clusters. You should take care to declare the user- and group-id, both of which are `1001` and are named "`axonserver`". Doing this will ensure that any mounted volumes will be writable by the user running Axon Server.

The images export the following volumes:

* "`/axonserver/config`"

  This where you can add configuration files, such as an additional `axonserver.properties` and the license file, although you can also opt to use e.g. Kubernetes or Docker-compose secrets. Note that Axon Server EE assumes it can write to the directory configured with "`axoniq.axonserver.enterprise.licenseDirectory`", so you don't have to put the license on all nodes.
* "`/axonserver/data`"

  This is where the ControlDB, the PID file, and a copy of the application logs are written to.
* "`/axonserver/events`"

  In this volume the Event Store is created, with a single directory per context.
* "`/axonserver/log`"

  In this volume the Replication Logs are created, with a single directory per Replication Group.
* "`/axonserver/exts`"

  In this volume you can place Extension JAR-files, such as the LDAP and OAuth2 extensions.
* "`/axonserver/plugins`"

  In this volume Axon Server will place all uploaded plugins.

## Building you own Image

**NOTE** The files in this directory are meant as an example and can be used as a base for your own solution. They are not intended to provide a ready-to-use, hardened solution, AxonIQ approved and supported for production use. The fact publishing of these files does in no way imply any warrenties.

The `Dockerfile` used here expects the JAR files in the build directory, so I added a script to copy them from the base directory of this repository. It expects Axon Server to be in a file named "`axonserver.jar`", and the CLI in a file named "`axonserver-cli.jar`".

To build the image as "`axonserver:running`", just run "`./build-image.sh`". For a custom tag, pass it as parameter, e.g. "`./build-image.sh repo/image:version`".

**Note** This `Dockerfile` already includes both the use of username "axonserver" and user-id `1001`, just like in the public "nonroot" image.