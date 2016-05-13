import os
import shutil

# from cookiecutter import config
# print(config.DEFAULT_CONFIG)
# if os.path.isabs('{{ cookiecutter.model }}'):
#     model_path = '{{ cookiecutter.model }}'
# else:
#     print(1, '{{ cookiecutter.vanilla }}')
#     model_path = '{{ cookiecutter.repo_dir }}{{ cookiecutter.model }}'
model_path = '{{ cookiecutter.model }}'
if model_path != 'default':
    if not os.path.isabs(model_path):
        raise ValueError('You need to provide an absolute path to the model.')
    else:
        shutil.copyfile(model_path, './model.xml')
