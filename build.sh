#!/bin/bash

set -e

if [[ $# -eq 0 ]] ; then
    echo 'Please provide folder name as first argument'
    exit 0
fi

FUNCTION_NAME=$1
echo "*** FUNCTION_NAME=$FUNCTION_NAME"

LAMBDA_RUNTIME=python3.9

DEPLOYMENT_FILE=$FUNCTION_NAME-$LAMBDA_RUNTIME.zip

cd $FUNCTION_NAME

[[ -d .package ]] && rm -rf .package
[[ -d $DEPLOYMENT_FILE ]] && rm -f $DEPLOYMENT_FILE

# Build requirements in Lambda environment
docker run -v "$PWD":/var/task "public.ecr.aws/sam/build-$LAMBDA_RUNTIME" /bin/sh -c "pip install -r requirements.txt -t .package; exit"

# Create deployment package
echo "*** Adding requirements to $DEPLOYMENT_FILE"
cd .package
zip -r ../$DEPLOYMENT_FILE . > /dev/null


# Add app code
echo "*** Adding app to $DEPLOYMENT_FILE"
cd ..
# ./* => Includes all non-hidden files/directories eg excludes .package directory
# -x "__pycache" => Exclude __pycache__ directory
zip $DEPLOYMENT_FILE ./* -x "*__pycache__*"

# Move to correct location
mv $DEPLOYMENT_FILE ..
cd ..

echo "*** Display contents of $DEPLOYMENT_FILE"
unzip -l $DEPLOYMENT_FILE
