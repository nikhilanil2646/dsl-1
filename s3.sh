#!/bin/bash
set -e
set -x

process_args() {
    while [ $# -gt 1 ]
    do
        key="$1"
        case $key in
            -bfp | --backup-path)
                backup_path="$2"
                shift # past argument
            ;;
            -bf | --backup-file)
                backup_file="$2"
                shift # past argument
            ;;
            -bn | --bucket-name)
                bucket="$2"
                shift # past argument
            ;;
            -sa | --s3-action)
                action="$2"
                shift # past argument
            ;;
                -dt | --db-type)
                 db_type="$2"
                 shift # past argument
             ;;

            *) echo "Invalid option $1" >&2
            exit 1
            ;;
        esac
        shift # past argument or value
    done

}

if [ $# -ne 10 ]
then
    echo "usage: s3.sh --backup-path <backup_path> --backup-file <backup_file> --bucket-name <bucket> --s3-action <upload/download> --db-type <db_type>"
    exit 1
fi

set_vars() {
upload_path="db_backups/"$db_type
date=`echo $backup_file|cut -d'_' -f4`
if [ "$date" = 07 ] || [ "$date" = 14 ] || [ "$date" = 21 ] || [ "$date" = 28 ];then
        db_dir="weekly"
elif [ "$date" = 01 ];then
        db_dir="monthly"
else
        db_dir="daily"
fi
}

s3_upload() {
aws s3 cp ${backup_path}/${backup_file} s3://${bucket}/${upload_path}/${db_dir}/${backup_file}
}

s3_download() {
aws s3 cp s3://${bucket}/${upload_path}/${db_dir}/${backup_file} ${backup_path}/${backup_file}
}

process_args $@
set_vars
s3_${action}