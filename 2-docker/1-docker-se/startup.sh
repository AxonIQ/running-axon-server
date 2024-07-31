#!/bin/bash

docker run -d --rm --name axonserver -p 8024:8024 -p 8124:8124 \
    -v `pwd`/data:/data \
    -v `pwd`/events:/eventdata \
    -v `pwd`/config:/config \
    -e AXONIQ_AXONSERVER_STANDALONE=true \
    axoniq/axonserver
