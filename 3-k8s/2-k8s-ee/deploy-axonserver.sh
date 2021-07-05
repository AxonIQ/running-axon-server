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

if [[ $# != 2 ]] ; then
    echo "Usage: $0 <service-name> <namespace>"
    exit 1
fi

SVC_NAME=$1
NS_NAME=$2

echo "Generating files"
echo ""
for src in *.tmpl ; do
    dst=$(basename ${src} .tmpl)
    echo "Generating ${dst}"
    sed -e s/__SVC_NAME__/${SVC_NAME}/g -e s/__NS_NAME__/${NS_NAME}/g < ${src} > ${dst}
done

echo ""
echo "Creating Namespace if needed"
echo ""
kubectl create ns test-ee --dry-run=client -o yaml | kubectl apply -f -

echo ""
echo "Creating/updating Secrets and ConfigMap"
echo ""
kubectl create secret generic axonserver-license --from-file=../../axoniq.license -n ${NS_NAME} --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret generic axonserver-token --from-file=../../axonserver.token -n ${NS_NAME} --dry-run=client -o yaml | kubectl apply -f -
kubectl create configmap axonserver-properties --from-file=axonserver.properties -n ${NS_NAME} --dry-run=client -o yaml | kubectl apply -f -

echo ""
echo "Deploying/updating StatefulSet"
echo ""
kubectl apply -f axonserver-sts.yml -n ${NS_NAME}
