#!/usr/bin/env bash

# Copyright 2017 Novo Nordisk Foundation Center for Biosustainability,
# Technical University of Denmark.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ue

# copy the model file
model_path="{{ cookiecutter.model_path }}"
if [[ "${model_path}" != "default" ]]; then
    target=$(basename "${model_path}")
    echo "copying '${model_path}' -> '${target}'"
    cp "${model_path}" "${target}"
    rm "model.xml"
fi

# set up repository
git init
git config user.email "{{ cookiecutter.email }}"
git config user.name "{{ cookiecutter.full_name }}"
# deploy hoooks
mv "pre-commit" ".git/hooks/"

git add "." > "/dev/null"
git commit -m "feat: add initial structure for the model repository"

# setup up deploy branch
deploy_branch="gh-pages"

# TODO: orphan causing problems
git checkout --orphan "${deploy_branch}" > /dev/null
#git checkout -b "${deploy_branch}" > /dev/null
git rm -r --cached "." > /dev/null
old_ignore=${GLOBIGNORE}
GLOBIGNORE=".git"
rm -rf * .*
GLOBIGNORE=${old_ignore}
mkdir "Results"
touch "Results/.keep"
echo "Soon this will be a sleek model report." > "index.html"
git add --all "."
git commit -m "feat: add initial \`${deploy_branch}\` structure"
git checkout "master" > "/dev/null"

git remote add "origin" "git@github.com:{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}.git"
