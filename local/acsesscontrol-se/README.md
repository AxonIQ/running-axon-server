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