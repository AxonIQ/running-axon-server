## Building an Axon Server EE image

For Axon Server EE we need to build an image, as there is not public one. The `Dockerfile` used here expects the JAR files in the build directory, so I added a script to copy them from the base directory of this repo. It expects Axon Server EE to be in a file named "`axonserver-ee.jar`", and the CLI in a file named "`axonserver-cli.jar`".

To build the image as "`axonserver-ee:running`", just run "`./build-image.sh`". For a custom tag, pass it as parameter, e.g. "`./build-image.sh repo/image:version`".

**Note** This `Dockerfile` already includes both the use of username "axonserver" and user-id `1001`.