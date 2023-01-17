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
CERT_DIR=
CERT_DIR_DEF=.
FILENAME=
FILENAME_DEF=tls
CERT_CN=
CERT_CN_DEF=$(hostname)
[[ "$(hostname -d)" != "" ]] && CERT_CN_DEF=$(hostname -f)

function Usage() {
    echo "Usage: $0 [OPTIONS] [<fqdn>]"
    echo ""
    echo "Options:"
    echo "  -c <country>"
    echo "  --country <country>        Country, required."
    echo "  --state <state|province>   State or province, required."
    echo "  --city <city>              Locality/city, required."
    echo "  --org <organisation>       Organisation, required."
    echo "  --dn <distinguished-name>  Distinguished name, default \"${CERT_DN_DEF}\"."
    echo "  -d <path>                  Path for the generated files, default \"${CERT_DIR_DEF}\"."
    echo "  -o <name>                  Name to use for the generated files, default \"${FILENAME_DEF}\"."
    echo ""
    echo "Default FQDN is \"${CERT_CN_DEF}\"."
    exit 1
}

options=$(getopt -l 'country:,state:,city:,org:,dn:,ca:,help' -- 'c:d:h' "$@")
[ $? -eq 0 ] || Usage
eval set -- "$options"
while true; do
    case $1 in
    --country|-c)  CERT_COUNTRY=$2  ; shift ;;
    --state)       CERT_STATE=$2    ; shift ;;
    --city)        CERT_CITY=$2     ; shift ;;
    --org)         CERT_ORG=$2      ; shift ;;
    --dn)          CERT_DN=$2       ; shift ;;
    -d)            CERT_DIR=$2      ; shift ;;
    -o)            FILENAME=$2      ; shift ;;
    --help)        Usage                    ;;
    --)
        shift
        break
        ;;
    esac
    shift
done

if [[ $# -gt 1 ]] ; then
    Usage
fi

if [[ $# == 1 ]] ; then
    CERT_CN=$1
fi

if [[ "${CERT_CN}" == "" ]] ; then
    CERT_CN=${CERT_CN_DEF}
fi
if [[ "${CERT_DN}" == "" ]] ; then
    CERT_DN=${CERT_DN_DEF}
fi
if [[ "${CERT_DIR}" == "" ]] ; then
    CERT_DIR=${CERT_DIR_DEF}
fi
if [[ "${FILENAME}" == "" ]] ; then
    FILENAME=${FILENAME_DEF}
fi

echo "Generating a self-signed certificate in \"${CERT_DIR}\" for \"${CERT_CN}\"."
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

openssl req -config ${CSR_CONFIG} -newkey rsa:4096 -nodes -keyout ${CERT_DIR}/${FILENAME}.key -out ${CERT_DIR}/${FILENAME}.csr
openssl x509 -req -days 365 -in ${CERT_DIR}/${FILENAME}.csr -signkey ${CERT_DIR}/${FILENAME}.key -out ${CERT_DIR}/${FILENAME}.crt

rm -f ${CSR_CONFIG}
