#!/bin/bash
SERVERS=(51.83.75.29 51.83.75.29 51.83.75.29 51.83.75.29 51.83.75.29)

options=''


for peer in ${SERVERS[@]::5}
do
  options="${options}--peers ${peer} "
done

#options=$(printf $options)
options=$(echo -e "${options}")
echo "sawtooth-validator -vv \
          --endpoint tcp://${HOST_IP}:${HOST_PORT} \
          --bind component:tcp://eth0:4004 \
          --bind consensus:tcp://eth0:5050 \
          --bind network:tcp://eth0:${HOST_PORT} \
          --scheduler parallel \
          --peering dynamic \
          --maximum-peer-connectivity 10000 \
          ${options}
      "