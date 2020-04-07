## First-up for Axon Server EE

To enable an easy start for a three-node cluster, you'll find three directories here, one for each node. Open three shells and run Axon Server in each with:

```bash
$ java -jar ../../../axonserver-ee.jar
```

The properties files in these three directories use only a few settings:

* `axoniq.axonserver.name` is set to the name of the node, resp. "node-1", "node-2", and "node-3"
* `axoniq.axonserver.hostname` is set to localhost