#!/bin/bash

OUTPUT_DIR="."
INPUT_DIR="${@: -1}"

IS_DESTRUCTIVE=false

VALID_ARGS=$(getopt -o "fenc:d:t:m:o:h"\
                    --long "copy-stdin,delete-stdin,trash-stdin,move-stdin,\
                    clip-regex-end:,delete-extension:,trash-extension:,\
                    copy-extension:,move-extension:,flatten-directory,\
                    list-extensions,list-filenames,copy-regex:,delete-regex:,\
                    trash-regex:,move-regex:,substitute-regex:,output:,help,\
                    destructive" -- "$@")

if [[ $? -ne 0 ]]; then
    exit 1;
fi

eval set -- "$VALID_ARGS"

while true; do
    case "$1" in
        -f | --flatten-directory)
            if [[ $IS_DESTRUCTIVE == true ]]; then
                find $INPUT_DIR -type f -print0 | xargs -0 -I{} mv {} $OUTPUT_DIR
                if [[ $INPUT_DIR != $OUTPUT_DIR ]]; then
                    rm -r $INPUT_DIR
                fi
            else
                find $INPUT_DIR -type f -print0 | xargs -0 -I{} cp {} $OUTPUT_DIR
            fi
            shift
            continue
            ;;
        -e | --list-extensions)
            # Passes nested directory listing through two regexes:
            # 1. Detect lines with filename extensions. Looks for pattern .*(\.[^\./]+)$, and takes only the paranthesized region
            # If the first regex fails (i.e. the file has no extension), a second regex is used
            # 2. Detect filenames (all files that make it to this step will have no extensions). Looks for pattern .*/([^\./]+)$
            find $INPUT_DIR -type f | sed -e "s/.*\(\.[^\.\/]\+\)$/\1/" | sed -e "s/.*\/\([^\/\.]\+\)$/\1/" | sort | uniq -c
            shift
            continue
            ;;
        -n | --list-filenames)
            find $INPUT_DIR | sed -e "s/^.*\///" | sort | uniq -c
            shift
            continue
            ;;
        -c | --copy-regex)
            find $INPUT_DIR -regex $2 -type f -print0 | xargs -0 -I{} cp {} $OUTPUT_DIR
            shift 2
            continue
            ;;
        -d | --delete-regex)
            find $INPUT_DIR -regex $2 -type f -print0 | xargs -0 -I{} rm {}
            shift 2
            continue
            ;;
        -t | --trash-regex)
            mkdir -p ~/.local/share/Trash
            find $INPUT_DIR -regex $2 -type f -print0 | xargs -0 -I{} mv {} ~/.local/share/Trash
            shift 2
            continue
            ;;
        -m | --move-regex)
            find $INPUT_DIR -regex $2 -type f -print0 | xargs -0 -I{} mv {} $OUTPUT_DIR
            shift 2
            continue
            ;;
        -o | --output)
            OUTPUT_DIR="$2"
            shift 2
            continue
            ;;
        -h | --help)
            echo "USAGE: manage.sh [OPTIONS]... SOURCE"
            echo "  or:  manage.sh -o DEST [OPTIONS]... SOURCE"
            echo "Perform OPTION(s) on SOURCE directory, and prefer output to DEST if applicable"
            echo "Multiple operations can be performed in a single invocation. Flags will be"
            echo "evaluated in order."
            echo "See the man page for more detail."
            shift
            continue
            ;;
        --substitute-regex)
            IFS=',' read -ra regexes <<< $2
            readarray -d $'\0' -t filenames < <(find $INPUT_DIR -regex ".*${regexes[0]}.*" -type f -print0)
            for filename in "${filenames[@]}"; do
                newfilename=$(basename $filename | sed -e "s/${regexes[0]}/${regexes[1]}/")
                if [[ $IS_DESTRUCTIVE == true ]]; then
                    targetdir="$(dirname $filename)"
                    mv $filename "$targetdir/$newfilename"
                else
                    targetdir="$(realpath $OUTPUT_DIR)/$(realpath $(dirname $filename))"
                    mkdir -p $targetdir
                    cp $filename "$targetdir/$newfilename"
                fi
            done
            shift 2
            continue
            ;;
        --copy-stdin)
            xargs -I{} cp {} $OUTPUT_DIR
            shift
            continue
            ;;
        --delete-stdin)
            xargs -I{} rm {}
            shift
            continue
            ;;
        --trash-stdin)
            mkdir -p ~/.local/share/Trash/
            xargs -I{} mv {} ~/.local/share/Trash/
            shift
            continue
            ;;
        --move-stdin)
            xargs -I{} mv {} $OUTPUT_DIR
            shift
            continue
            ;;
        --clip-regex-end)
            readarray -d $'\0' -t filenames < <(find $INPUT_DIR -regex ".*$2" -type f -print0)
            for filename in "${filenames[@]}"; do
                newfilename=$(basename $filename | sed -e "s/$2//")
                if [[ $IS_DESTRUCTIVE == true ]]; then
                    targetdir="$(dirname $filename)"
                    mv $filename "$targetdir/$newfilename"
                else
                    targetdir="$(realpath $OUTPUT_DIR)/$(realpath $(dirname $filename))"
                    mkdir -p $targetdir
                    cp $filename "$targetdir/$newfilename"
                fi
            done
            shift 2
            continue
            ;;
        --delete-extension)
            find $INPUT_DIR -iregex ".*$2" -type f -print0 | xargs -0 rm
            shift 2
            continue
            ;;
        --trash-extension)
            mkdir -p ~/.local/share/Trash/
            find $INPUT_DIR -iregex ".*$2" -type f -print0 | xargs -0 -I{} mv {} ~/.local/share/Trash/
            shift 2
            continue
            ;;
        --copy-extension)
            find $INPUT_DIR -iregex ".*$2" -type f -print0 | xargs -0 -I{} cp {} $OUTPUT_DIR
            shift 2
            continue
            ;;
        --move-extension)
            find $INPUT_DIR -iregex ".*$2" -type f -print0 | xargs -0 -I{} mv {} $OUTPUT_DIR
            shift 2
            ;;
        --destructive)
            IS_DESTRUCTIVE="true"
            shift 1
            ;;
        *)
            shift
            break
            ;;
    esac
done
