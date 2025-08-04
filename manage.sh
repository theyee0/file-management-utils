#!/bin/bash

# Features:
# (f,--flatten-directory) Flatten file directory
# (e,--list-extensions) List all file extensions
# (n,--list-filenames) Extract filenames (excluding extension)
# (c,--copy-regex) Copy all files matching a regex
# (d,--delete-regex) Delete files matching a regex
# (t,--trash-regex) Trash files matching regex
# (m,--move-regex) Move all files matching a regex
# (s,--substitute-regex) Rename files by a regex
# (o,--output) Output directory
# (h,--help) Help
# (--copy-stdin) Copy all files piped in to stdin
# (--delete-stdin) Delete files from stdin
# (--trash-stdin) Trash files from stdin
# (--move-stdin) Move files from stdin
# (--clip-regex-end) Clip end of strings
# (--delete-extension) Delete files with a given extension
# (--trash-extension) Trash files with a given extension (~/.local/share/trash)
# (--copy-extension) Copy all files with a given extension
# (--move-extension) Move all files with a given extension
# (--destructive) Destroy source, if applicable

OUTPUT_DIR="."
INPUT_DIR="${@: -1}"

IS_DESTRUCTIVE=false

VALID_ARGS=$(getopt -o "fenc:d:t:m::s:o:h"\
                    --long "copy-stdin,delete-stdin,trash-stdin,move-stdin,\
                    clip-regex-end,delete-extension,trash-extension,\
                    copy-extension,move-extension,flatten-directory,\
                    list-extensions,list-filenames,copy-regex,delete-regex,\
                    trash-regex,move-regex,substitute-regex,output,help,regex-based" -- "$@")

if [[ $? -ne 0 ]]; then
    exit 1;
fi

eval set -- "$VALID_ARGS"
unset VALID_ARGS

while true; do
    case "$1" in
        -f | --flatten-directory)
            files=$(find $INPUT_DIR -print0 -type f | sed -z -e "s/^.*\///")
            if [[ $IS_DESTRUCTIVE == true ]]; then
                echo $files | xargs -0 -I{} mv {} $OUTPUT_DIR
                rm -r $INPUT_DIR
            else
                echo $files | xargs -0 -I{} cp {} $OUTPUT_DIR
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
            find $INPUT_DIR --regex $2 -type f -0 | xargs -0 -I{} cp {} $OUTPUT_DIR
            shift 2
            continue
        ;;
        -d | --delete-regex)
            find $INPUT_DIR --regex $2 -type f -0 | xargs -0 rm
            shift 2
            continue
        ;;
        -t | --trash-regex)
            mkdir -p ~/.local/share/Trash
            find $INPUT_DIR --regex $2 -type f -0 | xargs -0 -I{} mv {} ~/.local/share/Trash
            shift 2
            continue
        ;;
        -m | --move-regex)
            find $INPUT_DIR --regex $2 -type f -0 | xargs -0 -I{} mv {} $OUTPUT_DIR
            shift 2
            continue
        ;;
        -s | --substitute-regex)
            echo "Not yet implemented!"
            shift 2
            continue
        ;;
        -o | --output)
            OUTPUT_DIR="$2"
            shift 2
            continue
        ;;
        -h | --help)
        ;;
        --regex-based)
            REGEX_BASED=true
            shift
            continue
        ;;
        --copy-stdin)
            find --regex $2 -type f -0 <&0 | xargs -0 -I{} cp {} $OUTPUT_DIR
            shift 2
            continue
        ;;
        --delete-stdin)
            find --regex $2 -type f -0 <&0 | xargs -0 -I{} rm
            shift 2
            continue
        ;;
        --trash-stdin)
            mkdir -p ~/.local/share/Trash/
            find --regex $2 -type f -0 <&0 | xargs -0 -I{} mv {} ~/.local/share/Trash/
            shift 2
            continue
        ;;
        --move-stdin)
            find --regex $2 -type f -0 <&0 | xargs -0 -I{} mv {} $OUTPUT_DIR
            shift 2
            continue
        ;;
        --clip-regex-end)
            echo "Not yet implemented!"
            shift
            continue
        ;;
        --delete-extension)
            find $INPUT_DIR --regex "^.*$2$" -type f -0 | xargs -0 rm
            shift 2
            continue
        ;;
        --trash-extension)
            mkdir -p ~/.local/share/Trash/
            find $INPUT_DIR --regex "^.*$2$" -type f -0 | xargs -0 -I{} mv {} ~/.local/share/Trash/
            shift 2
            continue
        ;;
        --copy-extension)
            find $INPUT_DIR --regex "^.*$2$" -type f -0 | xargs -0 -I{} cp {} $OUTPUT_DIR
            shift 2
            continue
        ;;
        --move-extension)
            find $INPUT_DIR --regex "^.*$2$" -type f -0 | xargs -0 -I{} mv {} $OUTPUT_DIR
        ;;
        --)
            shift
            break
        ;;
    esac
done
