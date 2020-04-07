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

The properties files in these three directories use only a few settings:

* `axoniq.axonserver.name` is set to the name of the node, resp. "node-1", "node-2", and "node-3"
* `axoniq.axonserver.hostname` is set to localhost
* `server.port`, `axoniq.axonserver.port`, and `axoniq.axonserver.internal-port` are used to ensure each node uses different ports.
* `axoniq.axonserver.autocluster.first` and `...autocluster.contexts` are used to allow the cluster to self-initialize.

To stop the cluster, either use Control-C in all three shells, or run `shutdown.sh` in a separate shel;l three times. It will use the PID file to determine which process to kill. `cleanup.sh` will do so in all three directories.