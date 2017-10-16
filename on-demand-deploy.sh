#!/bin/bash

export DOCKER_HOST=192.168.0.201

# determine stack number by removing all non-numeric characters
stack_num=${STACK_NAME//[^0-9]/}
echo "stack_num: ${stack_num}"

# ports start at 8100
# incremented by 10 so we have up to 10 ports per environment
# so, on-demand-1 maps to 8110 and 8111, on-demand-2 maps to 8120 and 8121, etc

# compute port for generator 
export PORT_GENERATOR=`expr ${stack_num} "*" 10 + 8100`
echo "generator port: ${PORT_GENERATOR}"

# compute port for mailhog
export PORT_MAILHOG=`expr ${PORT_GENERATOR} + 1`
echo "mailhog port: ${PORT_MAILHOG}"

echo "compose config check:"
docker-compose -f demo.yml config

docker stack deploy -c demo.yml ${STACK_NAME}