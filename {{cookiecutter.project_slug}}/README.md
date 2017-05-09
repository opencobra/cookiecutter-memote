# {{ cookiecutter.project_name }}

Congratulations! You successfully set up your genome-scale metabolic model
repository.

**N.B.:** This README is currently out-dated.

## Next steps:

1. Update this README to your liking and to say something about the model that
   you are working on.
2. Take note of the [license](LICENSE) in case you want to change it.
3. If you want to test your model locally, i.e., on your own computer then you
   will have to learn or know a little bit about Python package management. Even
   though it is more of a hassle to set up, local testing will be much faster
   and give you more immediate feedback on your model-building efforts. We
   therefore highly recommend it. In addition, or alternatively, you can have
   automatic testing for the changes committed on GitHub. Please refer to the
   section on Travis CI for that. If you only rely on Travis you are done now.
   Enjoy working on your metabolic model! If you want a local setup keep on
   reading.
4. We recommend some kind of virtual environment for Python. We describe two
   common options in the section on virtualenv. Once you have one set up you can
   get up and running by simply typing:
   ```
   pip install -U -r requirements.in
   ```
5. You can then run the following command to get an impression of your model
   state:
   ```
   tox
   ```
   This will run all model tests and give you an overview. It will also generate
   a report from the tests. Individually, the commands are:
   ```
   tox -e suite
   ```
   to only run the tests and:
   ```
   tox -e report
   ```
   to run the tests and generate a report.

## virtualenv

Link some venv, virtualenv, conda tutorials here.

## Travis CI

Automatic model testing is enabled via memote and Travis CI. In order for this
to work as expected please:

1. Create an account on https://travis-ci.org using your GitHub account.
2. Enable your model repository for testing on Travis.
3. Commit some changes to your repository.
3. Enjoy continuous integration for your model!

## git and GitHub

You will need to learn some git basics in order to properly record changes and
interact with GitHub.
