#!/bin/bash

apply: 
	AWS_PROFILE=default AWS_DEFAULT_REGION=us-west-2 terraform apply -auto-approve

plan: 
	AWS_PROFILE=default AWS_DEFAULT_REGION=us-west-2 terraform plan

argo-password:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

expose-argo:
	 kubectl port-forward service/argo-cd-argocd-server -n argocd 8080:443