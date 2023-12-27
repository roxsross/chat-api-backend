#!/bin/bash
# set -x
source ./automation/auto_config.sh
source ./automation/auto_getenv.sh

print_message() {
  echo -e "${1}${2}${NC}"
}

if [ ! -f "docker-compose.yml" ]; then
  print_message $LRED "ERROR: El archivo docker-compose.yml no existe."
  exit 1
fi

print_message $LBLUE "DEPLOY TO EC2 BRANCH: $BRANCH_NAME"
scp -o StrictHostKeyChecking=no docker-compose.yml ${EC2INSTANCE}:/home/ec2-user 
ssh ${EC2INSTANCE} "docker-compose up -d"

print_message $LBLUE "REVIEW EC2 BRANCH: $BRANCH_NAME"
ssh ${EC2INSTANCE} "docker images | grep $REGISTRY/$REPOSITORY"
ssh ${EC2INSTANCE} "docker ps | grep $REGISTRY/$REPOSITORY"


