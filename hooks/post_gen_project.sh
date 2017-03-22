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

set -e

# copy the model file
model_path="{{ cookiecutter.model }}"
if [[ "${model_path}" != "model.xml" ]]; then
    target=$(basename "${model_path}")
    echo "copying '${model_path}' -> '${target}'"
    cp "${model_path}" "${target}"
    rm "model.xml"
fi

# set up repository
git init
git add "."
git commit -m "feat: add initial structure for the model repository"

# setup up deploy branch
deploy_branch="gh-pages"

git checkout --orphan "${deploy_branch}"
git rm --cached *
rm -rf *
rm -f ".gitignore" ".travis.yml"
git add --all "."
git commit -m "feat: add clean ${deploy_branch} deploy branch"

mkdir "Results"
touch "Results/.keep"
echo "Soon this will be a sleek model report." > "index.html"
git add "Results" "index.html"
git commit -m "feat: add initial `${deploy_branch}` structure"

# add and push to remote
# Push the deploy branch first since master push will trigger travis and require
# the deploy branch.
git remote add "git@github.com:{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}.git"
git push -u "origin" "${deploy_branch}"

git checkout "master"
git push -u "origin" "master"
