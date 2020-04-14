#!/bin/bash

if [[ $# != 2 ]] ; then
    echo "Usage: $0 <service-name> <namespace>"
    exit 1
fi
sed -e s/__SVC_NAME__/$1/g -e s/__NS_NAME__/$2/g < axonserver.properties.tmpl > axonserver.properties

kubectl create secret generic axonserver-license --from-file=../axoniq.license -n $2
kubectl create secret generic axonserver-token --from-file=../axonserver.token -n $2
kubectl create configmap axonserver-properties --from-file=axonserver.properties -n $2
