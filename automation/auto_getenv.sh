#!/bin/bash
#Variable
LRED='\033[1;31m'
LGREEN='\033[1;32m'
NC='\033[0m'
LBLUE='\033[0;34m'
LYELLOW='\033[1;33m'
# check version
if [ -z "$VERSION" ]
      then
      VERSION=`jq -r '.version' ./package.json`
      
fi

#get reponame
git_url=$(basename $(git config --get remote.origin.url))
REPONAME=${git_url/\.git/''}
GIT_SHORT=$(git rev-parse --short HEAD) 
GIT_USER=$(git log -1 --pretty=format:'%an')
GIT_USER_EMAIL=$(git log -1 --pretty=format:'%ae')
#get BRANCH_NAME from  GIT
if [ -z $GIT_BRANCH ]; then
  BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
else 
  BRANCH_NAME=$GIT_BRANCH
fi

# check repository
if [ -z "$REPOSITORY" ]
then
      REPOSITORY="$REPONAME"
fi
# check REGISTRY
if [ -z "$REGISTRY" ]
then
      REGISTRY="roxsross12"
fi
# check NAME CONTAINER
if [ -z "$NAME" ]
then
      NAME="$REPONAME-$BRANCH_NAME"
fi

# echo result

echo -e "\n${LGREEN}»» AUTOMATION JENKINS | BRANCH: $BRANCH_NAME ✅ ${NC}"
echo -e "+---------------------------------+-----------------------------+"
echo -e "|      VAR                            VALUE                      "
echo -e "+---------------------------------+-----------------------------+"

print_table_row() {
  printf "| %-30s | %-39s \n" "$1" "$2"
}

print_table_row "GIT_SHORT" "$GIT_SHORT"
print_table_row "BRANCH_NAME" "$BRANCH_NAME"
print_table_row "REGISTRY" "$REGISTRY"
print_table_row "VERSION" "$VERSION"
print_table_row "REPOSITORY" "$REPOSITORY"
print_table_row "DOCKER_IMAGENAME" "$REGISTRY/$REPOSITORY:$VERSION"
print_table_row "GIT_USER" "$GIT_USER"
print_table_row "GIT_USER_EMAIL" "$GIT_USER_EMAIL"

echo -e "+----------------------+-----------------------------------------+"
echo -e "${LBLUE}by RoxsRoss🔥${NC}"
set +x