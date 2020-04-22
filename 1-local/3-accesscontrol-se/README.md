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

## Access control enabled

In this run, access control is enabled. Also, to make running Axon Server a bit more "clean", it is started in the background with logging configured to use a file named "`axonserver.log`". Since `shutdown.sh` still uses the PID file, you can stop it easily that way. Apart from enabling accesscontrol, a token is also configured with value "cf8d5032-4a43-491c-9fbf-f28247f63faf".

To run the CLI for creating the initial user, use:

```bash
$ ../../axonserver-cli.jar register-user -t cf8d5032-4a43-491c-9fbf-f28247f63faf -u admin -p test -r ADMIN
$ ../../axonserver-cli.jar users -t cf8d5032-4a43-491c-9fbf-f28247f63faf
Name
admin
$ 
```