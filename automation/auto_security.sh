#!/bin/bash
# get variables form gitlab-ci or locals
source ./automation/auto_getenv.sh
source ./automation/auto_config.sh

hadolint () {
    if [ -f Dockerfile ] ; then 
        docker run --rm -i hadolint/hadolint < Dockerfile > hadolint-results.txt || true
        cat hadolint-results.txt
    else 
        echo "No se encontró el Dockerfile" 
        exit 1 
    fi
}

semgrep () {
    docker run -v ${WORKSPACE}:/src --workdir /src returntocorp/semgrep semgrep ci --json --exclude=package-lock.json --output /src/report_semgrep.json --config auto --config p/ci || true
}

horusec () {
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/src public.ecr.aws/roxsross/horusec:v2.9.0 horusec start -p /src -P "$(pwd)/src" -e="true" -o="json" -O=src/report_horusec.json || true
}

trivy () {
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v ${WORKSPACE}:/src aquasec/trivy:0.48.1 image --format json --output /src/report_trivy.json ${REGISTRY}/${REPOSITORY}:${VERSION} || true

}

dast () {
    docker run --rm -v ${WORKSPACE}:/zap/wrk/:rw --user root -t ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t http://back.295devops.com -m 1 -d -I -J report_dast.json -r report_dast.html || true
}

case "$1" in

  'hadolint')
    hadolint ;;

  'horusec')
    horusec
    ;;

  'semgrep')
    semgrep
    ;;
  'trivy')
    trivy
    ;;
  'dast')
    dast
    ;;
    *)
      echo "error: unknown option $1"
      exit 1
      ;;
  esac