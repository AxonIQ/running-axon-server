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
elif [ ! -d $1 ] ; then
    echo "No directory for node \"$1\" found."
    exit 1
fi

cd $1
AXONIQ_LICENSE=../../../axoniq.license java -jar ../../../axonserver-ee.jar
