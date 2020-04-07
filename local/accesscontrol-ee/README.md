## Access control for Axon Server EE

In this cluster a few new settings have been applied:

* `axoniq.axonserver.accesscontrol.enabled` has been set to `true`, enabling access control,
* `axoniq.axonserver.accesscontrol.internal-token` has been set to a random UUID, "`cf8d5032-4a43-491c-9fbf-f28247f63faf`". Ok, not too random actually, it is the same as the token for SE. You won't reuse it in production, right?
* `logging.config` has been set to "`file:logback-spring.xml`", which forces the logging system to read the supplied logfile configuration.

The logging configuration in `logback-spring.xml` will case the creation of two log files, one "normal" one named "`axonserver.log`", and a second one named "`axonserver-AUDIT.log`" for the audit log.

As with "First Up EE", start node-1 with:
```bash
$ ./startup.sh node-1
$
```
You can stop a node with `shutdown.sh` and clean up with `cleanup.sh`.