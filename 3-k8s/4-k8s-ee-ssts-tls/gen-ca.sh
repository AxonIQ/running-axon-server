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

CERT_DN=
CERT_DN_DEF=axonserver
CERT_COUNTRY=
CERT_STATE=
CERT_CITY=
CERT_ORG=
CERT_CN=
CERT_CN_DEF=$(hostname -f)
CERT_OUPUT=ca

Usage () {
    echo "Usage: $0 [<options>] [<common-name>]"
    echo ""
    echo "Options:"
    echo "  --country <name>  Name of the certificate holder's country, default unspecified. Shorthand option '-c'."
    echo "  --state <name>    Name of the certificate holder's state, default unspecified."
    echo "  --city <name>     Name of the certificate holder's city, default unspecified."
    echo "  --org <name>      Name of the certificate holder's organization, default unspecified."
    echo "  --dn <name>       Name of the certificate holder's 'Distinguished Name', default unspecified."
    echo "  --output <name>   Base name of the generated files, default 'ca'."
    exit 1
}

options=$(getopt -l 'country:,state:,city:,org:,dn:,output:' -- 'c:o:' "$@")
[ $? -eq 0 ] || {
    Usage
}
eval set -- "$options"
while true; do
    case $1 in
    --country|-c)  CERT_COUNTRY=$2 ; shift ;;
    --state)       CERT_STATE=$2   ; shift ;;
    --city)        CERT_CITY=$2    ; shift ;;
    --org)         CERT_ORG=$2     ; shift ;;
    --dn)          CERT_DN=$2      ; shift ;;
    --output|-o)   CERT_OUTPUT=$2  ; shift ;;
    --)
        shift
        break
        ;;
    esac
    shift
done


if [[ $# == 0 ]] ; then
    CERT_CN=${CERT_CN_DEF}
elif [[ $# == 1 ]] ; then
    CERT_CN=$1
else
    Usage
fi

echo "Generating a certificate for '${CERT_CN_DEF}'"
if [[ "${CERT_DN}" == "" ]] ; then
    echo "Defaulting DN to '${CERT_DN_DEF}'"
    CERT_DN=${CERT_DN_DEF}
fi

CSR_CONFIG=/tmp/csr.cfg

cat > ${CSR_CONFIG} <<EOF
[ req ]
distinguished_name="${CERT_DN}"
prompt="no"

[ ${CERT_DN} ]
CN="${CERT_CN}"
EOF

if [[ "${CERT_COUNTRY}" != "" ]] ; then
    echo "C=\"${CERT_COUNTRY}\"" >> ${CSR_CONFIG}
fi
if [[ "${CERT_STATE}" != "" ]] ; then
    echo "ST=\"${CERT_STATE}\"" >> ${CSR_CONFIG}
fi
if [[ "${CERT_CITY}" != "" ]] ; then
    echo "L=\"${CERT_CITY}\"" >> ${CSR_CONFIG}
fi
if [[ "${CERT_ORG}" != "" ]] ; then
    echo "O=\"${CERT_ORG}\"" >> ${CSR_CONFIG}
fi

openssl req -config ${CSR_CONFIG} -newkey rsa:4096 -nodes -keyout ${CERT_OUTPUT}.key -out ${CERT_OUTPUT}.csr
openssl x509 -req -days 365 -in ${CERT_OUTPUT}.csr -signkey ${CERT_OUTPUT}.key -out ${CERT_OUTPUT}.crt

rm ${CSR_CONFIG}
