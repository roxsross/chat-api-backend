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

print_message $LBLUE "Patching docker-compose.yml"

sed -i -- "s/REGISTRY/$REGISTRY/g" docker-compose.yml
sed -i -- "s/REPLACE/$REPOSITORY/g" docker-compose.yml
sed -i -- "s/TAG/$VERSION/g" docker-compose.yml
sed -i -- "s/URL/$DOMAIN/g" docker-compose.yml

print_message $LBLUE "REVIEW docker-compose.yml"

cat docker-compose.yml

print_message $LGREEN "Configuración aplicada correctamente."

