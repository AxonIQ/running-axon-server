#!/bin/bash

#    Copyright 2020 AxonIQ B.V.

#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at

#        http://www.apache.org/licenses/LICENSE-2.0

#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

VERSION=ee
if [ $# -gt 2 ] ; then
    if [[ "$1" == "--version" ]] ; then
        VERSION=$2
        shift 2
    else
        echo "Unknown option: \"$1\"."
        echo "Usage: $0 [--version <version>] <node-name>"
        exit 1
    fi
fi
if [[ $# != 1 ]] ; then
    echo "Usage: $0 [--version <version>] <node-name>"
    exit 1
elif [ ! -d $1 ] ; then
    echo "No directory for node \"$1\" found."
    exit 1
fi

NODE_NAME=$1

if [[ "${NODE_NAME}" == "node-1" ]] ; then
    LICENSE_FILE=axoniq.license
    if [ ! -s ${NODE_NAME}/${LICENSE_FILE} -a -s ../../${LICENSE_FILE} ] ; then
        echo "Adding license file to node workdir."
        cp ../../${LICENSE_FILE} ./${NODE_NAME}/
    fi
fi

cd ./${NODE_NAME}
java -jar ../../../axonserver-${VERSION}.jar
