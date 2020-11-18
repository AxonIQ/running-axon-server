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

## First-up for Axon Server EE

To enable an easy start for a three-node cluster, you'll find three directories here, one for each node. Open three shells and run Axon Server in each with:

```bash
$ cd node-1
$ java -jar ../../../axonserver-ee.jar
```

Or, if you want to use the supplied scripts:

```bash
$ ./startup.sh node-1
```

To start AxonServer in the background, and create a working directory if needed, use:
```bash
$ ./startup-bg.sh node-1
```
or, start a whole cluster at once:
```bash
$ for i in $(seq 3) ; do ./startup-bg.sh node-${i} ; done
```

The properties files in these three directories use only a few settings:

* `axoniq.axonserver.name` is set to the name of the node, resp. "node-1", "node-2", and "node-3"
* `axoniq.axonserver.hostname` is set to localhost
* `server.port`, `axoniq.axonserver.port`, and `axoniq.axonserver.internal-port` are used to ensure each node uses different ports.
* `axoniq.axonserver.autocluster.first` and `...autocluster.contexts` are used to allow the cluster to self-initialize.

To stop the cluster, either use Control-C in all three shells, or run `shutdown.sh` in a separate shell three times. It will use the PID file to determine which process to kill. `cleanup.sh` will do so in all three directories. Because trying to stop a node that isn't running will simply skip the action, you could use the following to "clean up" in bulk:
```bash
$ for i in $(seq 3) ; do ./shutdown.sh node-${i} ; done ; ./cleanup.sh ; rm */axonserver.log
```
