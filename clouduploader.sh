#!/bin/bash


# CloudUploader CLI - Uploads files into Cloud Storage services{AWS s3}
acct_authentication () {
    read -p "Skip AWS Account Configuration (Y/N) : " acct_config
    if [[ "$acct_config" == "y" || "$acct_config" == "Y" ]]; then
        echo "Skipping AWS account configuration."
    else
        aws configure
    fi
}

s3_bucket () {
    echo "Available buckets: "
    aws s3 ls
    echo "----....----"
    read -p "Enter the bucket name or create new bucket (y/n): " bucket_choice
    if [[ "$bucket_choice" == "y" || "$bucket_choice" == "Y" ]]; then
        read -p "Enter new bucket name: " new_bucket
        aws s3 mb s3://"$new_bucket"
    else
        read -p "Enter existing bucket name: " bucket_name
    fi
    return
}

s3_file_uploader(){
    local file="$1"
    echo "----....----....----"
    echo "$file is uploading to $bucket_name..."
        aws s3 cp "$file" s3://"$bucket_name"
}

acct_authentication

s3_bucket

for file in "$@"; do
    if [ -f "$file" ]; then
        s3_file_uploader "$file"
    else
        echo "Error: $file does not exist"
    fi
done
