#!/bin/bash

datadir=$(pwd)
mkdir -p .datafiles

display_help() {
    echo "Usage: $0 [option...]" >&2
	  echo "Usage: $0 [parm 1] [parm 2]" >&2
	  echo "Example $0 parm1 parm2"
    echo "Tool Description"
    echo
    echo "   -h, --help              Show help"
    echo "   -r, --refresh           This will refresh the discovery-couchbase image"
    echo "                           (Only needed if discovery-couchbase updates)"
    echo
    # echo some stuff here for the -a or --add-options
    exit 1
}

removeImage() {
    docker image rm -f discovery-couchbase
}

function checkBase {
    if docker image ls | grep discovery-couchbase ; then
        echo "Found discovery-couchbase docker image."
    else
        echo "Building discovery-couchbase image for first use. Please wait."
        cd docker
        docker build -t discovery-couchbase:latest -f Dockerfile .
    fi
}


case "$1" in
  -h | --help)
      display_help
      exit 0
	  ;;
  -r | --refresh)
      removeImage
      checkBase
       ;;
  *)  # No more options
      checkBase
      docker run -d \
      --name discovery-couchbase \
      -p 8091-8094:8091-8094 \
      -p 11210:11210 \
      -v "${datadir}/.datafiles:/opt/couchbase/var" \
      -v "${datadir}/docker/initdb:/initdb" \
      discovery-couchbase > /dev/null 2>&1
      if [[ $? = 125 ]]; then
        echo "starting container discovery-couchbase"
        docker start discovery-couchbase
	    else
	      echo "creating container discovery-couchbase this may a minute to initialize"
      fi
      ;;
esac

cd ${datadir}