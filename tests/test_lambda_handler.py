from costnotifier import app


def test_lambda_handler():
    """
    This test ensures that the lambda handler function is callable.
    """
    test_event = None
    app.lambda_handler(test_event, None)
