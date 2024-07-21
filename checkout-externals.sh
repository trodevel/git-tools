#!/bin/bash

#<hb>***************************************************************************
#
# checkout git externals
#
# USAGE: checkout-externals.sh [<project-externals>]
#
# Example: checkout-externals.sh
#
#          checkout-externals.sh project-externals.cfg
#
#<he>***************************************************************************

show_help()
{
    sed -e '1,/^#<hb>/d' -e '/^#<he>/,$d' $0 | cut -c 3-
}

checkout()
{
    local repo=$1
    local branch=$2
    local dir=$3

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

process_line()
{
    local LN="$1"

    local repo=$(     echo "$LN" | awk '{print $1;}' )
    local branch=$(   echo "$LN" | awk '{print $2;}' )
    local dest_dir=$( echo "$LN" | awk '{print $3;}' )

    echo "DEBUG: repo $repo, branch $branch, dest_dir '$dest_dir'"

    [[ -z $dest_dir ]] && dest_dir=$( echo "$repo" | sed "s~.*/\([a-zA-Z0-9_\-]*\)~externals/\1~") #"

    checkout "$repo" "$branch" "$dest_dir"
}

process()
{
    local INP=$1

    while IFS= read -r line;
    do
        process_line "$line"
    done < $INP
}

CONFIG=$1

[[ -z $CONFIG ]] && CONFIG=project-externals.cfg

[[ ! -f $CONFIG ]] && { echo "ERROR: cannot find config file $CONFIG"; show_help; exit 1; }

process $CONFIG
