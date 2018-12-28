#!/bin/bash

IMAGE_NAME="tea0water/kata-benchmark"

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
