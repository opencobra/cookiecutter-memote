#!/usr/bin/env bash

# Do NOT set -v or -x or your GitHub API token will be leaked!
#set -ue # exit with nonzero exit code if anything fails

echo "Parse memote.ini for values."
deployment=$(awk -F '=' '{if (! ($0 ~ /^;/) && $0 ~ /deployment/) print $2}' memote.ini | tr -d ' ')
location=$(awk -F '=' '{if (! ($0 ~ /^;/) && $0 ~ /location/) print $2}' memote.ini | tr -d ' ')

git config --global user.email "{{ cookiecutter.email }}"
git config --global user.name "{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}" 

if [[ "${GITHUB_EVENT_NAME}" == "pull_request" || "${GITHUB_REPOSITORY}" != "{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}" ]]; then
    echo "Untracked build."
    memote run --ignore-git
		echo "Skip deploy."
    exit 0
else
		# Always need the deployment branch available locally for storing results.
		echo "Checking  if deployment branch ${deployment} is available"
		git checkout "${deployment}"
		echo "Back to base ${HEAD_REF}"
		git checkout ${HEAD_REF}
		echo "Tracked build."
		mkdir -p results
		memote run
		echo "Start deploy to ${deployment}..."
fi

# Generate the history report on the deployment branch.
output="index.html"
git checkout "${deployment}"
echo "Generating updated history report '${output}'."
memote report history --filename="${output}"

# Add, commit and push the files.
git add "${output}"
git commit -m "Github actions report # ${GITHUB_SHA}"
git push --quiet "https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" "${deployment}" > /dev/null

echo "Your new report will be visible at https://{{ cookiecutter.github_username }}.github.io/{{ cookiecutter.project_slug }} in a moment."
