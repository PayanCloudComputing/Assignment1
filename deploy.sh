#!/bin/bash

BUCKET=$1
PROFILE=$2

if [ -z "$PROFILE" ]
then
    PROFILE=default
fi

l_bucket=$(echo "$BUCKET" | awk '{print tolower($0)}') #Changing bucket name to lower case
echo "Downloading project..."
git clone https://github.com/jpayan/CloudComputing.git
cd CloudComputing
npm install
echo "Deploying project..."
grunt build --force
echo "Checking bucket..."
if aws s3 ls "s3://$S3_BUCKET" --profile $PROFILE 2>&1 | grep -q 'NoSuchBucket'
then
    echo "No such bucket. A new bucket will be created..."
    aws s3api create-bucket --bucket $l_bucket --profile $PROFILE
else
    echo "Bucket already exists."
    echo "Deleting bucket's content..."
    aws s3 rm s3://$l_bucket --recursive --profile $PROFILE
fi
echo "Uploading files to bucket..."
cd dist
aws s3 sync . s3://$l_bucket --acl public-read --profile $PROFILE
aws s3 website s3://$l_bucket/ --index-document index.html --error-document 404.html --profile $PROFILE
cd ../..
rm -rf CloudComputing
