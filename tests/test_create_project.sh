#!/bin/bash

set -e

cleanup() {
    rm -rf memote_model_repository
}
trap cleanup EXIT


type cookiecutter

echo "Running test script..."
cookiecutter . --no-input
(
    cd ./memote_model_repository
#    tox  # need a model that passes all tests first
)

echo Done
