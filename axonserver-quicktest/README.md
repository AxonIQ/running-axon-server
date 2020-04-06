## The Axon Server QuickTest Application

The program in this directory provides a small and quick test to see if Axon Server is up anmd running. It requires Java 11 and Maven to build, but an executable JAR is included as well that you can run.

### Example: Run from Maven

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