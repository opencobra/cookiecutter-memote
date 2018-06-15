#!/usr/bin/env bash

# Do NOT set -v or your GitHub API token will be leaked!
set -ue # exit with nonzero exit code if anything fails

if [[ "${TRAVIS_PULL_REQUEST}" != "false" || "${TRAVIS_REPO_SLUG}" != "{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}" ]]; then
    echo "Skip deploy."
    exit 0
else
  echo "Start deploy to ${DEPLOY_BRANCH}..."
fi

# configure git
git config --global user.email "deploy@travis-ci.org"
git config --global user.name "Travis CI Deployment Bot"

# clone the deploy branch
cd "/tmp"
git clone --quiet --branch=${DEPLOY_BRANCH} https://${GITHUB_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git ${DEPLOY_BRANCH} > /dev/null
deploy_dir="/tmp/${DEPLOY_BRANCH}"

# copy the results from the current memote run to deploy dir
cp "${TRAVIS_BUILD_DIR}/Results/${TRAVIS_COMMIT}.json" "${deploy_dir}/Results/"

# create the report pointing to the history stored in deploy branch
# need to be in build directory to access git history
cd "${TRAVIS_BUILD_DIR}"
memote report history --filename="${deploy_dir}/index.html" "${deploy_dir}/Results/"

#add, commit and push files
cd "${deploy_dir}"
git add .
git commit -m "Travis build ${TRAVIS_BUILD_NUMBER}"
git push --quiet origin "${DEPLOY_BRANCH}" > /dev/null

echo "Done."
