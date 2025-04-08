#!/bin/bash

echo "Config $KUBECONFIG"

if [ "$action" = "create" ]
then
    kubectl create clusterrolebinding clusert-admin-binding --clusterrole=cluster-admin --user="gke-cluster"

    gcloud projects add-iam-policy-binding challenges-456002 --member serviceAccount:challengesa@challenges-456002.iam.gserviceaccount.com --role roles/owner
    gcloud iam service-accounts keys create --iam-account challengesa@challenges-456002.iam.gserviceaccount.com key.json
    kubectl create secret generic gcp-key --from-file key.json
    #kubectl create secret generic gcp-key --from-file key.json --namespace challenges-456002
    kubectl create secret generic gcp-key --from-file key.json --namespace cnrm-system
    kubectl apply -f ./resources/context.yaml
else 
    gcloud projects remove-iam-policy-binding challenges-456002 --member="serviceAccount:challengesa@challenges-456002.iam.gserviceaccount.com" --role="roles/owner"
fi
