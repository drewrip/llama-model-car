#!/bin/bash

# Script to enable Modelcars
# Fetch the current storageInitializer configuration
config=$(oc get configmap inferenceservice-config -n redhat-ods-applications -o jsonpath='{.data.storageInitializer}')
# Enable modelcars and set the UID for the containers to run (required for minikube)
newValue=$(echo $config | jq -c '. + {"enableModelcar": true}')

# Create a temporary directory for the patch file
tmpdir=$(mktemp -d)
cat <<EOT > $tmpdir/patch.txt
[{
  "op": "replace",
  "path": "/data/storageInitializer",
  "value": '$newValue'
}]
EOT

# Apply the patch to the ConfigMap
oc patch configmap -n redhat-ods-applications inferenceservice-config --type=json --patch-file=$tmpdir/patch.txt

# Restart the KServe controller to apply changes
oc delete pod -n redhat-ods-applications -l control-plane=kserve-controller-manager
