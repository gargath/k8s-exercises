#!/usr/bin/env /bin/bash
# shellcheck shell=bash

if [[ -z "$1" ]]; then
  printf "Error: exercise is required\n\n"
  printf "Usage: %s <exercise_directory>\n" "$0"
  printf "e.g. %s ex1\n" "$0"
  exit 1
fi

exercise=$1

base=$(dirname "$0")
workdir="$base/$exercise"

function spinner {
  c=$((${1} % 8))
  case ${c} in
     0) printf " 🌑 " ;;
     1) printf " 🌒 " ;;
     2) printf " 🌓 " ;;
     3) printf " 🌔 " ;;
     4) printf " 🌕 " ;;
     5) printf " 🌖 " ;;
     6) printf " 🌗 " ;;
     7) printf " 🌘 " ;;
  esac
}

function erase {
  len=$((${#1} + 4))
  for ((j=0; j<=len; j++)); do printf "\b"; done
}

kind create cluster --config "$workdir"/kind-cluster.yaml --name $exercise
KUBECONFIG="$(kind get kubeconfig-path --name="$exercise")"
export KUBECONFIG

printf "\nConfiguring cluster ...\n"

message="Waiting for control plane 🎮"
while true; do
  spinner $i
  printf "%s" "$message"
  sleep 0.3
  i=$((i + 1))

  if [ $((i % 8)) -eq 0 ]; then
    (kubectl get node $exercise-control-plane | grep Ready > /dev/null)
    success=$?
    if [ ${success} -eq 0 ]; then
      break
    fi
  fi
  erase "$message"
done
erase "$message"
printf " ✓ %s\n" "$message"

message="Applying bootstrap components 👢"
for f in "$workdir"/deployments/bootstrap/*.yaml; do
  spinner $i
  printf "%s" "$message"
  kubectl apply -f "$f" > /dev/null
  i=$((i + 1))
  erase "$message"
done
printf " ✓ %s\n" "$message"

message="Waiting for bootstrap 🕑"
while true; do
  spinner $i
  printf "%s" "$message"
  sleep 0.3
  i=$((i + 1))

  if [ $((i % 8)) -eq 0 ]; then
    ("$workdir"/cluster_ready.sh)
    success=$?
    if [ ${success} -eq 0 ]; then
      break
    fi
  fi
  erase "$message"
done
erase "$message"
printf " ✓ %s\n" "$message"

message="Applying exercise components 📘"
for f in "$workdir"/deployments/payloads/*.yaml; do
  spinner $i
  printf "%s" "$message"
  kubectl apply -f "$f" > /dev/null
  i=$((i + 1))
  erase "$message"
done
printf " ✓ %s\n" "$message"

message="Creating ingress shims 🔨"
printf "   %s" "$message"
for port in 80 443
do
    node_port=$(kubectl get service -n ingress-nginx ingress-nginx -o=jsonpath="{.spec.ports[?(@.port == ${port})].nodePort}")
    docker run -d --name host-to-kind-proxy-${port} \
      --publish 127.0.0.1:${port}:${port} \
      --link "$exercise"-control-plane:target \
      alpine/socat -dd \
      tcp-listen:${port},fork,reuseaddr tcp-connect:target:"${node_port}" > /dev/null
done

erase "$message"
printf " ✓ %s\n" "$message"

printf "Cluster setup complete.\n"
printf "\nInstructions for this Exercise:\n\n"
cat "$exercise"/INSTRUCTIONS.md
printf "\nDon't forget to export KUBECONFIG=\"\$(kind get kubeconfig-path --name=\"%s\")\"\n" "$exercise"
