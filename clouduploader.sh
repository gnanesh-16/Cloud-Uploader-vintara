#!/bin/bash

# CloudUploader CLI - Uploads files into Cloud Storage services{AWS s3}

LOG_FILE="upload.log"

# Function to handle AWS account authentication
acct_authentication () {
    read -p "Skip AWS Account Configuration (Y/N) : " acct_config
    if [[ "$acct_config" == "y" || "$acct_config" == "Y" ]]; then
        echo "Skipping AWS account configuration."
    else
        aws configure
    fi
}

# Function to select or create an S3 bucket
s3_bucket () {
    echo "Available buckets: "
    aws s3 ls
    echo "----....----"
    read -p "Enter the bucket name or create new bucket (y/n): " bucket_choice
    if [[ "$bucket_choice" == "y" || "$bucket_choice" == "Y" ]]; then
        read -p "Enter new bucket name: " new_bucket
        read -p "Enter bucket region (e.g., us-west-1): " bucket_region
        aws s3 mb s3://"$new_bucket" --region "$bucket_region"
        bucket_name="$new_bucket"
    else
        read -p "Enter existing bucket name: " bucket_name
    fi
    return
}

# Function to compress files before upload
compress_file () {
    local file="$1"
    tar -czf "${file}.tar.gz" "$file"
    echo "${file}.tar.gz"
}

# Function to upload files to S3 with progress bar and logging
s3_file_uploader(){
    local file="$1"
    local compressed_file=$(compress_file "$file")
    echo "----....----....----"
    echo "$compressed_file is uploading to $bucket_name..."
    start_time=$(date +%s)
    aws s3 cp "$compressed_file" s3://"$bucket_name" --progress | tee -a "$LOG_FILE"
    end_time=$(date +%s)
    upload_time=$((end_time - start_time))
    echo "Upload completed in $upload_time seconds" | tee -a "$LOG_FILE"
}

# Function to validate file existence and size
validate_file () {
    local file="$1"
    if [ -f "$file" ]; then
        local filesize=$(stat -c%s "$file")
        if (( filesize > 0 )); then
            return 0
        else
            echo -e "\e[31mError: $file is empty\e[0m" | tee -a "$LOG_FILE"
            return 1
        fi
    else
        echo -e "\e[31mError: $file does not exist\e[0m" | tee -a "$LOG_FILE"
        return 1
    fi
}

# Function to handle multi-part upload for large files
multipart_upload () {
    local file="$1"
    local compressed_file=$(compress_file "$file")
    echo "----....----....----"
    echo "$compressed_file is uploading to $bucket_name using multi-part upload..."
    start_time=$(date +%s)
    aws s3 cp "$compressed_file" s3://"$bucket_name" --expected-size $(stat -c%s "$compressed_file") --progress | tee -a "$LOG_FILE"
    end_time=$(date +%s)
    upload_time=$((end_time - start_time))
    echo "Multi-part upload completed in $upload_time seconds" | tee -a "$LOG_FILE"
}

acct_authentication

s3_bucket

for file in "$@"; do
    if validate_file "$file"; then
        filesize=$(stat -c%s "$file")
        if (( filesize > 52428800 )); then # 50MB threshold for multi-part upload
            multipart_upload "$file"
        else
            s3_file_uploader "$file"
        fi
    fi
done
