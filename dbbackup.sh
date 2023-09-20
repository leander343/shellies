#!/bin/bash
USERNAME=root
HOSTS="xx.xx.xx.xx"
while [[ $# -gt 0 ]]
    do
    key="$1"
    echo $key
    case ${key} in
        -u|--username)
        USERNAME=$2
        shift
        ;;
        -h|--host)
        HOSTS=$2
        shift
        ;;
        -db|--dbname)
        DB=$2
        shift
        ;;
        -p|--path)
        FOLDER=$2
        shift
        ;;
        *)
        POSITIONAL+=("$1")
        shift
        ;;
    esac
done
set -- "${POSITIONAL[@]}"
echo "scp ${USERNAME}@${HOSTS}:/root/project_bckp/${DB} .${FOLDER}"
scp ${USERNAME}@${HOSTS}:/root/project_bckp/${DB} .${FOLDER}
