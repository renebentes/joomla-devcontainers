#!/bin/bash
IMAGE="$1"

if [ "${IMAGE}" = "" ]; then
    echo "Image name is missing"
    exit 1
fi

if [ ! -d "image/${IMAGE}" ]; then
    echo "Image '${IMAGE}' is missing a source folder"
    exit 1
fi

set -e

echo "(*) Preparing source"
SRC_DIR="/tmp/${IMAGE}"
cp -r "image/${IMAGE}" "${SRC_DIR}"

TEST_DIR="test/${IMAGE}"
if [ -d "${TEST_DIR}" ]; then
    echo "(*) Copying test folder"
    DEST_DIR="${SRC_DIR}/test-project"
    mkdir -p "${DEST_DIR}"
    cp -rp "${TEST_DIR}"/* "${DEST_DIR}"
    cp test/test-utils/test-utils.sh "${DEST_DIR}"
fi

export DOCKER_BUILDKIT=1
echo "(*) Installing @devcontainer/cli"
npm install -g @devcontainers/cli

echo "(*) Building image - ${IMAGE}"
ID_LABEL="test-container=${IMAGE}"
devcontainer up --id-label "${ID_LABEL}" --workspace-folder "${SRC_DIR}"
