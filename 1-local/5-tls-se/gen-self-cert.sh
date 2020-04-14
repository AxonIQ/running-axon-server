#!/bin/bash

CERT_DN=
CERT_DN_DEF=axonserver
CERT_COUNTRY=
CERT_STATE=
CERT_CITY=
CERT_ORG=
CERT_CN=
CERT_CN_DEF=$(hostname -f)

SHOW_USAGE=n
while [[ "${SHOW_USAGE}" == "n" && $# -gt 1 && $(expr "x$1" : x-) == 2 ]] ; do

    if [[ "$1" == "-c" || "$1" == "--country" ]] ; then
        CERT_COUNTRY=$2
        shift 2
    elif [[ "$1" == "--state" ]] ; then
        CERT_STATE=$2
        shift 2
    elif [[ "$1" == "--city"  ]] ; then
        CERT_CITY=$2
        shift 2
    elif [[ "$1" == "--org" ]] ; then
        CERT_ORG=$2
        shift 2
    elif [[ "$1" == "--dn" ]] ; then
        CERT_DN=$2
        shift 2
    else
        echo "Unknown option \"$1\"."
        SHOW_USAGE=y
    fi
done

if [[ $# == 1 ]] ; then
    CERT_CN=$1
fi

if [[ "${CERT_CN}" == "" ]] ; then
    CERT_CN=${CERT_CN_DEF}
fi
if [[ "${CERT_DN}" == "" ]] ; then
    CERT_DN=${CERT_DN_DEF}
fi

if [[ "${CERT_COUNTRY}" == "" ]] ; then
    echo "Country is required."
    SHOW_USAGE=y
fi
if [[ "${CERT_STATE}" == "" ]] ; then
    echo "State/province is required."
    SHOW_USAGE=y
fi
if [[ "${CERT_CITY}" == "" ]] ; then
    echo "City/locality is required."
    SHOW_USAGE=y
fi
if [[ "${CERT_ORG}" == "" ]] ; then
    echo "Organisation is required."
    SHOW_USAGE=y
fi

if [[ $# -gt 1 || ${SHOW_USAGE} == y ]] ; then
    echo "Usage: $0 [OPTIONS] <fqdn>"
    echo ""
    echo "Options:"
    echo "  -c <country>"
    echo "  --country <country>        Country, required."
    echo "  --state <state|province>   State or province, required."
    echo "  --city <city>              Locality/city, required."
    echo "  --org <organisation>       Organisation, required."
    echo "  --dn <distinguished-name>  Distinguished name, default \"${CERT_DN_DEF}\"."
    exit 1
fi

CSR_CONFIG=/tmp/csr.cfg

cat > ${CSR_CONFIG} <<EOF
[ req ]
distinguished_name="${CERT_DN}"
prompt="no"

[ ${CERT_DN} ]
C="${CERT_COUNTRY}"
ST="${CERT_STATE}"
L="${CERT_CITY}"
O="${CERT_ORG}"
CN="${CERT_CN}"
EOF

openssl req -config ${CSR_CONFIG} -newkey rsa:4096 -nodes -keyout tls.key -out tls.csr
openssl x509 -req -days 365 -in tls.csr -signkey tls.key -out tls.crt
openssl pkcs12 -export -out tls.p12 -inkey tls.key -in tls.crt  -name axonserver -passout pass:axonserver

rm -f ${CSR_CONFIG}
