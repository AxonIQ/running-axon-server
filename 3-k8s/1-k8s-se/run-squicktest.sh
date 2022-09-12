#!/usr/bin/env bash

CONTAINER=axoniq/axonserver-quicktest:4.5-SNAPSHOT
AXONSERVER=$(cat ssl/fqdn.txt)
TOKEN=$(cat axonserver.token)

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
            {"name": "AXON_AXONSERVER_SERVERS", "value": "'${AXONSERVER}'"},
            {"name": "MS_DELAY", "value": "1000"},
            {"name": "SPRING_PROFILES_ACTIVE", "value": "axonserver"},
            {"name": "AXON_AXONSERVER_SSL-ENABLED", "value": "true"},
            {"name": "AXON_AXONSERVER_CERT-FILE", "value": "/ssl/tls.crt"},
            {"name": "AXON_AXONSERVER_TOKEN", "value": "'${TOKEN}'"}
        ],
        "volumeMounts": [{
            "mountPath": "/ssl/tls.crt",
            "subPath": "tls.crt",
            "readOnly": true,
            "name": "axonserver-cert"
        }]
        }
    ],
    "volumes": [{
        "name":"axonserver-cert",
        "secret": {
        "secretName": "axonserver-tls",
        "items": [{
            "key": "tls.crt",
            "path": "tls.crt"
        }]
        }
    }]
  }
}'    -n running-se --attach stdout --rm