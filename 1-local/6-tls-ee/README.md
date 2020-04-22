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

## TLS for Axon Server EE

In this cluster all three nodes have been configured with TLS enabled, and the names are changed to reflect the three certificates:

* `axoniq.axonserver.name` and `axoniq.axonserver.hostname` have been set to "`axonserver-1`" to "`axonserver-3`"
* `axoniq.axonserver.domain` is set to a test domain, "megacorp.com".
* Because we now have a domain set, the "`...autocluster.first`" setting needs a FQDN so it will match correctly.
* The first group of SSL settings are for the HTTP port, and configure it with the PKCS12 keystore.
* The second group of SSL settings are for the gRPC-ports, and configure the PEM key and certificate, as well as the (self-signed) CA certificate to validate the other nodes' certificates.

As with "First Up EE", start node-1 with:
```bash
$ ./startup.sh node-1
$
```
You can stop a node with `shutdown.sh` and clean up with `cleanup.sh`.

**NOTES**
* When you want to add the first user, change to node-1's directory to let the CLI pick up the system token, and make sure to run it with `java -jar` so the current working directory isn't changed to the location of the JAR file. Als you'll need to adjust the URL so it mentions HTTPS:

    `java -jar ../../../axonserver-cli.jar users -S https://axonserver-1.megacorp.com:8024`

* The `gen-ca-cert.sh` script can be used (just like in the SE example) to generate a self-signed certificate, which will be used as Certificate Authority:

    `./gen-ca.sh -c NL --state Provincie --city Stad --org MegaCorp axonserver.megacorp.com`

* The `gen-cert.sh` script can be used to generate the certificates for the nodes, for example:

    `./gen-cert.sh -c NL --state Provincie --city Stad --org MegaCorp axonserver-1.megacorp.com`

* As before, you'll need to add the FQDNs into your hosts file.