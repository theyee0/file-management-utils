#!/bin/bash

OUTPUT_DIR="."

# Features:
# (f,--flatten-directory) Flatten file directory
# (e,--list-extensions) List all file extensions
# (n,--list-filenames) Extract filenames (excluding extension)
# (c,--copy-regex) Copy all files matching a regex
# (d,--delete-regex) Delete files matching a regex
# (t,--trash-regex) Trash files matching regex
# (m,--move-regex) Move all files matching a regex
# (r,--move-regex) Rename files by a regex
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

VALID_ARGS=$(getopt -o "fenc:d:t:m:r:o:h"\
		    --long copy-stdin,delete-stdin,trash-stdin,move-stdin,\
		    clip-regex-end,delete-extension,trash-extension,\
		    copy-extension,move-extension,flatten-directory,\
		    list-extensions,list-filenames,copy-regex,delete-regex,\
		    trash-regex,move-regex,rename-regex,output,help -- "$@")

if [[$? -ne 0]]; then
    exit 1;
fi

eval set -- "$VALID_ARGS"
while [ : ]; do
    case "$1" in
	-f | --flatten-directory)
	    ;;
	-e | --list-extensions)
	    ;;
	-n | --list-filenames)
	    ;;
	-c | --copy-regex)
	    ;;
	-d | --delete-regex)
	    ;;
	-t | --trash-regex)
	    ;;
	-m | --move-regex)
	    ;;
	-r | --rename-regex)
	    ;;
	-o | --output)
	    OUTPUT_DIR="$2"
	    ;;
	-h | --help)
	    ;;
	--copy-stdin)
	    ;;
	--delete-stdin)
	    ;;
	--trash-stdin)
	    ;;
	--move-stdin)
	    ;;
	--clip-regex-end)
	    ;;
	--delete-extension)
	    ;;
	--trash-extension)
	    ;;
	--copy-extension)
	    ;;
	--move-extension)
	    ;;
    esac
done
