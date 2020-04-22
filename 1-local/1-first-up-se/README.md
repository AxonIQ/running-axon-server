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

## First up

To start Axon Server, you could simply ensure the JAR file has execute rights, and then run it, as it is an Spring-boot Executable JAR. However, this also changes the working directory for Axon Server to be the same as where the JAR is, which is not what we want in this case. So simply run the `java` command with the "`-jar`" option.

**NOTE** Java 8 and 11 will both work.

```bash
$ java -jar ../../axonserver.jar
```

Afterwards you'll see a directory named "`data`" created here with a subdirectory "`default`" for the event store. The ControlDB is also created in `data`, while a so-called PID file is made in the current directory. You can quit Axon Server just by pressing Control-C, and it will clean up the PID file. If you start it in the background, you can use the number in the PID file to find the process id you need to "kill".