# -*- coding: utf-8 -*-

import os
import shutil
from os.path import basename, isabs

model_path = "{{ cookiecutter.model }}"
if model_path != "model.xml":
    if not isabs(model_path):
        raise ValueError("You need to provide an absolute path to the model.")
    shutil.copyfile(model_path, basename(model_path))
    os.remove("model.xml")
