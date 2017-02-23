# {{ cookiecutter.project_name }}

Maintenance of the "" metabolic model.

## Travis

Automatic model testing is enabled via memote and Travis CI. In order for this
to work as expected please:

1. Create an account on https://travis-ci.org using your GitHub account.
2. Modify the `commands` lines in the `tox.ini` file to include the model file,
   for example, `commands= memote model.xml` or leave it and create an environment
   variable on Travis `MEMOTE_MODEL=model.xml` that is relative to the project
   root.
