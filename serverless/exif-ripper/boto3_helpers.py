"""Boto3 helpers to run AWS routines."""

import os
import sys
import logging
import boto3
from botocore.exceptions import ClientError

LOG = logging.getLogger(__name__)


def boto_session():
    """Initialise boto3 session."""

    LOG.debug("Setting up Boto3 session")

    aws_region = os.environ.get("AWS_REGION")

    session = boto3.Session(region_name=aws_region)
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


def try_except_resp_and_status(bo3_client_method, fail_str=None):
    """
    Takes a partially applied fuction passed to it
    so that it catches status codes/errors in a generalised way.
    Returns an http status code as well as the raw response in a tuple.
    Note that `bo3_client_method` is a partial. e.g:

        response, s3get_status = try_except_resp_and_status(
            partial(
                s3_client.get_object,
                Bucket=bucket_source,
                Key=object_key,
            ),
            fail_str=f"Failed to copy get s3 object {object_key}",
        )
        LOG.info("response: %s", response)

        if s3get_status != 200:
            LOG.info(
                "FAILED to copy s3 object <%s> from <%s> to RAM",
                object_key,
                bucket_source
            )
            sys.exit(42)

        if s3get_status != 200:
            LOG.info(
                "FAILED to copy s3 object <%s> from <%s> to RAM",
                object_key,
                bucket_source
            )
            sys.exit(42)
    """

    try:
        raw_resp = bo3_client_method
        status = raw_resp()["ResponseMetadata"]["HTTPStatusCode"]
    except ClientError as err:
        if fail_str:
            LOG.warning("%s - %s ", fail_str, str(err))
        else:
            LOG.error(str(err))

        status_code = "NoStatus"
        if err.response["Error"]["Code"]:
            status_code = err.response["Error"]["Code"]

        status = status_code
    return (raw_resp(), status)
