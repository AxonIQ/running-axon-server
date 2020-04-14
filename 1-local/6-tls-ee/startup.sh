#!/bin/bash

if [[ $# != 1 ]] ; then
    echo "Usage: $0 <node-name>"
    exit 1
elif [ ! -d $1 ] ; then
    echo "No directory for node \"$1\" found."
    exit 1
fi

cd $1
AXONIQ_LICENSE=../../../axoniq.license nohup java -jar ../../../axonserver-ee.jar >/dev/null 2>&1 &
