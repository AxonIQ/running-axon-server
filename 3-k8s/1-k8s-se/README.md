## Running Axen Server SE in Kubernetes

To deploy, I suggest you create a separate namespace:

```bash
$ kubectl create ns running-axon-server
namespace/running-axon-server created
$ kubectl apply -f axonserver.yml -n running-axon-server
statefulset.apps/axonserver created
service/axonserver-gui created
service/axonserver created
$
```

If you create an image from the quicktester and have it pushed to a repo that Kubernetes can use, you can test the deployment:
```bash
$ kubectl run axonserver-quicktest --image=repo/quicktest:running --env AXON_AXONSERVER_SERVERS=axonserver-0.axonserver --attach stdout -n running-axon-server --rm --generator=run-pod/v1
If you don't see a command prompt, try pressing enter.
2020-04-17 09:43:19.057  INFO 1 --- [mandProcessor-0] i.a.testing.quicktester.TestHandler      : handleCommand(): src = "QuickTesterApplication.getRunner", msg = "Hi there!".
2020-04-17 09:43:19.194  INFO 1 --- [.quicktester]-0] i.a.testing.quicktester.TestHandler      : handleEvent(): msg = "QuickTesterApplication.getRunner says: Hi there!".
$
```