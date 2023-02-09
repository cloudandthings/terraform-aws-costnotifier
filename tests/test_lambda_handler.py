import sys

from costnotifer import app


def test_lambda_handler():
    """
    This test ensures that the lambda handler function is callable.
    """
    test_event = None
    result = app.lambda_handler(test_event)

    expected_result = "Hello from AWS Lambda using Python" + sys.version + "! 200"

    assert result == expected_result
