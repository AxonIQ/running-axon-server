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
sed -e s/__SVC_NAME__/$1/g -e s/__NS_NAME__/$2/g < axonserver.properties.tmpl > axonserver.properties

kubectl create secret generic axonserver-license --from-file=../../axoniq.license -n $2
kubectl create secret generic axonserver-token --from-file=../../axonserver.token -n $2
kubectl create configmap axonserver-properties --from-file=axonserver.properties -n $2
