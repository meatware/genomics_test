# Genomics Test
**Step 1**
A company allows their users to upload pictures to an S3 bucket. These pictures are always in the .jpg format.
The company wants these files to be stripped from any exif metadata before being shown on their website.
Pictures are uploaded to an S3 bucket A.
Create a system that retrieves .jpg files when they are uploaded to the S3 bucket A, removes any exif metadata,
and save them to another S3 bucket B. The path of the files should be the same in buckets A and B.

[![Structure](https://i.ibb.co/j3yJSjc/image-structure.png)

**Step 2**
To extend this further, we have two users User A and User B. Create IAM users with the following access:
* User A can Read/Write to Bucket A
* User B can Read from Bucket B

## Solution Overview
The solution for this problem was solved using the following deployment tools:
1. Terraform - To create common shared resources such as IAM policies, S3 buckets, DynamoDB tables, etc
2. Serverless (sls) - To deploy lambda functions

Sls is a better choice to deploy lambda functions, API Gateways, step functions, etc because the serverless.yml is more tightly coupled to the dev code and thus changes can be more easily made in only a few lines of code compared to the several pages required by Terraform. Additionally, it allows developers to  easily modify the infrastructure without asking for DevOps help (as not everyone knows terraform). However, It can be a bad idea to allow anyone with access to a serverless.yml file to deploy whatver they like. Thus, shared infrastructure is deployed soley by Terraform and ideally this paradigm would be enforced by IAM permissioing.

The deployment workflow is as foolows:
1.

## Deployment notes
As s3 buckets must be unique, a random string is used so that multiple people can run the deployment in their own environments at any given time without error.



## Usage
**All instructions are for Ubuntu 20.04 using BASH in a terminal, so your milage may vary if using a different system.**
Several scripts have been included to assist getting this solution deployed. Please treat these scripts as additional documentation and give them a read.

## Install NVM, Node & Serverless
```
sudo apt install curl
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.profile
nvm install 14
npm install -g serverless
```

## Please ensure you have exported your aws credentials into your shell
An Optional method to get a great bash experience via https://github.com/meatware/sys_bashrc

```
cd
git clone https://github.com/meatware/sys_bashrc.git
mv .bashrc .your_old_bashrc
ln -fs ~/sys_bashrc/_bashrc ~/.bashrc
source ~/.bashrc
```

## use awskeys command to easily export aws key as env variables with sys_bashrc

```
csp1
awskeys help
awskeys list
awskeys export default
```

## Serverless deploy

```
cd serverless/exif-ripper
serverless plugin install -n serverless-python-requirements
serverless plugin install -n serverless-stack-output
serverless plugin install --name serverless-ssm-fetch
#
serverless deploy --stage dev --region eu-west-1
```


./00_test_upload_image_2_s3_source.sh default genomics-source-vkjhf87tg89t9fi
