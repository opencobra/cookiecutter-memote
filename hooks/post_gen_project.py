import os
import shutil
from os.path import basename

model_path = "{{ cookiecutter.model }}"
if model_path != "default":
    shutil.copyfile(model_path, basename(model_path))
    os.remove("model.xml")
