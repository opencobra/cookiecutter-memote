# -*- coding: utf-8 -*-

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

from __future__ import absolute_import

import logging
import io
import os
import shutil
import subprocess
from os.path import basename, join, isdir

import git

LOGGER = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO, format="%(message)s")

MODEL_PATH = "{{ cookiecutter.model }}"


# copy the model file
if MODEL_PATH != "model.xml":
    target = basename(MODEL_PATH)
    LOGGER.info("copying '%s' -> '%s'", MODEL_PATH,
                join("{{ cookiecutter.project_slug }}", target))
    shutil.copyfile(MODEL_PATH, target)
    os.remove("model.xml")


# set up git
# assume that current directory is the project directory
repo = git.Repo.init()
for (root, dirs, files) in os.walk(os.getcwd()):
    repo.index.add([join(root, name) for name in files])
    if ".git" in set(dirs):
        dirs.remove(".git")
repo.index.commit("initial structure for the model repository")

# set up the gh-pages branch
pages = repo.active_branch.checkout(orphan="gh-pages")
subprocess.check_call(["git", "rm", "--cached", "*"])
entries = os.listdir(os.getcwd())
entries.remove(".git")
for name in entries:
    if isdir(name):
        shutil.rmtree(name)
    else:
        os.remove(name)
os.mkdir("Results")
io.open("Results/.keep", "a").close()  # touch
with io.open("index.html", "w") as file_h:
    file_h.write(u"Soon this will be a sleek model report.\n")
repo.index.add(["Results", "index.html"])
repo.index.commit("basic gh-pages structure.")
pages.checkout("master")

# add remote
repo
