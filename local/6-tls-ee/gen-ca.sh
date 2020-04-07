#!/bin/bash

if [ $# != 1 ] ; then
  echo "Usage: $0 <ca-domain>"
  exit 1
fi

DOMAIN=$1
CA_CONFIG=/tmp/ca.cfg

cat > ${CA_CONFIG} <<EOF
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

openssl req -nodes -newkey rsa:4096 -config ${CA_CONFIG} -keyout rootCA.key -out rootCA.csr
openssl x509 -req -days 1024 -in rootCA.csr -signkey rootCA.key -out rootCA.crt
