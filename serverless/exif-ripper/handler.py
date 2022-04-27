"""
Lambda function that copies an image from a source bucket to a destination bucket after
remnoving all exif data for privacy.
"""

import json
import sys
import os
import logging

from functools import partial
from exif import Image as ExifImage
from boto3_helpers import boto_session, try_except_status, check_bucket_exists

from PIL import Image

LOG = logging.getLogger()
LOG.setLevel(logging.DEBUG)

def read_img_2memory(get_obj_resp):
    """
    Read image to memory as binary.
    """
    file_stream = response["Body"]
    img_binary = ExifImage(file_stream)
    return img_binary


def log_image_data(img, label):
    """
    LOG exif image data.
    """

    exif_data_list = img.list_all()
    LOG.info("exif_data_list - %s: %s", label, exif_data_list)
    return exif_data_list


def exifripper(event, context):
    """
    Main lambda entrypoint & logic.
    """


    LOG.info("event: <%s> - <%s>", type(event), event)



    # sys.exit(42)

    # ### Setup boto3
    # bo3_session = boto_session()
    # s3_client = bo3_session.client("s3")
    # #
    source_bucket = "genomics-source-vkjhf87tg89t9fi"
    dest_bucket = "genomics-destination-vkjhf87tg89t9fi"
    object_key =  event["Records"][0]["s3"]["object"]["key"]  #"incoming/sls_test_img1.jpg"
    LOG.info("object_key: <%s>", object_key)

    # ### Sanity check
    # for s3_buck in [source_bucket, dest_bucket]:
    #     check_bucket_exists(bucket_name=s3_buck)

    # response = s3_client.get_object(Bucket=source_bucket, Key=object_key)
    # LOG.info("response: %s", response)

    # my_image = read_img_2memory(get_obj_resp=response)
    # log_image_data(img=my_image, label="exif data pass0")

    # ### initial exif data delete
    # my_image.delete_all()

    # exif_data_list = log_image_data(img=my_image, label="exif data pass1")

    # ### Mop any exif data that failed to delete with delete_all
    # if len(exif_data_list) > 0:
    #     for exif_tag in exif_data_list:
    #         my_image.delete(exif_tag)
    #     log_image_data(img=my_image, label="exif data pass2")

    # ### Copy image with sanitised exif data to destination bucket
    # s3cp_status = try_except_status(
    #     partial(
    #         s3_client.put_object,
    #         ACL="bucket-owner-full-control",
    #         Body=my_image.get_file(),
    #         Bucket=dest_bucket,
    #         Key=object_key,
    #     ),
    #     fail_str="S3 object failked to copy",
    # )

    # ### Final exit
    # if s3cp_status == 200:
    #     LOG.info(
    #         "SUCCESS Copying s3 object <%s> from <%s> to <%s>",
    #         object_key,
    #         source_bucket,
    #         dest_bucket,
    #     )
    #     sys.exit(0)

    # LOG.info(
    #     "FAILED to copy s3 object <%s> from <%s> to <%s>",
    #     object_key,
    #     source_bucket,
    #     dest_bucket,
    # )
