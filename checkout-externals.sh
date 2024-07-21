#!/bin/bash

checkout()
{
    local repo=$1
    local dir=$2
    local branch=$3

    [[ -z $dir ]] && dir=$( echo "$repo" | sed "s~.*/\([a-zA-Z0-9_\-]*\)~externals/\1~") #"

    if [[ ! -d $dir ]]
    then
        git clone $repo $dir
        if [[ -n $branch ]]
        then
            cd $dir; git checkout $branch; cd - >/dev/null;
        fi
    else
        echo "$dir"
        cd $dir; git pull; cd - >/dev/null;
    fi
}

checkout git@github.com:trodevel/python_mysql_executor     ""        1.1.0
checkout git@github.com:trodevel/hr_common_types           ""        1.3.0
checkout git@github.com:trodevel/hr_query_parser           ""        4.0.0
checkout git@github.com:trodevel/hr_hunt_db                ""        2.0.0
checkout git@github.com:trodevel/mysql_unique_id_generator ""        1.0.0
checkout git@github.com:trodevel/aux_logger                ""        1.1.0
checkout git@github.com:trodevel/languages                 ""        1.0.0
checkout git@github.com:trodevel/currencies                ""        1.0.0
