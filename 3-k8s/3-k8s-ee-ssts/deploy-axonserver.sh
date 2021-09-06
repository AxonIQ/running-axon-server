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

if [[ $# != 3 ]] ; then
    echo "Usage: $0 <node-name> <cluster-name> <namespace>"
    exit 1
fi

STS_NAME=$1
CLUSTER_NAME=$2
NS_NAME=$3

echo "Generating files"
echo ""
TEMPLATE=axonserver-sts.yml.tmpl
DESCRIPTOR=${STS_NAME}.yml
echo "Generating ${DESCRIPTOR}"
sed -e s/__STS_NAME__/${STS_NAME}/g \
    -e s/__CLUSTER_NAME__/${CLUSTER_NAME}/g \
    -e s/__NS_NAME__/${NS_NAME}/g < ${TEMPLATE} > ${DESCRIPTOR}

echo ""
echo "Deploying/updating StatefulSet"
echo ""
kubectl apply -f ${DESCRIPTOR} -n ${NS_NAME}
