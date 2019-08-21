#!/bin/bash

declare -A BUCKET_MAP
BUCKET_MAP['dev']='development'

BUCKET=${BUCKET_MAP[$1]}

case $2 in
  "cpt" )
    echo "aws s3 cp --sse AES256 $3 s3://${BUCKET}/$4 --profile $1"
    aws s3 cp --sse AES256 $3 s3://${BUCKET}/"$4" --profile "$1"
    ;;

  "cpf" )
    echo "aws s3 cp s3://${BUCKET}/$3 $3 --profile $1"
    aws s3 cp s3://${BUCKET}/"$3" "$3" --profile "$1"
    ;;

  "mv" )
    echo "aws s3 mv --sse AES256 s3://${BUCKET}/$3 s3://${BUCKET}/$4 --profile $1"
    aws s3 mv --sse AES256 s3://${BUCKET}/"$3" s3://${BUCKET}/"$4" --profile "$1"
    ;;

  "ls" )
    echo "s3 ls s3://${BUCKET}/$3 --profile $1 | more"
    aws s3 ls s3://${BUCKET}/"$3" --profile "$1" | more
    ;;

  * )
    echo "$0 [profile] [cmd] [options]"
    echo
    echo "profiles"
    echo "- dev     development"
    echo "- cwd     contentwise development"
    echo "- cwp     contentwise production"
    echo "- gdev    google development"
    echo
    echo "cmds"
    echo "- cpt   copy to"
    echo "- cpf   copy from"
    echo "- mv    move"
    echo "- ls    list"
    ;;
esac