#!/bin/bash

declare -A BUCKET_MAP
BUCKET_MAP['dev']='development'

PROFILE=$2
BUCKET=${BUCKET_MAP[$PROFILE]}

display_help() {
    echo "Usage: $0 <command> <profile> [options]" >&2
    echo "Usage: $0 help" >&2
    echo "Usage: $0 <command> help" >&2
    echo "Tool Description"
    echo "S3 Commands for the lazy"
    echo
    echo "Profiles"
    echo "   dev            development"
    echo
    echo "Commands"
    echo "   ls             list files"
    echo "   cpt            copy to S3"
    echo "   cpf            copy from S3"
    echo "   mv             move file"
    echo "   rm             remove file"
    exit 1
}

ls() {
    if [[ $2 = help ]]
    then
      echo "Usage: $0 $1 <profile> [path]" >&2
      echo
      echo "path is an optional parameter representing an path in the s3 bucket with ending in /"
      echo
      echo "Examples:"
      echo "$0 $1 dev archive/ "
      echo "$0 $1 dev archive/2019-01-01/"
      exit 1
    fi

    echo "aws ls s3://${BUCKET}/$3 --profile $PROFILE | more"
    aws s3 ls s3://${BUCKET}/"$3" --profile "$PROFILE" | more
}

cpt() {
    if [[ $2 = help ]]
    then
      echo "Usage: $0 $1 <profile> [file] [folder]" >&2
      echo
      echo "file is a REQUIRED parameter of the file you want to upload to s3"
      echo "folder is an optional parameter representing a folder in the s3 bucket with ending in /"
      echo
      echo "Examples:"
      echo "$0 $1 dev data.txt"
      echo "$0 $1 dev data.txt archive/2019-01-01/"
      exit 1
    fi
    echo "aws s3 cp --sse AES256 $3 s3://${BUCKET}/$4 --profile $PROFILE"
    aws s3 cp --sse AES256 $3 s3://${BUCKET}/"$4" --profile "$PROFILE"
}

cpf() {
    if [[ $2 = help ]]
    then
      echo "Usage: $0 $1 <profile> [file]" >&2
      echo
      echo "file is a REQUIRED parameter of the file you want to download from s3"
      echo "  - file can include a folder prefix"
      echo
      echo "Examples:"
      echo "$0 $1 dev data.txt"
      echo "$0 $1 dev archive/2019-01-01/data.txt"
      exit 1
    fi
    echo "aws s3 cp s3://${BUCKET}/$3 $3 --profile $PROFILE"
    aws s3 cp s3://${BUCKET}/"$3" "$3" --profile "$PROFILE"
}

mv() {
    if [[ $2 = help ]]
    then
      echo "Usage: $0 $1 <profile> [source] [destination]" >&2
      echo
      echo "source is a REQUIRED parameter of the file you want to move"
      echo "  - file can include a folder prefix"
      echo "destination is a REQUIRED parameter of the folder you want to move the file too"
      echo
      echo "Examples:"
      echo "$0 $1 dev data.txt archive/2019-01-01/"
      echo "$0 $1 dev archive/2020-01-01/data.txt archive/2019-01-01/"
      exit 1
    fi
    echo "aws s3 mv --sse AES256 s3://${BUCKET}/$3 s3://${BUCKET}/$4 --profile $PROFILE"
    aws s3 mv --sse AES256 s3://${BUCKET}/"$3" s3://${BUCKET}/"$4" --profile "$PROFILE"
}

rm() {
    if [[ $2 = help ]]
    then
      echo "Usage: $0 $1 <profile> [file]" >&2
      echo
      echo "file is a REQUIRED parameter of the file you want to remove"
      echo "  - file can include a folder prefix"
      echo
      echo "Examples:"
      echo "$0 $1 dev data.txt"
      echo "$0 $1 dev archive/2019-01-01/data.txt"
      exit 1
    fi
    echo "aws s3 rm s3://${BUCKET}/$3 --profile $PROFILE"
    aws s3 rm s3://${BUCKET}/"$3" --profile "$PROFILE"
}

case $1 in
  -h | --help | help)
    display_help
    ;;

  "cpt" )
    cpt "$@"
    ;;

  "cpf" )
    cpf "$@"
    ;;

  "mv" )
    mv "$@"
    ;;

  "ls" )
    ls "$@"
    ;;

  "rm" )
    rm "$@"
    ;;

  *)
    display_help
    ;;
esac