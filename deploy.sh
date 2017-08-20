#!/bin/bash

BUCKET=$1
l_bucket=$(echo "$BUCKET" | awk '{print tolower($0)}') #Changing bucket name to lower case
echo "Downloading project..."
git clone https://github.com/jpayan/CloudComputing.git
cd CloudComputing
npm install
echo "Deploying project..."
grunt build --force
echo "Creating bucket..."
if aws s3 ls "s3://$S3_BUCKET" 2>&1 | grep -q 'NoSuchBucket'
then
    echo "A new bucket will be created..."
else
    echo "Bucket already exists."
    echo "Deleting bucket..."
    aws s3 rb s3://$BUCKET --force
    echo "Creating new bucket..."
fi
aws s3api create-bucket --bucket $l_bucket
echo "Updating files to bucket..."
cd dist
aws s3 sync . s3://$l_bucket --acl public-read
aws s3 website s3://$l_bucket/ --index-document index.html --error-document error.html