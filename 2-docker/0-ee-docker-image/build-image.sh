#!/bin/bash

TAG=
TAG_DEF=axonserver:running
JAR_EE=../../axonserver.jar
JAR_CLI=../../axonserver-cli.jar

if [[ $# == 1 ]] ; then
    TAG=$1
    shift
else
    TAG=${TAG_DEF}
fi
if [ ! -s ${JAR_EE} ] ; then
    echo "No EE JARfile found at \"${JAR_EE}\"."
    exit 1
fi
if [ ! -s ${JAR_CLI} ] ; then
    echo "No CLI JARfile found at \"${JAR_CLI}\"."
    exit 1
fi

echo "Building Axon Server image as \"${TAG}\"."

cp ${JAR_EE} build/axonserver.jar
cp ${JAR_CLI} build/axonserver-cli.jar

cd build
docker build --tag ${TAG} .
