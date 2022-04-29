#!/bin/bash

######################################################
# Error Check Script
set -e
function trap_debugger () {
    # Function to output script error & slack alert via alt script
    local parent_lineno="$1"
    local message="$2"
    local code="${3:-1}"

    if [[ -n "$message" ]] ; then
        echo "Error on or near line ${parent_lineno}: ${message}; command yielded exit code ${code}"
    else
        echo "Error on or near line ${parent_lineno}; command yielded exit code ${code}"
    fi

    exit "${code}"
}

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG

trap 'trap_debugger ${LINENO}' ERR
######################################################


if [ "$#" -ne 2 ]; then
    echo "USAGE: ./xxx_pipeline_destroy.sh \${YOUR_TERRAFORM_EXEC} \${YOUR_UNIQUE_RANDOM_STRING}"
    echo "e.g > ./xxx_pipeline_destroy.sh terraform_v1.0.6 z0b3ly"
    exit 0
fi

terraform_exec=$1
random_string=$2


echo "destroying dev & prod backends  now..."
### Run terraform
for myenv in "dev" "prod"; do

    ## 1
    cd terraform_v2/entrypoints/exifripper_buckets

        rm -rf .terraform .terraform.lock.hcl \
            && $terraform_exec init -input=false -backend-config=../../envs/${myenv}/${myenv}.backend.hcl \
            && $terraform_exec validate \
            && $terraform_exec destroy -var-file=../../envs/${myenv}/${myenv}.tfvars -var random_string=$random_string -auto-approve -input=false

    cd -

    ## 2
    cd terraform_v2/entrypoints/sls_deployment_bucket

        rm -rf .terraform .terraform.lock.hcl \
            && $terraform_exec init -input=false -backend-config=../../envs/${myenv}/${myenv}.backend.hcl \
            && $terraform_exec validate \
            && $terraform_exec destroy -var-file=../../envs/${myenv}/${myenv}.tfvars -var random_string=$random_string -auto-approve -input=false

    cd -

done


## 3. destroy remote backend
for myenv in "dev" "prod"; do
    cd terraform_v2/00_setup_remote_s3_backend_${myenv}

        rm -rf .terraform .terraform.lock.hcl \
            && $terraform_exec init -input=false  \
            && $terraform_exec validate \
            && $terraform_exec apply -target module.terraform_state_backend -var random_string=$random_string -var terraform_backend_config_file_path="" -auto-approve -input=false

        $terraform_exec init -input=false -force-copy
        $terraform_exec destroy -var random_string=$random_string -var terraform_backend_config_file_path="" -auto-approve -input=false
    cd -
done