#!/bin/bash
# Name: start.sh
# Purpose: Run multiple sawtooth nodes on multiple machines
# ----------------------------------------------------

SERVERS=(51.83.75.29 51.83.75.29 51.83.75.29 51.83.75.29)
SIGNERSNODES=(51.83.75.29 51.83.75.29 51.83.75.29 51.83.75.29)

#Do not change bellow
ID=1
HOST_PORT=8800
API_PORT=8008
SIGNER_PORT=7000


# export ID=2
# export HOST_IP=188.83.81.75
# export HOST_PORT=8800
# export API_PORT=8008
# export SEED=tcp://51.83.75.29:8800
# export SIGNERNODE=signernode-1

#ID=$((ID + 1))
#HOST_PORT=$((HOST_PORT + 1))
#API_PORT=$((API_PORT + 1))

for index in ${!SERVERS[@]}
do
  ID=$((ID + 1))
  HOST_PORT=$((HOST_PORT + 1))
  API_PORT=$((API_PORT + 1))
  SIGNER_PORT=$((SIGNER_PORT + 1))
  CMD="bash -c '
    export ID=${ID} &&
    export HOST_IP=${SERVERS[index]} &&
    export HOST_PORT=${HOST_PORT} &&
    export API_PORT=${API_PORT} &&
    export SIGNERNODE=${SIGNERSNODES[index]}:${SIGNER_PORT}
    export SEED=tcp://51.83.75.29:8800 &&
    cd /home/jfp/sawtooth-core/docker/jorge/setup/config &&
    docker-compose -p ${ID} -f sawtooth-peer.yaml up --detach
    '
  "
  echo $CMD | ssh -t jfp@${s} bash
  echo "- ${SERVERS[index]}" ":${API_PORT}"
done