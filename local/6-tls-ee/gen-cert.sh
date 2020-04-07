#!/bin/bash

if [[ $# == 0 ]] ; then
    DOMAIN=$(hostname -f)
elif [[ $# == 1 ]] ; then
    DOMAIN=$1
else
    echo "Usage: $0 [<fqdn>]"
    exit 1
fi

echo "Generating certificate for \"${DOMAIN}\"."
CSR_CONFIG=/tmp/csr.cfg

cat > ${CSR_CONFIG} <<EOF
[ req ]
distinguished_name="req_distinguished_name"
prompt="no"

[ req_distinguished_name ]
C="NL"
ST="Utrecht"
L="Utrecht"
O="AxonIQ"
CN="${DOMAIN}"
EOF

KEY_NAME=$1

openssl req -config ${CSR_CONFIG} -new -newkey rsa:2048 -nodes -keyout ${DOMAIN}.key -out ${DOMAIN}.csr
openssl x509 -req -days 1024 -in ${DOMAIN}.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out ${DOMAIN}.crt
rm -f ${CSR_CONFIG}