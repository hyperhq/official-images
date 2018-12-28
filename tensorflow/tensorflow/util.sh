#!/bin/bash

IMAGE_NAME="tea0water/tensorflow"

function quit() {
  echo $@
  exit 1
}

function show_usage() {
cat <<EOF
Usage: ./util.sh <action>

action:
    build    # build image ${IMAGE_NAME}
    run      # run test container
EOF
}

function build_image() {
  if [ ! -d benchmarks ]; then
    echo "> benchmarks not exist, start clone now"
    git clone -v https://github.com/tensorflow/benchmarks.git
    if [ $? -ne 0 ]; then
      quit "error: failed to clone benchmarks"
    fi
  else
    echo "> benchmarks is ready"
  fi

  echo "> start build $IMAGE_NAME"
  docker build -t $IMAGE_NAME .
  if [ $? -eq 0 ]; then
    echo "> build ok"
  else
    quit "> build failed"
  fi
}

function  run_container() {
  docker run -it --rm $IMAGE_NAME bash
}

## main ##

case $1 in
  build)
  build_image
  ;;
  run)
  run_container
  ;;
  *)
  show_usage
  ;;
esac
