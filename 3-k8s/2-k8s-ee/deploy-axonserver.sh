#!/usr/bin/env bash

#    Copyright 2020,2021 AxonIQ B.V.

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

BINDIR=../../bin

SYSTEM_TOKEN_FILE=./axonserver.token
INTERNAL_TOKEN_FILE=./axonserver.internal-token
echo "Generating tokens"
echo ""
${BINDIR}/gen-token.sh ${SYSTEM_TOKEN_FILE}
${BINDIR}/gen-token.sh ${INTERNAL_TOKEN_FILE}

INTERNAL_TOKEN=$(cat ${INTERNAL_TOKEN_FILE})
echo "Generating files"
echo ""
for src in *.tmpl ; do
    dst=$(basename ${src} .tmpl)
    echo "Generating ${dst}"
    sed -e "s/__SVC_NAME__/${SVC_NAME}/g" \
        -e "s/__NS_NAME__/${NS_NAME}/g" \
        -e "s/__INTERNAL_TOKEN__/${INTERNAL_TOKEN}/g" < ${src} > ${dst}
done

echo ""
echo "Creating Namespace if needed"
echo ""
kubectl create ns ${NS_NAME} --dry-run=client -o yaml | kubectl apply -f -

echo ""
echo "Creating/updating Secrets and ConfigMap"
echo ""
for f in ../../axoniq.license ${SYSTEM_TOKEN_FILE} ; do
    secret=$(basename ${f} | tr '.' '-')
    descriptor=${secret}.yml
    kubectl create secret generic ${secret} --from-file=${f} --dry-run -o yaml > ${descriptor}
    kubectl apply -f ${descriptor} -n ${NS_NAME} 
done

for f in axonserver.properties ; do
    cfg=$(basename ${f} | tr '.' '-')
    descriptor=${cfg}.yml
    kubectl create configmap ${cfg} --from-file=${f} --dry-run -o yaml > ${descriptor}
    kubectl apply -f ${descriptor} -n ${NS_NAME} 
done

echo ""
echo "Deploying/updating StatefulSet"
echo ""
kubectl apply -f axonserver-sts.yml -n ${NS_NAME}
