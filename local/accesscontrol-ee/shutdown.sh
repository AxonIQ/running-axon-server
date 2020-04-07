#!/bin/bash

if [[ $# != 1 ]] ; then
    echo "Usage: $0 <node-name>"
    exit 1
elif [ ! -d $1 ] ; then
    echo "No directory for node \"$1\" found."
    exit 1
fi

AXONSERVER_NAME=$1
AXONSERVER_PIDFILE=${AXONSERVER_NAME}/AxonIQ.pid
if [ ! -s ${AXONSERVER_PIDFILE} ] ; then
    echo "There is no Axon Server \"${AXONSERVER_NAME}\" active."
    exit 1
fi

AXONSERVER_PID=`cat ${AXONSERVER_PIDFILE} | sed s/@.*$//`

echo "Asking Axon Server \"${AXONSERVER_NAME}\" to quit. (process ID ${AXONSERVER_PID})"
kill ${AXONSERVER_PID}

countDown=5
while ps -p ${AXONSERVER_PID} >/dev/null ; do
    sleep 5

    countDown=`expr ${countDown} - 1`
    if [[ "${countDown}" == "" || "${countDown}" == "0" ]]  ; then
        break
    fi
done

if ps -p ${AXONSERVER_PID} >/dev/null ; then
    echo "Killing Axon Server \"${AXONSERVER_NAME}\" forcefully (process ID ${AXONSERVER_PID})"
    kill -9 ${AXONSERVER_PID}
    rm -f ${AXONSERVER_PIDFILE}
fi

exit 0