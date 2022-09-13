#!/usr/bin/env bash

APP_NAME=
APP_TOKEN=
APP_ROLE=USE_CONTEXT@default

CONTAINER=axoniq/axonserver-cli:latest
SERVER=$(cat ssl/axonserver-1/fqdn.txt)
TOKEN=$(cat axonserver.token)

NS_NAME=running-ee

BINDIR=../../bin

APP_TOKEN_FILE=./quicktester.token
${BINDIR}/gen-token.sh ${APP_TOKEN_FILE}
APP_TOKEN=$(cat ${APP_TOKEN_FILE})

kubectl run axonserver-cli --image=${CONTAINER} -n ${NS_NAME} --attach --rm -- register-application -i -S https://${SERVER}:8024 -t ${TOKEN} -a quicktester -T ${APP_TOKEN} -r ${APP_ROLE}