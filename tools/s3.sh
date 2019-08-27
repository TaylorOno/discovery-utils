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

case $1 in
  -h | --help | help)
    display_help
    ;;
  "cpt" )
    echo "aws s3 cp --sse AES256 $3 s3://${BUCKET}/$4 --profile $PROFILE"
    aws s3 cp --sse AES256 $3 s3://${BUCKET}/"$4" --profile "$PROFILE"
    ;;

  "cpf" )
    echo "aws s3 cp s3://${BUCKET}/$3 $3 --profile $PROFILE"
    aws s3 cp s3://${BUCKET}/"$3" "$3" --profile "$PROFILE"
    ;;

  "mv" )
    echo "aws s3 mv --sse AES256 s3://${BUCKET}/$3 s3://${BUCKET}/$4 --profile $PROFILE"
    aws s3 mv --sse AES256 s3://${BUCKET}/"$3" s3://${BUCKET}/"$4" --profile "$PROFILE"
    ;;

  "ls" )
    echo "aws ls s3://${BUCKET}/$3 --profile $PROFILE | more"
    aws s3 ls s3://${BUCKET}/"$3" --profile "$PROFILE" | more
    ;;

  "rm" )
    echo "aws s3 rm s3://${BUCKET}/$3 --profile $PROFILE"
    aws s3 rm s3://${BUCKET}/"$3" --profile "$PROFILE"
    ;;
  *)
    display_help
    ;;
esac
