#!/bin/bash

##Create Bucket and User test-bucket
couchbase-cli bucket-create \
    -c localhost:8091 \
    --username Administrator \
    --password password \
    --bucket test-bucket \
    --bucket-ramsize 128 \
    --bucket-type couchbase
couchbase-cli user-manage \
    -c localhost:8091 \
    --username Administrator \
    --password password \
    --set \
    --rbac-username test-user \
    --rbac-password password \
    --roles bucket_admin[test-bucket] \
    --auth-domain local

##Index Buckets
cbq -e couchbase://localhost -u Administrator -p password --script="CREATE PRIMARY INDEX \`idx-test-bucket\` ON \`test-bucket\` USING GSI"