# Genomics Test
**Step 1**
A company allows their users to upload pictures to an S3 bucket. These pictures are always in the .jpg format.
The company wants these files to be stripped from any exif metadata before being shown on their website.
Pictures are uploaded to an S3 bucket A.
Create a system that retrieves .jpg files when they are uploaded to the S3 bucket A, removes any exif metadata,
and save them to another S3 bucket B. The path of the files should be the same in buckets A and B.

[![Brief](docs/image_structure.png)

**Step 2**
To extend this further, we have two users User A and User B. Create IAM users with the following access:
* User A can Read/Write to Bucket A
* User B can Read from Bucket B

## Solution Overview

[![Exif-ripper architecture](docs/exif_ripper.drawio.png)
One natural solution for this problem is to use AWS lambda because this service provides the ability to monitor an s3 bucket and trigger event based messages that can be sent to any arbitrary downstream processor. Indeed, a whole pipeline of lambda functions can used in the chain of responsibilty pattern if desired.

[![Chain of responsibility](docs/Chained-Microservices-Design-Pattern.png)

Given the limited time to accomplish this task, an added benefit of using serverless is that setting up monitoring the bucket for pushed images is trivial because the framework creates the monitoring lambda for us in a few lines of code. When the following code is added to the serverless.yml file, the monitoring lambda pushes an [event](https://www.serverless.com/framework/docs/providers/aws/events/s3) to our custom exif-ripper lambda when a file with the suffix of `.jpg` and a s3 key prefix of `incoming/` is created in the bucket called `mysource-bucket`.

```
functions:
  exif:
    handler: exif.handler
    events:
      - s3:
          bucket: mysource-bucket
          event: s3:ObjectCreated:*
          rules:
            - prefix: uploads/
            - suffix: .jpg
```

The exif-ripper lambda Python3 code is located in `serverless/exif-ripper/` and it leverages the following libraries to execute the folloowing workflow:
1. [boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#s3): Read binary image file froom s3 into RAM.
2. [exif](https://pypi.org/project/exif/): Strips any exif data from image
3. [partial](https://docs.python.org/3/library/functools.html#functools.partial) from [functools](https://docs.python.org/3/library/functools.html#module-functools) : Use of a partial function try-except wrapper to get more accurate error messages from AWS API. Thus, the dev does not have spend as much time worrying about logging potential errors.
4. Boto3 again to write the sanitised file to the destination bucket.

#####  Try-except wrapper:
```
def try_except_resp_and_status(bo3_client_method, fail_str=None):
    """
    Takes a partially applied fuction passed to it
    so that it catches status codes/errors in a generalised way.
    Returns an http status code as well as the raw response in a tuple.
    Note that `bo3_client_method` is a partial.
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

######################## Usage ########################
response, s3get_status = try_except_resp_and_status(
    partial(
        s3_client.get_object,
        Bucket=bucket_source,
        Key=object_key,
    ),
    fail_str=f"Failed to copy get s3 object {object_key}",
)
LOG.info("response: %s", response)

#
if s3get_status != 200:
    LOG.info(
        "FAILED to copy s3 object <%s> from <%s> to RAM",
        object_key,
        bucket_source
    )
    sys.exit(42)
```

```
2022-04-29 20:49:26.269	[WARNING]	S3 object failed to copy - An error occurred (NoSuchBucket) when calling the PutObject operation: The specified bucket does not exist
2022-04-29 20:49:26.270	[INFO]	FAILED to copy s3 object <incoming/sls_test_img1.jpg> from <genomics-source-dev-fern> to <genomics-destination-dev-fern>
END Duration: 819.68 ms Memory Used: 65 MB

```


##### API errors handled by botocore
###### (from serverless/exif-ripper/venv/lib64/python3.8/site-packages/botocore/data/s3/2006-03-01/service-2.json)
```
</snip>
"GetObject":{
  "name":"GetObject",
  "http":{
    "method":"GET",
    "requestUri":"/{Bucket}/{Key+}"
  },
  "input":{"shape":"GetObjectRequest"},
  "output":{"shape":"GetObjectOutput"},
  "errors":[
    {"shape":"NoSuchKey"},             # <--!!!
    {"shape":"InvalidObjectState"}     # <--!!!
  </snip>
```

### usage



The solution for this problem was solved using the following deployment tools:
1. Terraform - To create common shared resources such as IAM policies, S3 buckets, DynamoDB tables, etc
2. Serverless (sls) - To deploy lambda functions

Sls is a better choice to deploy lambda functions, API Gateways, step functions, etc because the Serverless.yml is more tightly coupled to the dev code and thus changes can be more easily made in only a few lines of code compared to the several pages required by Terraform. Additionally, it allows developers to  easily modify the infrastructure without asking for DevOps help (as not everyone knows Terraform). However, It can be a bad idea to allow anyone with access to a Serverless.yml file to deploy whatever they like. Thus, shared infrastructure is deployed solely by Terraform and ideally this paradigm would be enforced by IAM permissions.

Two methods of deploying the Terraform code are included here. V2 is a dryer method that also uses a remote s3/dynamodb backend

#### Serverless Function Overview
Exif-Ripper is a serverless application that attaches an event triggering rule to "watch" a source s3 bucket for the upload of any jpg file. When this happens an AWS event invokes a lambda function written in python which strips the exif data from the jpg and writes the "sanitised" jpg to a destination bucket. The lambda function reads & processes the image directly in memory so does not inefficiently write the file to a scratch volume.

#### Directory structure
```
.
├── Serverless
│   └── exif-ripper
│       ├── config
│       └── test_images
├── Terraform_v1
│   ├── 01_sls_deployment_bucket
│   ├── 02_DEV
│   ├── 03_PROD
│   └── modules
│       ├── exif_ripper_buckets
│       ├── iam_exif_users
│       └── lambda_iam_role_and_policies
└── Terraform_v2
    ├── 00_setup_remote_s3_backend_dev
    ├── 00_setup_remote_s3_backend_prod
    ├── entrypoints
    │   ├── exifripper_buckets
    │   └── sls_deployment_bucket
    ├── envs
    │   ├── dev
    │   └── prod
    └── modules
        ├── exif_ripper_buckets
        └── lambda_iam_role_and_policies

```

#### Terraform_v1 does the following:
1. Creates Serverless deployment bucket. Multiple Serverless projects can be nested in this bucket. This is to avoid the mess of multiple random Serverless buckets being scattered around the root of s3.
2. Creates source & destination s3 buckets for exif image processing
3. Pushes the names of these buckets to SSM
4. Creates a lambda role and policy
5. Creates two users with RO and RW permissions to the buckets as specified in the brief
6. Uses `Terraform output` to write the role arn & the deployment bucket name to the Serverless folder

```
.
├── 01_sls_deployment_bucket
├── 02_DEV
├── 03_PROD
└── modules
    ├── exif_ripper_buckets
    ├── iam_exif_users
    └── lambda_iam_role_and_policies

```

#### Terraform_v2 does the following:
This version is included to illustrate a method that is more DRY than v1.
1. Creates an s3/dynamodb backend and writes the backend config files to envs folder
2. Creates Serverless deployment bucket. Multiple Serverless projects can be nested in this bucket. This is to avoid the mess of multiple random Serverless buckets being scattered around the root of s3.
3. Creates source & destination s3 buckets for exif image processing
4. Pushes the names of these buckets to SSM
5. Creates a lambda role and policy

```
.
├── 00_setup_remote_s3_backend_dev
├── 00_setup_remote_s3_backend_prod
├── entrypoints
│   ├── exifripper_buckets
│   └── sls_deployment_bucket
├── envs
│   ├── dev
│   └── prod
└── modules
    ├── exif_ripper_buckets
    └── lambda_iam_role_and_policies
```


#### The Serverless.yml does the following:
1. Uses the Serverless deployment bucket created by Terraform
2. Fetches ssm variables that have previously been pushed by the Terraform code: (source and destination buckets)
3. Creates the trigger on the source bucket
4. Creates the lambda function (using buckets created by Terraform)

```
.
├── Serverless
│   └── exif-ripper
│       ├── config
│       └── test_images
```

## Deployment notes
As s3 buckets must be unique, a random string is used so that multiple people can run the deployment in their own environments at any given time without error.



## Usage
**All instructions are for Ubuntu 20.04 using BASH in a terminal, so your milage may vary if using a different system.**
Several scripts have been included to assist getting this solution deployed. Please treat these scripts as additional documentation and give them a read.

#### Install NVM, Node & Serverless

```
cd ~/Downloads
sudo apt install curl
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.profile
nvm install 14
npm install -g Serverless
cd -
```

#### Please ensure you have exported your aws credentials into your shell
This has been test-deployed into an R&D account using Admin credentials. Try to do the same or use an account with the perms to use lambda, s3, iam, dynamodb, and SSM (syatems manager) at the least.

An Optional method to get a great bash experience via https://github.com/meatware/sys_bashrc

```
cd
git clone https://github.com/meatware/sys_bashrc.git
mv .bashrc .your_old_bashrc
ln -fs ~/sys_bashrc/_bashrc ~/.bashrc
source ~/.bashrc
```

#### use awskeys command to easily export aws key as env variables with sys_bashrc

```
csp1
awskeys help
awskeys list
awskeys export $YOUR_AWS_PROFILE
```

#### Running Deploy Scripts

```
### Install packages
sudo apt install eog jq unzip wget

### Install latest aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

### Install terraform_1.0.6
wget https://releases.hashicorp.com/terraform/1.0.6/terraform_1.0.6_linux_amd64.zip
unzip terraform_1.0.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/terraform_v1.0.6
rm -f terraform_1.0.6_linux_amd64.zip
```

#### Terraform_v1 with Serverless appliaction and users (just dev)
```
### Create stack From repo root
./xxx_pipeline_create.sh terraform_v1.0.6 $YOUR_TERRAFORM_EXEC $RANDOM_STRING

### Test Serverless function
cd serverless/exif-ripper
./00_test_upload_image_2_s3_source.sh default
cd -

### Test user permissions
cd terraform_v1/02_DEV/
./000_extract_user_secrets_from_tfstate.sh
cat ./append_these_perms_to_aws_credentials_file.secrets # <<! take contents of this and pasted into ~/.aws/credentials file

### run user perm tests & check output
./001_test_user_bucket_access.sh
cd -

### DESTROY STACK ONCE FINISHED
./xxx_pipeline_destroy.sh $YOUR_TERRAFORM_EXEC
```
#### Terraform_v2 (NO Serverless or Users) - dev & prod
```
### Create stack From repo root
./xxx_tfver2_pipeline_create.sh $YOUR_TERRAFORM_EXEC $RANDOM_STRING

### Look around and check code!!

### DESTROY STACK ONCE FINISHED
./xxx_tfver2_pipeline_destroy.sh $YOUR_TERRAFORM_EXEC $RANDOM_STRING
```