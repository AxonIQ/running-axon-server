#!/usr/bin/env bash

#    Copyright 2021 AxonIQ B.V.

#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at

#        http://www.apache.org/licenses/LICENSE-2.0

#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

NS_NAME=running-ee
STS_NAME=
CLUSTER_NAME=axonserver
VERSION=latest
IMAGE=

Usage () {
    echo "Usage: $0 [<options>] <node-name>"
    echo ""
    echo "Options:"
    echo "  -n <name>  Namespace to deploy to, default '${NS_NAME}'."
    echo "  -c <name>  Name for the cluster, default '${CLUSTER_NAME}'."
    echo "  -v <version>  What version of Axon Server to deploy, default '${VERSION}'."
    echo "  -i <image>    The container image to deploy, if not Axon Server. Using this will ignore the version."
    exit 1
}

options=$(getopt 'n:c:v:i:' "$@")
[ $? -eq 0 ] || {
    Usage
}
eval set -- "$options"
while true; do
    case $1 in
    -n)    NS_NAME=$2       ; shift ;;
    -c)    CLUSTER_NAME=$2  ; shift ;;
    -v)    VERSION=$2       ; shift ;;
    -i)    IMAGE=$2         ; shift ;;
    --)
        shift
        break
        ;;
    esac
    shift
done

if [[ $# != 1 ]] ; then
    Usage
fi

if [[ "${IMAGE}" == "" ]] ; then
    IMAGE=axoniq/axonserver-enterprise:${VERSION}-jdk-11-dev-nonroot
fi

STS_NAME=$1

mkdir -p ssl/${STS_NAME}

FQDN=${STS_NAME}.${NS_NAME}.svc.cluster.local
echo ""
echo "Axon Server will be available as ${FQDN}, using image '${IMAGE}'"
if [ ! -s ssl/${STS_NAME}/fqdn.txt ] ; then
    echo ${FQDN} > ssl/${STS_NAME}/fqdn.txt
fi

if [ ! -s ssl/${STS_NAME}/tls.crt ] ; then
    echo ""
    echo "Generating certificate for '${FQDN}'"
    ./gen-cert.sh -o ssl/${STS_NAME}/tls -a ssl/internal-ca ${FQDN}
fi

echo ""
echo "Creating/updating certificate secret"
echo ""
secret=${STS_NAME}-tls
descriptor=${secret}.yml
kubectl create secret generic ${secret} --from-file=ssl/${STS_NAME}/tls.key --from-file=ssl/${STS_NAME}/tls.crt --from-file=ssl/${STS_NAME}/tls.p12 --dry-run=client -o yaml > ${descriptor}
kubectl apply -f ${descriptor} -n ${NS_NAME}

echo "Generating files"
echo ""
TEMPLATE=axonserver-sts.yml.tmpl
DESCRIPTOR=${STS_NAME}.yml
echo "Generating ${DESCRIPTOR}"
sed -e s/__STS_NAME__/${STS_NAME}/g \
    -e s/__CLUSTER_NAME__/${CLUSTER_NAME}/g \
    -e s+__IMAGE__+${IMAGE}+g \
    -e s/__NS_NAME__/${NS_NAME}/g < ${TEMPLATE} > ${DESCRIPTOR}

echo ""
echo "Deploying/updating StatefulSet ${STS_NAME} in namespace ${NS_NAME}"
echo ""
kubectl apply -f ${DESCRIPTOR} -n ${NS_NAME}
