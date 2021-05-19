#!/bin/bash
# Name: start.sh
# Purpose: Run multiple sawtooth nodes on multiple machines
# ----------------------------------------------------

SERVERS=(146.59.230.10 146.59.229.32 146.59.228.136 141.95.18.233 135.125.207.187)
SIGNERSNODES=(51.83.75.29 51.83.75.29 51.83.75.29 51.83.75.29 51.83.75.29)
BOOSTRAP_CONFIG="/home/ubuntu/sawtooth-core/docker/jorge/setup/config/first/sawtooth-first-5.yaml"

#Do not change bellow
ID=1
SEED_PORT=8800 #Do not change
HOST_PORT=$SEED_PORT
API_PORT=8008
SIGNER_PORT=7000


###Start launching first node

 CMD="bash -c '
    export ID=${ID} &&
    export HOST_IP=${SERVERS[ID - 1]} &&
    export HOST_PORT=${HOST_PORT} &&
    export API_PORT=${API_PORT} &&
    export SIGNERNODE=${SIGNERSNODES[ID - 1]}:${SIGNER_PORT} &&
    docker-compose -p ${ID} -f ${BOOSTRAP_CONFIG} up --detach
    '
  "
  echo "- \"${SERVERS[ID - 1]}:${API_PORT}\"" > peers.txt
  echo $CMD
  echo $CMD | ssh -t ubuntu@${SERVERS[ID - 1]} bash

sleep 3

for s in ${SERVERS[@]:1}
do
  ID=$((ID + 1))
  HOST_PORT=$((HOST_PORT + 1))
  API_PORT=$((API_PORT + 1))
  SIGNER_PORT=$((SIGNER_PORT + 1))


  options=""
  index=0
  for server in ${SERVERS[@]::$((ID - 1))}
  do
    options="${options} --peers tcp://${server}:$((SEED_PORT + index))"
    index=$((index + 1))
  done

  #echo ${options}

  CMD="bash -c '
    export ID=${ID} &&
    export HOST_IP=${s} &&
    export HOST_PORT=${HOST_PORT} &&
    export API_PORT=${API_PORT} &&
    export SIGNERNODE=${SIGNERSNODES[ID - 1]}:${SIGNER_PORT}
    export SEED=\"${options}\" &&
    cd /home/ubuntu/sawtooth-core/docker/jorge/setup/config &&
    docker-compose -p ${ID} -f sawtooth-peer.yaml up --detach
    '
  "
  echo $CMD | ssh -t ubuntu@${s} bash
  echo "- \"${s}:${API_PORT}\"" >> peers.txt
done