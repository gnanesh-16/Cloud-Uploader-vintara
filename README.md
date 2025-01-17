# AWS-S3-CloudUploader-CLI
CloudUploader is a command-line interface (CLI) tool designed to simplify uploading files to AWS S3 General purpose buckets. It automates the process of authentication and file transfer to buckets, providing a seamless experience for users who need a quick and efficient way to manage cloud storage.

- The script will handle AWS account authentication, bucket selection or creation, and then upload the provided files to the chosen bucket.
- S3 General purpose bucket is the default bucket type that is used for the majority of use cases in S3. General purpose buckets support all S3 features and most storage classes.You can store any number of objects in a bucket and can have up to 100 buckets in your account. 
# Features

- Easy authentication with AWS.
- Multiple files Upload directly to your S3 Bucket.

  ## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/sLokesh-code/AWS-S3-CLI.git
   ```
2. **Navigate to the Project Directory**:
   ```bash
   cd AWS-S3-CLI
   ```
3. **Run the clouduploader Script**:
   ```bash
   chmod +x clouduploader.sh
   ./clouduploader.sh file1.html file2.css file3.js

  ## Setting Environment Variables

AWS credentials can be skipped if credentials are good ,else the script handles for new credentials:

## Usage 

To upload a file to AWS  S3, use the following command:

```bash
./clouduploader.sh /path/to/file
```
To upload multiple files to AWS S3, use the following command:

```bash
./clouduploader.sh /path/to/file1 /path/to/file2 ...
