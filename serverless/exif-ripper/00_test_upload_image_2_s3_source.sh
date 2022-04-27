#!/bin/bash

# usage: ./00_test_upload_image_2_s3_source.sh default genomics-source-dev-vkjhf87tg89t9fi

set -e

AWS_PROFILE=$1
SOURCE_BUCKET=$2

cp test_images/OG_IMG_20220423_124829.jpg test_images/sls_test_img1.jpg

### rm any existing test image
aws --profile $AWS_PROFILE \
    --region eu-west-1 \
    s3 rm \
    s3://${SOURCE_BUCKET}/incoming/sls_test_img1.jpg

### Trigger lambda via s3 copy
aws --profile $AWS_PROFILE \
    --region eu-west-1 \
    s3 cp \
    test_images/sls_test_img1.jpg \
    s3://${SOURCE_BUCKET}/incoming/sls_test_img1.jpg

