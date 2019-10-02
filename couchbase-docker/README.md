# Couchbase Docker
This docker image and script will help you designed to help you easily configure and manage your couchbase instance.

## About
Couchbase data files will be persisted in the local `.datafiles` directory.  This folder can be deleted, backed up, or moved directly if you need to manage the data for testing purposes.

### Create a local link to allow the script to be accessed by just couchbase
This will allow the command to be executed with the alias couchbase.  Run from the project directory
```
sudo ln -sfn $(pwd)/couchbase.sh /usr/local/sbin/couchbase
```

## Usage
couchbase              Start couchbase will use default ports 8091-8094 and 11210
couchbase -h           Show help
couchbase -r           This will refresh the discovery-couchbase image (Only needed if discovery-couchbase updates)