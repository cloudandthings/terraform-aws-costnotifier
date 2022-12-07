"""
Test the Terraform code in the examples/basic directory.

This test verifies the root module works with the minimum Terraform binary version
and minimum provider version specified in the root modules version constraints.
"""

import pytest


from tests.conftest import terraform_plan


@pytest.fixture(scope="module")
def plan(terraform_config):
    yield from terraform_plan("examples/basic", terraform_config)


@pytest.mark.terraform_min_supported_version
def test_min_supported_version(plan):
    pass
