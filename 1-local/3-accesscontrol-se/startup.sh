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

APP_TOKEN=$(uuidgen)
ADMIN_TOKEN=$(uuidgen)

(
    sed -e '/^axoniq.axonserver.accesscontrol.token=/d' \
        -e '/^axoniq.axonserver.accesscontrol.admin-token=/d' \
        -e '/^axoniq.axonserver.accesscontrol.adminToken=/d' < axonserver.properties ; \
    echo "axoniq.axonserver.accesscontrol.token=${APP_TOKEN}" ; \
    echo "axoniq.axonserver.accesscontrol.admin-token=${ADMIN_TOKEN}"
) > axonserver-new.properties
mv axonserver-new.properties axonserver.properties

echo "Starting Axon Server SE"
echo "- Client application token = ${APP_TOKEN}"
echo "- Admin token ............ = ${ADMIN_TOKEN}"

nohup java -jar ../../axonserver-se.jar >/dev/null 2>&1 &
