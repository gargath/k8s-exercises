#!/bin/bash

kind delete cluster --name=ex1

for port in 80 443
do
    docker kill host-to-kind-proxy-${port}
    docker rm host-to-kind-proxy-${port}
done
