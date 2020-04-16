#!/bin/bash

cp ../../axonserver-ee.jar build/axonserver.jar
cp ../../axonserver-cli.jar build/axonserver-cli.jar

cd build
docker build --tag axonserver-ee:running .
