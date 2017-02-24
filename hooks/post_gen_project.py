# -*- coding: utf-8 -*-

import logging
import os
import shutil
from os.path import basename, isabs

LOGGER = logging.getLogger(__name__)


model_path = "{{ cookiecutter.model }}"
if model_path != "model.xml":
    if not isabs(model_path):
        raise ValueError("You need to provide an absolute path to the model.")
    target = basename(model_path)
    LOGGER.info("copying model '%s' -> '%s'", model_path, target)
    shutil.copyfile(model_path, target)
    os.remove("model.xml")
