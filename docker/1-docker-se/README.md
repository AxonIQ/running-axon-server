## Running Axon Server SE in Docker

To start Axon Server SE in Docker, use "`startup.sh`" or "`startup.cmd`". It will map the "`data`", "`events`", and "`config`" directories in the current directory as volumes, as discussed in my Blog. "`shutdown.sh`" and "`shutdown.cmd`" will stop the container and remove it. Note that this will _not_ actually remove the Event Store and ControlDB, as they are persisted in the volumes' directories. The "`cleanup.sh`" and "`cleanup.cmd`" scripts will clean those directories.
