# flake8: noqa
import pytest
import tftest
import os
import logging
import json


# Monkeypatch
def cleanup_github_rubbish(in_):
    out = in_
    if in_.find("{"):
        out = in_[in_.find("{") : in_.rfind("}")]
        if out.find("::debug"):
            out = out[: out.find("::debug")]
        if out.find("::set-output"):
            out = out[: out.find("::set-output")]
    return out


def pytest_addoption(parser):
    parser.addoption("--aws-profile", action="store", default=None)
    parser.addoption("--aws-region", action="store", default=None)
    parser.addoption("--terraform-binary", action="store", default="terraform")


@pytest.fixture(scope="session")
def aws_profile(request):
    """Return AWS_PROFILE."""
    aws_profile = request.config.getoption("--aws-profile")
    if aws_profile is None:
        aws_profile = os.environ.get("AWS_PROFILE", None)
    return aws_profile


@pytest.fixture(scope="session")
def aws_region(request):
    """Return AWS_REGION."""
    aws_region = request.config.getoption("--aws-region")
    if aws_region is None:
        aws_region = os.environ.get("AWS_REGION", None)
    return aws_region


@pytest.fixture(scope="session")
def terraform_binary(request):
    """Return path to Terraform binary."""
    return request.config.getoption("--terraform-binary")


@pytest.fixture(scope="session")
def terraform_default_variables():
    """Return default Terraform variables."""
    variables = {}
    return variables


def terraform_examples_dir():
    return os.path.join(os.getcwd(), "examples")


def terraform_tests_dir():
    return os.path.join(os.getcwd(), "tests", "terraform")


@pytest.fixture(scope="session")
def terraform_tests():
    """Return a list of tests, i.e subdirectories in `tests/terraform/`."""
    directory = terraform_tests_dir()
    if os.path.isdir(directory):
        return [f.name for f in os.scandir(directory) if f.is_dir()]
    return []


@pytest.fixture(scope="session")
def terraform_examples():
    """Return a list of examples, i.e subdirectories in `examples/`."""
    directory = terraform_examples_dir()
    if os.path.isdir(directory):
        return [f.name for f in os.scandir(directory) if f.is_dir()]
    return []


@pytest.fixture(scope="session")
def terraform_config(
    terraform_binary, terraform_tests, terraform_examples, terraform_default_variables
):
    """Convenience fixture for passing around config."""
    config = {
        "terraform_binary": terraform_binary,
        "terraform_tests": terraform_tests,
        "terraform_examples": terraform_examples,
        "terraform_default_variables": terraform_default_variables,
    }
    logging.info(config)
    return config


def get_tf_code_location(test_name):
    basedir = None
    tfdir = test_name
    # TODO something screwy with this logic.
    # TODO What if the terraform_x_dir dont exist?
    if "." in tfdir:  # Called with __name__, eg tests.test_examples_basic
        tfdir = test_name.split(".")[-1]
        if tfdir.startswith("test_"):
            tfdir = tfdir[len("test_") :]
    if tfdir.startswith("examples"):
        basedir = terraform_examples_dir()
        tfdir = tfdir[len("examples") + 1 :].replace("_", "-")
    elif tfdir in terraform_config["terraform_tests"]:
        basedir = terraform_tests_dir()
    else:
        raise Exception(f"Unable to locate Terraform code for test {test_name}")
    logging.info(f"{basedir=} {tfdir=}")
    return basedir, tfdir


def get_tf(test_name, terraform_config, variables=None):
    """Construct and return `tftest.TerraformTest`, for executing Terraform commands."""
    basedir, tfdir = get_tf_code_location(test_name)
    tf = tftest.TerraformTest(
        basedir=basedir, tfdir=tfdir, binary=terraform_config["terraform_binary"]
    )
    # Hack to avoid github rubbish
    tf._plan_formatter = lambda out: tftest.TerraformPlanOutput(
        json.loads(cleanup_github_rubbish(out))
    )
    tf._output_formatter = lambda out: tftest.TerraformValueDict(
        json.loads(cleanup_github_rubbish(out))
    )
    # Populate test.auto.tfvars.json with the specified variables
    variables = variables or {}
    variables = {**terraform_config["terraform_default_variables"], **variables}
    with open(os.path.join(basedir, tfdir, "test.auto.tfvars.json"), "w") as f:
        json.dump(variables, f)
    tf.setup()
    return tf


def terraform_plan(test_name, terraform_config, variables=None):
    """Run `terraform plan -out`, returning the plan output."""
    tf = get_tf(test_name, terraform_config, variables=variables)
    yield tf.plan(output=True)


def terraform_apply_and_output(test_name, terraform_config, variables=None):
    """Run `terraform_apply` and then `terraform output`, returning the output."""
    tf = get_tf(test_name, terraform_config, variables=variables)
    try:
        tf.apply()
        yield tf.output()
    # Shorten the default exception message.
    except tftest.TerraformTestError as e:
        tf.destroy(**{"auto_approve": True})
        raise tftest.TerraformTestError(e.cmd_error) from e
    finally:
        tf.destroy(**{"auto_approve": True})
