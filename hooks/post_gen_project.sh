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
set +e
github_email=$(git config user.email)
if [[ $? != 0 ]];then
    git config --global user.email "{{ cookiecutter.email }}"
fi
github_name=$(git config user.name)
if [[ $? != 0 ]];then
    git config --global user.name "{{ cookiecutter.full_name }}"
fi
set -e
git init
git add "." > /dev/null
git commit -m "feat: add initial structure for the model repository"

# setup up deploy branch
deploy_branch="gh-pages"

git checkout --orphan "${deploy_branch}" > /dev/null
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

# Push the deploy branch first since master push will trigger travis and require
# the deploy branch.
git remote add "origin" "git@github.com:{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}.git"
if [[ $? != 1 ]];then
    echo "Please create a repository on 'https://github.com' under your account '{{ cookiecutter.github_username }}' and project name '{{ cookiecutter.project_slug }}'."
    echo "Then:"
    echo "1. cd {{ cookiecutter.project_slug }}"
    echo "2. git checkout ${deploy_branch}"
    echo "3. git push -u origin ${deploy_branch}"
    echo "4. git checkout master"
    echo "5. Enable your repository on Travis CI."
    echo "6. Learn how to create a secure variable for Travis CI (https://docs.travis-ci.com/user/deployment/pages/#Setting-the-GitHub-token) and add it to your project settings or edit the \`.travis.yml\` file."

    echo "7. git push -u origin master"
fi