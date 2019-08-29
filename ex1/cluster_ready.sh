#!/usr/bin/env bash

(kubectl get job cordon-nodes -n kube-system | grep 1/1 > /dev/null)
success=$?
exit $success
