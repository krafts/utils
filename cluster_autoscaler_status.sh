exec kubectl -n kube-system get configmap cluster-autoscaler-status -o yaml | grep -e Scale -e Name
