#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
test_{{ cookiecutter.project_slug }}
----------------------------------

Tests for `{{ cookiecutter.project_slug }}` module.
"""

import os
import unittest

TESTDIR = os.path.dirname(__file__)
MODEL_PATH = os.path.join(TESTDIR, '../model.xml')

class Test{{ cookiecutter.project_slug|capitalize }}(unittest.TestCase):

    def setUp(self):
        with open(MODEL_PATH, 'r') as f:
            self.model = f.read()

    def test_000_something(self):
        self.assertTrue("R_Biomass_Ecoli_core_w_GAM" in self.model)


if __name__ == '__main__':
    import sys
    sys.exit(unittest.main())
