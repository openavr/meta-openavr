#!/bin/bash

for i in $(seq 1 6)
do
    sernum=$(printf "%04d" "${i}")
    HOSTNAME="openavr-${sernum}"

    echo ""
    echo "########## ${HOSTNAME} ###########"
    (
        set -x
        #ping -c 1 -O ${HOSTNAME}
        ssh ${HOSTNAME} hostnamectl
    )
done
