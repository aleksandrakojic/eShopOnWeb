#!/bin/bash

# Deploy dev environment
kubectl create namespace dev
helm upgrade --install eshop-dev ./path/to/eshopwebmvc-chart --namespace=dev --set image.repository=$DOCKER_REGISTRY/eshopwebmvc,tag=dev

# Deploy prod environment
kubectl create namespace prod
helm upgrade --install eshop-prod ./path/to/eshopwebmvc-chart --namespace=prod --set image.repository=$DOCKER_REGISTRY/eshopwebmvc,tag=prod
