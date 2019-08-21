# S3 Helper
I got tired of remembering bucket names and credentials

## Setup
This script requires the AWS CLI has been installed and the following profiles configured

dev _(developement)_  

### Create AWS Profiles
To configure these profiles use the command below. You will need to run the command for each profile listed above.
```
aws configure --profile {{profile name}}
AWS Access Key ID: {{accessKey}}
AWS Secret Access Key: {{secretKey}}
Default region name [None]:
Default output format [None]:
```
configuration will be written to file `~/.aws/profile`.  This file can be edited directly if needed.

### Create a local link to allow script to be accessed by just s3
This will allow the command to be executed with the alias s3.  Run from project directory
```
sudo ln -sfn $(pwd)/s3.sh /usr/local/sbin/s3
```

## Usage
This script provides for simple commands such as copy, list and move

### Help
```
./sh [profile] [cmd] [options]"
profiles"
- dev     development"
cmds"
- cpt   copy to"
- cpf   copy from"
- mv    move"
- ls    list"`
```

### Examples
