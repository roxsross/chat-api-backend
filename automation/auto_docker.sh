#!/bin/bash
# get variables form gitlab-ci or locals
source ./automation/auto_getenv.sh


build () {
    if [ -f Dockerfile ] ; then 
       docker build $1 $2 \
        --build-arg VCS_REF=`git rev-parse --short HEAD` \
        --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
        --build-arg GIT_USER="$GIT_USER" \
        --build-arg GIT_USER_EMAIL="$GIT_USER_EMAIL"  \
        -t $REGISTRY/$REPOSITORY:$VERSION . || exit 1
    else 
        echo "No se encontró el Dockerfile" 
        exit 1 
    fi
}

push () {
docker login --username=$DOCKER_HUB_LOGIN_USR --password=$DOCKER_HUB_LOGIN_PSW
docker push $REGISTRY/$REPOSITORY:$VERSION || exit 1
set +x	
}

case "$1" in

  'build')
    build ;;

  'push')
    push
    ;;
    *)
      echo "error: unknown option $1"
      exit 1
      ;;
  esac

