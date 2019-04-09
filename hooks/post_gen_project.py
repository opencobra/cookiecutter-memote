# -*- coding: utf-8 -*-

# Copyright 2018 Novo Nordisk Foundation Center for Biosustainability,
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

from __future__ import absolute_import

import logging
import os
import shutil
from io import open
from os.path import basename, isfile
from subprocess import check_call

import git


LOGGER = logging.getLogger("post-gen")


def main(model_path):
    # Possibly copy the given model.
    if model_path != "default":
        target = basename(model_path)
        LOGGER.info("copying '{}' -> '{}'".format(model_path, target))
        shutil.copy2(model_path, target)
        os.remove("model.xml")

    # Set up the repository with the master branch.
    LOGGER.info("Configuring git repository.")
    repo = git.Repo.init()
    with repo.config_writer() as writer:
        writer.set_value("user", "name", "{{ cookiecutter.full_name }}")
        writer.set_value("user", "email", "{{ cookiecutter.email }}")
        writer.release()
    shutil.move("pre-commit", ".git/hooks/")
    repo.git.add(".")
    check_call(
        ["git", "commit", "-m", "feat: add initial structure for the model repository"], 
        shell=True
    )

    # Set up the deployment branch.
    LOGGER.info("Configuring the deployment branch.")
    check_call(
    ["git", "checkout", "--orphan", "{{ cookiecutter.deployment }}"], 
    shell=True
    )
    # Remove unnecessary files.
    LOGGER.info("Removing unnecessary files.")
    repo.git.rm("-r", "--cached", ".")
    ignore = {".git", "memote.ini", ".travis.yml"}
    for entry in os.listdir("."):
        if entry in ignore:
            continue
        if isfile(entry):
            os.remove(entry)
        else:
            shutil.rmtree(entry)
    # Add expected files.
    LOGGER.info("Adding expected files such as memote.ini and .travis.yml.")
    os.mkdir("results")
    open("results/.keep", "w", encoding="utf-8").close()
    repo.index.add(["memote.ini", ".travis.yml", "results/.keep"])
    check_call(
    ["git", "commit", "-m", "feat: add initial deployment structure"], 
    shell=True
    )
    # Add remote according to cookiecutter value.
    repo.create_remote(
        "origin",
        "git@github.com:{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}.git"
    )

    repo.heads.master.checkout()
    LOGGER.info("Run memote on the primary commit.")
    check_call(["memote", "run", "--pytest-args", "--verbosity=0 --tb=no"])
    repo.heads["{{ cookiecutter.deployment }}"].checkout()
    LOGGER.info("Generate the first history report.")
    check_call(["memote", "report", "history"])
    repo.index.add(["index.html"])
    check_call(
        ["git", "commit", "-m", "feat: initial history report"], 
        shell=True
    )
    repo.heads.master.checkout()


if __name__ == "__main__":
    logging.basicConfig(
        level="INFO", format="[%(name)s][%(levelname)s] %(message)s")
    main("{{ cookiecutter.model_path }}")
