#!/bin/bash

set -e

echo "!!! Plaese endurte you have terraform-docs on your path!!!"
echo -e "https://github.com/terraform-docs/terraform-docs\n"

if [ "$#" -ne 1 ]; then
    echo "USAGE: ./xxx_terraform-docs.sh \${YOUR_TERRAFORM_EXEC}"
    echo "e.g > ./xxx_terraform-docs.sh terraform_v1.0.6"
    exit 0
fi

terraform_exec=$1

### Run tf fmt
$terraform_exec fmt -recursive

unique_tf_dirs=$(find ./ -not -path "*/\.*" -not -path "*venv/*" -not -path "*node_modules/*" -iname "*.tf" -exec dirname {} \; | uniq)

for tf_dirs in $unique_tf_dirs; do
    cd $tf_dirs
        # TODO: customise this further to enrich READMEs and create links to them from root directory
        terraform-docs markdown table --output-file README.md --output-mode inject .
    cd -
done