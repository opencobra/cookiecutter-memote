import os
import shutil
from os.path import basename

model_path = "{{ cookiecutter.model }}"
if model_path != "default":
#    if not os.path.isabs(model_path):
#        raise ValueError('You need to provide an absolute path to the model.')
#    else:
        shutil.copyfile(model_path, basename(model_path))
        os.remove("model.xml")
