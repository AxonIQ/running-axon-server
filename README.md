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

# Running Axon Server

The files in this repo accompany the "Running Axon Server" Blog series.

1. [**1-local**](./1-local) contains scripts and configuration files for running Axon Server as a local process.
1. [**2-docker**](./2-docker) contains the files for "pure" Docker.
1. [**3-k8s**](./3-k8s) is all about Kubernetes deployments.
1. The [**ee-image**](./2-docker/0-ee-docker-image) directory (under "2-docker") contains the files for making an Axon Server EE Docker image.
1. Finally, the [**Axon Server QuickTest**](./axonserver-quicktest) directory provides a small app to verify that Axon Server is up and running.

Please make sure a copy of the JAR files is in this (central) directory, named:

* The Axon Server SE jar file "`axonserver.jar`"
* The Axon Server CLI jar file "`axonserver-cli.jar`"

If you're working with Axon Server Enterprise Edition, you'll also need:
* The Axon Server EE jar file "`axonserver-ee.jar`".
* A valid license file "`axoniq.licensse`".
* A system token file "`axonserver-token`". Generate one using:

    ```bash
    uuidgen > axonserver.token
    ```

There are some scripts that make life easy and will be repeated over several of the directories:
* "`startup.sh`" will start Axon Server.
* "`shutdown.sh`" will stop Axon Server.
* "`cleanup.sh`" will clean the Axon Server created files.

For clusters, the start and stop scripts expect the name of the node as parameter, cleanup will wipe all nodes.
