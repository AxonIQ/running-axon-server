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

## TLS enabled fro Axon Server SE

In this run, not only access control, but also TLS is enabled. To generate the required certificate, you can use the supplied script `gen-self-cert.sh`:

```bash
$ ./gen-self-cert.sh -c NL --state Provincie --city Stad --org MegaCorp axonserver.megacorp.com
Generating a RSA private key
....+++++
......+++++
writing new private key to 'tls.key'
-----
Signature ok
subject=C = NL, ST = Provincie, L = Stad, O = MegaCorp, CN = axonserver.megacorp.com
Getting Private key
$ 
```

If you look in the directory, you'll find a few new files:
* `tls.csr` - The Certificate Signing Request.
* `tls.key` - An unprotected private key in a PEM encoded file.
* `tls.crt` - An unprotected X509 certificate encoded in a PEM encoded file.
* `tls.p12` - A PKCS12 keystore containing the key and certificate under alias "axonserver", with password "axonserver".

The properties file is preconfigured to use these files.

**Notes**
* The X509 certificate format _is_ important for the client gRPC port.
* The PKCS12 format is not used often by other applications than Java ones. Spring-boot requires this format for its "main" HTTP port.
* You'll need to put the FQDN, "`axonserver.megacorp.com`" above, in your `/etc/hosts` file ("`C:\Windows\System32\drivers\etc\host`" for non-WSL Windows) with e.g. "`127.0.0.1`" as address to get this to work, although browsers will still complain about it, as it is a self-signed certificate.
* I have seen reports that some browsers will ignore the `hosts` file, either because it uses DNS over HTTPS only, or because it will consider words that fail a DNS lookup as input for a search query instead.