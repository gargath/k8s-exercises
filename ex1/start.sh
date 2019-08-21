#!/bin/bash

kind create cluster --config kind-cluster.yaml --name ex1
export KUBECONFIG="$(kind get kubeconfig-path --name="ex1")"
kubectl apply -f deployments/

for port in 80 443
do
    node_port=$(kubectl get service -n ingress-nginx ingress-nginx -o=jsonpath="{.spec.ports[?(@.port == ${port})].nodePort}")

    docker run -d --name banzai-kind-proxy-${port} \
      --publish 127.0.0.1:${port}:${port} \
      --link ex1-control-plane:target \
      alpine/socat -dd \
      tcp-listen:${port},fork,reuseaddr tcp-connect:target:${node_port}
done
