"""
Test the Terraform code in the examples/ directory.

This test verifies that the example works by executing and testing it.
"""


from tests.conftest import terraform_plan


def test_examples_email(terraform_config):
    terraform_plan("examples/email", terraform_config)


def test_examples_slack(terraform_config):
    terraform_plan("examples/slack", terraform_config)


def test_examples_teams(terraform_config):
    terraform_plan("examples/teams", terraform_config)
