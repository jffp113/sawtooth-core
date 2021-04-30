#!/bin/bash
# Name: start.sh
# Purpose: Run multiple sawtooth nodes on multiple machines
# ----------------------------------------------------

SERVERS=(51.83.75.29 51.83.75.29 51.83.75.29 51.83.75.29 51.83.75.29)
SIGNERSNODES=(51.83.75.29 51.83.75.29 51.83.75.29 51.83.75.29 51.83.75.29)

#Do not change bellow
ID=1
SEED_PORT=8800 #Do not change
HOST_PORT=$SEED_PORT
API_PORT=8008
SIGNER_PORT=7000
#keysPath="./../keys/all"



###Start launching first node

 CMD="bash -c '
    export ID=${ID} &&
    export HOST_IP=${SERVERS[ID - 1]} &&
    export HOST_PORT=${HOST_PORT} &&
    export API_PORT=${API_PORT} &&
    export SIGNERNODE=${SIGNERSNODES[ID - 1]}:${SIGNER_PORT} &&
    cd /home/jfp/sawtooth-core/docker/jorge/setup/config &&
    docker-compose -p ${ID} -f sawtooth-first.yaml up --detach
    '
  "
  echo "- ${SERVERS[ID - 1]}:${API_PORT}"
  echo $CMD
  echo $CMD | ssh -t jfp@${SERVERS[ID - 1]} bash

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
    cd /home/jfp/sawtooth-core/docker/jorge/setup/config &&
    docker-compose -p ${ID} -f sawtooth-peer.yaml up --detach
    '
  "
  echo $CMD | ssh -t jfp@${s} bash
  echo "- ${s}:${API_PORT}"
done