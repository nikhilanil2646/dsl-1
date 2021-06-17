#!/bin/bash
set -x
set -e

process_args() {
    while [ $# -gt 1 ]
    do
        key="$1"
        case $key in
            -bh | --backup-home)
                backup_home="$2"
                shift # past argument
            ;;
            -sp | --s3-source-backup-path)
                s3_source_backup_path="$2"
                shift #past argument
            ;;
            -su | --restore-host-user)
                restore_host_user="$2"
                shift #past argument
            ;;
            -si | --restore-host-ip)
                restore_host_ip="$2"
                shift #past argument
            ;;
            -bn | --source-bucket-name)
                source_bucket_name="$2"
                shift #past argument
            ;;
            -dl | --db-type-list)
                db_type_list="$2"
                shift #past argument
            ;;
            -mod | --mongo-dump-name)
                mongodb_dump_name="$2"
                shift #past argument
            ;;
            -myd | --mysql-dump-name)
                mysql_dump_name="$2"
                shift #past argument
            ;;
            *) echo "Invalid option $1" >&2
            exit 1
            ;;
        esac
        shift # past argument or value
    done
}


download_dump() {
db_type=$1
dump_name="${db_type}"_dump_name
dump_name=${!dump_name}
date=$(echo "$dump_name"|cut -d "_" -f 4)
mkdir -p "$s3_source_backup_path"/"$db_type"
echo $dump_name $date > "$s3_source_backup_path"/"$db_type"/backup_detail.tmp
if [[ -z "$dump_name" || "$dump_name" != *tar.gz ]];then
    dump_name=$(bash "$backup_home"/latest_dump.sh --backup-home "$backup_home" --db-type "$db_type" --s3-source-backup-path "$s3_source_backup_path" --bucket-name "$source_bucket_name")
fi
mkdir -p $backup_home/db_backups/"$db_type"
bash "$backup_home"/s3.sh --s3-source-backup-path $s3_source_backup_path/"$db_type" --dump-name $dump_name --bucket-name $source_bucket_name --s3-action download --db-type "$db_type"
rsync -avz --remove-source-files $s3_source_backup_path/"$db_type"/$dump_name -e ssh $restore_host_user@$restore_host_ip:$backup_home/db_backups/"$db_type"/
rsync -avz --remove-source-files $s3_source_backup_path/"$db_type"/backup_detail.tmp -e ssh $restore_host_user@$restore_host_ip:$backup_home/db_backups/"$db_type"
}


# Main script starts here
if [ $# -ne 16 ] && [ $# -ne 14 ]
then
    echo "usage: db_update_with_prod_dump.sh --backup-home <backup-home> --s3-source-backup-path <s3-source-backup-path> --restore-host-user <restore_host_user>
                --restore-host-ip <restore_host_ip> --source_bucket_name <source_bucket_name> --mongo-dump-name <mongo-dump-name> --mysql-dump-name <mysql-dump-name>"
    exit 1
fi


process_args $@
for db in $(echo $db_type_list | sed "s/,/ /g")
do
    download_dump $db
done