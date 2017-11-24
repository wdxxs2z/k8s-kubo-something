#!/bin/bash

export TOKEN_ID=$1

export REFRESH_TOKEN=$2

export CA_PAHT=/home/ubuntu/.kube/ca.pem

kubectl config set-credentials $3 --auth-provider="oidc" --auth-provider-arg=idp-certificate-authority=${CA_PATH} --auth-provider-arg=idp-issuer-url=https://uaa.dcos.os/oauth/token  --auth-provider-arg=client-id=cf --auth-provider-arg=client-secret="" --auth-provider-arg=id-token=${TOKEN_ID} --auth-provider-arg=refresh-token=${REFRESH_TOKEN}

kubectl config set-context $3 --cluster=default --user=$3

kubectl config use-context $3
