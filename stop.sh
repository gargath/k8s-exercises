#!/bin/bash

if [[ -z "$1" ]]; then
  printf "Error: exercise is required\n\n"
  printf "Usage: %s <exercise_directory>\n" "$0"
  printf "e.g. %s ex1\n" "$0"
  exit 1
fi

exercise=$1

kind delete cluster --name="$exercise"

for port in 80 443
do
    docker kill host-to-kind-proxy-${port} > /dev/null
    docker rm host-to-kind-proxy-${port} > /dev/null
done
