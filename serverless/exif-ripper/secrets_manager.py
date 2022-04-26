# """Manage AWS secrets."""

# import os
# import sys
# import logging
# from dotenv import load_dotenv

# LOG = logging.getLogger(__name__)

# secret_vars = [
#     "AWS_ACCESS_KEY_ID",
#     "AWS_SECRET_ACCESS_KEY",
#     "AWS_REGION",
#     "AWS_DEFAULT_OUTPUT",
# ]


# def check_env_variables(dotenv_path):
#     """Check whether environment variables have been correctly loaded."""

#     if not os.path.isfile(dotenv_path):
#         LOG.critical("No secret file found at dotenv_path: %s", dotenv_path)
#         sys.exit(42)
#     # load env variables
#     load_dotenv(dotenv_path, override=True)

#     # check to see if env variables are available to app
#     for secret in secret_vars:
#         if secret not in os.environ:
#             LOG.critical("Environment secret not set: %s", secret)
#             return False

#     return True
