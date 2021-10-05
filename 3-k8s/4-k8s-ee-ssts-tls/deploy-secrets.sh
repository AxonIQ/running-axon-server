#!/usr/bin/env bash

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

FIRST_NAME=axonserver-1
FIRST_NS_NAME=
NS_NAME=running-ee
PUBLIC_DOMAIN=

Usage () {
    echo "Usage: $0 [<options>]"
    echo ""
    echo "Options:"
    echo "  --first <name>     Name of the first node, default 'axonserver-1'."
    echo "  --first-ns <name>  Namespace of the first node, if unequal to current one."
    echo "  --namespace <name> Namespace to deploy to, default 'running-ee'. Shorthand option '-n'."
    echo "  --domain <name>    The domain to use for client applications, default same as internal. Shorthand option '-d'."
    exit 1
}

options=$(getopt -l 'first:,namespace:,domain:' -- 'n:d:' "$@")
[ $? -eq 0 ] || {
    Usage
}
eval set -- "$options"
while true; do
    case $1 in
    --first)        FIRST_NAME=$2    ; shift ;;
    --first-ns)     FIRST_NS_NAME=$2 ; shift ;;
    --namespace|-n) NS_NAME=$2       ; shift ;;
    --domain|-d)    PUBLIC_DOMAIN=$2 ; shift ;;
    --)
        shift
        break
        ;;
    esac
    shift
done

if [[ $# != 0 ]] ; then
    Usage
fi

if [[ "${FIRST_NS_NAME}" == "" ]] ; then
    FIRST_NS_NAME=${NS_NAME}
fi
if [[ "${PUBLIC_DOMAIN}" == "" ]] ; then
    PUBLIC_DOMAIN=${NS_NAME}.svc.cluster.local
fi

BINDIR=../../bin

SYSTEM_TOKEN_FILE=./axonserver.token
INTERNAL_TOKEN_FILE=./axonserver.internal-token
echo "Generating tokens"
echo ""
${BINDIR}/gen-token.sh ${SYSTEM_TOKEN_FILE}
${BINDIR}/gen-token.sh ${INTERNAL_TOKEN_FILE}

mkdir -p ssl

if [ ! -s ssl/internal-ca.crt ] ; then
    echo ""
    echo "Generating CA certificate for '${NS_NAME}.svc.cluster.local'"
    ./gen-ca.sh -o ssl/internal-ca ${NS_NAME}.svc.cluster.local
fi

INTERNAL_TOKEN=$(cat ${INTERNAL_TOKEN_FILE})
echo ""
echo "Generating files"
echo ""
for src in axonserver.properties.tmpl ; do
    dst=$(basename ${src} .tmpl)
    echo "Generating ${dst}"
    sed -e "s/__FIRST_NAME__/${FIRST_NAME}.${FIRST_NS_NAME}/g" \
        -e "s/__NS_NAME__/${NS_NAME}/g" \
        -e "s/__INTERNAL_TOKEN__/${INTERNAL_TOKEN}/g" \
        < ${src} > ${dst}
done

echo ""
echo "Creating Namespace if needed"
echo ""
kubectl create ns ${NS_NAME} --dry-run=client -o yaml | kubectl apply -f -

echo ""
echo "Creating/updating CA certificate secret"
echo ""

secret=internal-ca
descriptor=${secret}.yml
kubectl create secret generic ${secret} --from-file=ssl/internal-ca.crt --dry-run=client -o yaml > ${descriptor}
kubectl apply -f ${descriptor} -n ${NS_NAME}

echo ""
echo "Creating/updating other Secrets and ConfigMap"
echo ""

for f in ../../axoniq.license ${SYSTEM_TOKEN_FILE} ; do
    secret=$(basename ${f} | tr '.' '-')
    descriptor=${secret}.yml
    kubectl create secret generic ${secret} --from-file=${f} --dry-run=client -o yaml > ${descriptor}
    kubectl apply -f ${descriptor} -n ${NS_NAME} 
done

for f in axonserver.properties ; do
    cfg=$(basename ${f} | tr '.' '-')
    descriptor=${cfg}.yml
    kubectl create configmap ${cfg} --from-file=${f} --dry-run=client -o yaml > ${descriptor}
    kubectl apply -f ${descriptor} -n ${NS_NAME} 
done
