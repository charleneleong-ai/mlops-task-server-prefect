#!/usr/bin/env bash

set -a
set -euox pipefail

## Python Virtualenv
echo 'Updating Python dependencies' 


echo 'Creating virtualenv' 
pip install poetry==1.1.7s
poetry env use python3.8    ## Brew default
poetry install --remove-untracked   ## Installing from poetry.lock - remove old dependencies no longer present in the lock file

echo 'Configuring pre-commit' 
pre-commit install

# ## Setting up DVC
# if [[ ! -d "$PWD/.dvc" ]]; then
#     echo 'Init DVC' 
#     dvc init
#     dvc remote add -d s3remote s3://ilab-sagemaker-experiments-165837684817/mlops-nlp-sagemaker-modeldeploy-automatic-ticket-classification/
#     dvc pull
# fi
