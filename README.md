# Kubernetes exercises, powered by Kind

## Prerequisites

You will need `kind` installed. See https://kind.sigs.k8s.io/docs/user/quick-start/ for details.

You will also need a recent version of `kubectl` in your `PATH`

## Starting an exercise

From the main directory, run `$ ./start.sh ex1` to start the first exercise. Replace `ex1` with any other exercise directory as required.

The Kind cluster will start and be configured for the requested exercise.

Don't forget to `export KUBECONFIG` for the cluster.

Currently both exercises consist of fixing a deployment that should be accessible via HTTP on http://localhost/ but won't be once the cluster starts.


## Still to be done

There are currently no instructions for the exercises. These are still to be written.
