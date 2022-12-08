"""
Test the Terraform code in the examples/basic directory.

This test verifies that the example works by executing and testing it.
"""

import pytest


from tests.conftest import terraform_apply_and_output


@pytest.fixture(scope="module")
def output(terraform_config):
    yield from terraform_apply_and_output(__name__, terraform_config)


def test_resource_creation(output):
    pass
