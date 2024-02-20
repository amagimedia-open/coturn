#!/bin/bash
set -xe

if [[ $# -ne 2 ]]
then
    echo "USAGE: $0 <workspace_folder> <tag>"
    exit 1
fi

WORKSPACE_FOLDER=$1
TAG=$2
AWS_TAG=${AWS_ECR_ACCOUNT_URI}/cp/playout/coturn:${TAG}

aws ecr-public get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ECR_ACCOUNT_URI}


pushd ${WORKSPACE_FOLDER}

# Build the coturn docker image
docker build --no-cache \
    -t ${AWS_TAG} \
    -f docker/coturn/debian/Dockerfile .

# Push docker image to AWS ECR endpoint
docker push ${AWS_TAG}

popd
