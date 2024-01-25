#!/bin/bash

DOCKER_REGISTRY="underdogdevops"

# Build and push eshopwebmvc image
docker build -t $DOCKER_REGISTRY/eshopwebmvc:dev -f ../src/Web/Dockerfile .
docker push $DOCKER_REGISTRY/eshopwebmvc:dev

# Build and push eshoppublicapi image
docker build -t $DOCKER_REGISTRY/eshoppublicapi:dev -f ../src/PublicApi/Dockerfile .
docker push $DOCKER_REGISTRY/eshoppublicapi:dev

# Build and push sqlserver image
docker build -t $DOCKER_REGISTRY/sqlserver:dev -f ./path/to/sqlserver/Dockerfile .
docker push $DOCKER_REGISTRY/sqlserver:dev
