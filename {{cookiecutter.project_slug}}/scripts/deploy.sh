#!/usr/bin/env bash

# do NOT set -v or your GitHub API token will be leaked!
set -e # exit with nonzero exit code if anything fails

echo "Starting deploy to ${DEPLOY_BRANCH}..."

# configure git
git config --global user.email "deploy@travis-ci.org"
git config --global user.name "Deployment Bot"

# clone the deploy branch
cd "${HOME}"
git clone --quiet --branch=${DEPLOY_BRANCH} https://${GITHUB_API_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git ${DEPLOY_BRANCH} > /dev/null

# copy the results from the current memote run to deploy dir
cp "${TRAVIS_BUILD_DIR}/Results/${TRAVIS_COMMIT}.json" "${HOME}/${DEPLOY_BRANCH}/Results/"

# create the report pointing to the history stored in deploy branch
# need to be in build directory to access git history
cd "${TRAVIS_BUILD_DIR}"
memote --directory="${HOME}/${DEPLOY_BRANCH}/Results/" --filename="${HOME}/${DEPLOY_BRANCH}/index.html" report

#add, commit and push files
cd "${HOME}/${DEPLOY_BRANCH}"
git add .
git commit -m "Travis build ${TRAVIS_BUILD_NUMBER}"
git push --quiet origin "${DEPLOY_BRANCH}" > /dev/null

echo "Done."
