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

if [[ $# != 1 ]] ; then
    echo "Usage: $0 <node-name>"
    exit 1
fi

NODE=$1
NODE_NR=$(echo ${NODE} | sed -e 's/^.*-\([[:digit:]]*\)$/\1/')

if [ ! -d ${NODE} ] ; then
    echo "Creating directory for node \"${NODE}\"."
    mkdir ${NODE}
fi
cd ${NODE}
PROPS=./axonserver.properties
if [ ! -s ${PROPS} ] ; then
    echo "Creating property file for node \"${NODE}\"."
    (
        echo "axoniq.axonserver.name=${NODE}"
        echo "axoniq.axonserver.hostname=localhost"
        echo "server.port=$(expr 8023 + ${NODE_NR})"
        echo "axoniq.axonserver.port=$(expr 8123 + ${NODE_NR})"
        echo "axoniq.axonserver.internal-port=$(expr 8223 + ${NODE_NR})"
        echo "axoniq.axonserver.autocluster.first=localhost"
        echo "axoniq.axonserver.autocluster.contexts=_admin"
    ) >> ${PROPS}
fi

AXONIQ_LICENSE=../../../axoniq.license nohup java -jar ../../../axonserver-ee.jar >>./axonserver.log 2>&1 &