#! /bin/bash

scriptdir="$(dirname "$(realpath "$0")")"

kubectl --kubeconfig="${scriptdir}/kubeconfig" "$@"
