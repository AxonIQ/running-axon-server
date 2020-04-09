#!/bin/bash

docker run -d --rm --name axonserver-se -p 8024:8024 -p 8124:8124 \
    -v `pwd`/axonserver/data:/data \
    -v `pwd`/axonserver/events:/eventdata \
    -v `pwd`/axonserver/config:/config \
    axoniq/axonserver
