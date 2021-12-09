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

if [[ $# != 1 ]] ; then
    echo "Usage: $0 <filename>"
    exit 1
fi

TOKEN_FILE=$1

if [ ! -s ${TOKEN_FILE} ] ; then
    echo "Generating token for '${TOKEN_FILE}'"
    uuidgen | tr '[A-Z]' '[a-z]' > ${TOKEN_FILE}
else
    echo "Re-using existing token in '${TOKEN_FILE}'"
fi