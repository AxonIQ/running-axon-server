#!/bin/bash

AXONSERVER_PIDFILE=./AxonIQ.pid
if [ ! -s ${AXONSERVER_PIDFILE} ] ; then
    echo "There is no Axon Server node active."
    exit 1
fi

AXONSERVER_PID=`cat ${AXONSERVER_PIDFILE} | sed s/@.*$//`

echo "Asking Axon Server to quit. (process ID ${AXONSERVER_PID})"
kill ${AXONSERVER_PID} || rm ${AXONSERVER_PIDFILE}

countDown=5
while ps -p ${AXONSERVER_PID} >/dev/null ; do
    sleep 5

    countDown=`expr ${countDown} - 1`
    if [[ "${countDown}" == "" || "${countDown}" == "0" ]]  ; then
        break
    fi
done

if ps -p ${AXONSERVER_PID} >/dev/null ; then
    echo "Killing Axon Server forcefully (process ID ${AXONSERVER_PID})"
    kill -9 ${AXONSERVER_PID}
    rm -f ${AXONSERVER_PIDFILE}
fi

exit 0