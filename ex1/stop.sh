#!/bin/bash

kind delete cluster --name=ex1
unset KUBECONFIG

for port in 80 443
do
    docker kill banzai-kind-proxy-${port}
    docker rm banzai-kind-proxy-${port}
done
