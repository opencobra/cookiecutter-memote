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
    nosetests .
)

echo Done
