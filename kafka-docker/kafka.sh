#!/bin/bash

datadir=$(pwd)

display_help() {
    echo "Usage: $0 [option...]" >&2
	  echo "Usage: $0 [parm 1] [parm 2]" >&2
	  echo "Example $0 parm1 parm2"
    echo "Tool Description"
    echo
    echo "   -h, --help              Show help"
    echo "   -r, --refresh           This will refresh the discovery-kafka image"
    echo "                           (Only needed if discovery-kafka updates)"
    echo
    # echo some stuff here for the -a or --add-options
    exit 1
}

removeImage() {
    docker image rm -f discovery-kafka
}

function checkBase {
    if docker image ls | grep discovery-kafka ; then
        echo "Found discovery-kafka docker image."
    else
        echo "Building discovery-kafka image for first use. Please wait."
        cd docker
        docker build -t discovery-kafka:latest -f Dockerfile .
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
      --name discovery-kafka \
      --hostname=localhost \
      -p 2181:2181 \
      -p 9092:9092 \
      discovery-kafka > /dev/null 2>&1
      if [[ $? = 125 ]]; then
        echo "starting container discovery-kafka"
        docker start discovery-kafka
	    else
	      echo "creating container discovery-kafka this may a minute to initialize"
      fi
      ;;
esac

cd ${datadir}