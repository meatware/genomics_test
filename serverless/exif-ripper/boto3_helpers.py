"""Boto3 helpers to run AWS routines."""

import os
import sys
import logging
import boto3
from botocore.exceptions import ClientError

# from common import uniquify_list, chunks_sublist

LOG = logging.getLogger(__name__)


def boto_session():
    """Initialise boto3 session."""

    LOG.debug("Setting up Boto3 session")

    aws_region = os.environ.get("AWS_REGION")

    session = boto3.Session(
        region_name=aws_region
    )
    return session


def check_bucket_exists(bucket_name):
    """Sanity check whether s3 bucket exists."""

    s3_client = boto3.resource("s3")

    try:
        s3_client.meta.client.head_bucket(Bucket=bucket_name)
        LOG.info("Verified bucket %s exists", bucket_name)
    except ClientError:
        LOG.critical("s3 bucket %s does not exist or access denied", bucket_name)
        sys.exit(42)


def try_except_status(bo3_client_method, fail_str=None):
    """
    Takes a partially applied fuction passed to it
    so that it catches status codes/errors in a generalised way.
    Returns an http status code.
    """

    try:
        get_status = bo3_client_method
        status = get_status()["ResponseMetadata"]["HTTPStatusCode"]
    except ClientError as err:
        if fail_str:
            LOG.warning(fail_str, str(err))

        if err.response["Error"]["Code"]:
            status = err.response["Error"]["Code"]
        else:
            status = str(err)
    return status
