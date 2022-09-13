#!/usr/bin/env bash

NS_NAME=running-ee

Usage () {
    echo "Usage: $0 [<options>]"
    echo ""
    echo "Options:"
    echo "  -n <name>  Namespace to deploy to, default '${NS_NAME}'."
    exit 1
}

options=$(getopt 'n:' "$@")
[ $? -eq 0 ] || {
    Usage
}
eval set -- "$options"
while true; do
    case $1 in
    -n)    NS_NAME=$2       ; shift ;;
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

CONTAINER=axoniq/axonserver-quicktest:4.5-SNAPSHOT
SERVERS=$(cat ssl/*/fqdn.txt | tr '\n' , | sed -e 's/,$//')
TOKEN=$(cat ./quicktester.token)

kubectl run axonserver-quicktest --image=${CONTAINER} \
--overrides='
{
  "apiVersion": "v1",
  "spec": {
    "containers": [
        {
        "name": "axonserver-quicktest",
        "image": "'${CONTAINER}'",
        "env": [
            {"name": "AXON_AXONSERVER_SERVERS", "value": "'${SERVERS}'"},
            {"name": "MS_DELAY", "value": "1000"},
            {"name": "SPRING_PROFILES_ACTIVE", "value": "axonserver"},
            {"name": "AXON_AXONSERVER_SSL-ENABLED", "value": "true"},
            {"name": "AXON_AXONSERVER_CERT-FILE", "value": "/ssl/internal-ca.crt"},
            {"name": "AXON_AXONSERVER_TOKEN", "value": "'${TOKEN}'"}
        ],
        "volumeMounts": [{
            "mountPath": "/ssl/internal-ca.crt",
            "subPath": "internal-ca.crt",
            "readOnly": true,
            "name": "internal-ca-cert"
        }]
        }
    ],
    "volumes": [{
        "name":"internal-ca-cert",
        "secret": {
        "secretName": "internal-ca",
        "items": [{
            "key": "internal-ca.crt",
            "path": "internal-ca.crt"
        }]
        }
    }]
  }
}'    -n ${NS_NAME} --attach stdout --rm