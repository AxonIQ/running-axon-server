## Running Axon Server Docker (Single node) with docker-compose

Putting a `startup.sh` and `shutdown.sh` here felt like a bit of overkill, as you can start and stop Axon Server with the "`docker-compose`" command. I have included two versions of the `docker-compose.yml` file here:

* `docker-compose.yml` is the Unix-only (for now) version with named volumes.
* `docker-compose-unnamed.yml` will also run on Windows CMD and WSL2, using unnamed volumes. Note that with the 'stable build' of Docker for Desktop, you'll need to enable sharing for the drive on which you want to run this. Under WSL (first release) this will require sharing of drive `C:`, but running the docker client there is a bit of a challenge anyway, because you'll have to use either integration trickery or else open the Docker API unsecured.

To clean up on Linux, MacOS, and WSL2, you'll have to run `sudo`,as the files created in the volumes are owned by "root".

### Cleaning up

Run the "`cleanup.sh`" script to throw away all locally created files. Not this will not actually delete the Docker volumes, so they won't need to be recreated when you next run Axon Server.