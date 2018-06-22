#!/usr/bin/env bash

set -eu

project="${1:-memote-model-repository}"

cleanup() {
    rm -rf "${project}"
}
trap cleanup EXIT


type cookiecutter

cookiecutter . --no-input

(
    echo "Running test script..."
    cd "./${project}"
    echo "Test for 'memote.ini'."
    test -f "memote.ini"
    echo "Test for 'model.xml'."
    test -f "model.xml"
)

echo Done
