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

# The Axon Server QuickTest Application

The program in this directory provides a small and quick test to see if Axon Server is up anmd running. It requires Java 11 and Maven to build, but an executable JAR is included as well that you can run.

## Spring Profiles

This app uses Spring profiles. You can activate profiles by setting the "`spring.profiles.active`" property, or the "`SPRING_PROFILES_ACTIVE`" environment variable.

* "`default`"

    If You specify no profile, "`default`" is activated instead. This application uses a local Axon Configuration in that case, so the test command and event will stay within the app, and the eventstore is in-memory.

* "`axonserver`"

    With this profile the "`AxonServerConnector`" is configured, and the app will attempt to connect to Axon Server.

* "`subscribing`"

    Adding this profile will make the app use a `SubscribingEventProcessor` rather than the default `TrackingEventProcessor`.

## Other configuration options

You can use the "`ms-delay`" property (or "`MS_DELAY`" environment variable) to set the number of milliseconds delay at the end of the testrun.

## Example: Run from Maven

```bash
$ mvn spring-boot:run
[INFO] Scanning for projects...
[INFO]
[INFO] ---------------< io.axoniq.testing:axonserver-quicktest >---------------
[INFO] Building axonserver-quicktest 4.3-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO]
[INFO] >>> spring-boot-maven-plugin:2.2.6.RELEASE:run (default-cli) > test-compile @ axonserver-quicktest >>>
[INFO]
[INFO] --- maven-resources-plugin:3.1.0:resources (default-resources) @ axonserver-quicktest ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 1 resource
[INFO] Copying 0 resource
[INFO]
[INFO] --- maven-compiler-plugin:3.8.1:compile (default-compile) @ axonserver-quicktest ---
[INFO] Nothing to compile - all classes are up to date
[INFO]
[INFO] --- maven-resources-plugin:3.1.0:testResources (default-testResources) @ axonserver-quicktest ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory /home/bertl/dev/AxonIQ/running-axon-server/axonserver-quicktest/src/test/resources
[INFO]
[INFO] --- maven-compiler-plugin:3.8.1:testCompile (default-testCompile) @ axonserver-quicktest ---
[INFO] No sources to compile
[INFO]
[INFO] <<< spring-boot-maven-plugin:2.2.6.RELEASE:run (default-cli) < test-compile @ axonserver-quicktest <<<
[INFO]
[INFO]
[INFO] --- spring-boot-maven-plugin:2.2.6.RELEASE:run (default-cli) @ axonserver-quicktest ---
[INFO] Attaching agents: []
2020-04-06 17:03:30.543  INFO 4797 --- [mandProcessor-0] i.a.testing.quicktester.TestHandler      : handleCommand(): src = "QuickTesterApplication.getRunner", msg = "Hi there!".
2020-04-06 17:03:30.608  INFO 4797 --- [.quicktester]-0] i.a.testing.quicktester.TestHandler      : handleEvent(): msg = "QuickTesterApplication.getRunner says: Hi there!".
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 20.765 s
[INFO] Finished at: 2020-04-06T17:03:30+02:00
[INFO] ------------------------------------------------------------------------
```

### Example: Run standalone:

```bash
$  ./axonserver-quicktester.jar
2020-04-06 17:09:49.547  INFO 6385 --- [mandProcessor-0] i.a.testing.quicktester.TestHandler      : handleCommand(): src = "QuickTesterApplication.getRunner", msg = "Hi there!".
2020-04-06 17:09:49.552  INFO 6385 --- [.quicktester]-0] i.a.testing.quicktester.TestHandler      : handleEvent(): msg = "QuickTesterApplication.getRunner says: Hi there!".
```

### Example: Run on local or Docker hosted cluster:

```bash
$ AXON_AXONSERVER_SERVERS=localhost,localhost:8125,localhost:8126 ./axonserver-quicktester.jar
2020-04-06 17:09:49.547  INFO 6385 --- [mandProcessor-0] i.a.testing.quicktester.TestHandler      : handleCommand(): src = "QuickTesterApplication.getRunner", msg = "Hi there!".
2020-04-06 17:09:49.552  INFO 6385 --- [.quicktester]-0] i.a.testing.quicktester.TestHandler      : handleEvent(): msg = "QuickTesterApplication.getRunner says: Hi there!".
```