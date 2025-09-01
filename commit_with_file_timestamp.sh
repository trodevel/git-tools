#!/bin/bash

# A script to commit changes to Git, setting the commit and author
# dates to the modification timestamp of the file.

# Check if the correct number of arguments are provided.
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <filename> \"<commit_message>\""
    echo "Example: $0 README.md \"Update README with new instructions\""
    exit 1
fi

FILE_PATH="$1"
COMMIT_MESSAGE="$2"

# 1. Check if the specified file exists.
if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File '$FILE_PATH' not found."
    exit 1
fi

# 2. Get the file's modification timestamp in seconds since the epoch.
# This command is portable between Linux and macOS.
# On Linux, 'stat' uses '-c %Y'. On macOS, it's '-f %m'.
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    TIMESTAMP=$(stat -c %Y "$FILE_PATH")
elif [[ "$OSTYPE" == "darwin"* ]]; then
    TIMESTAMP=$(stat -f %m "$FILE_PATH")
else
    echo "Error: Unsupported OS. This script works on Linux and macOS."
    exit 1
fi

# Get the current local timezone offset (e.g., +0100, -0500).
TIMEZONE_OFFSET=$(date +%z)
GIT_DATE_STRING="${TIMESTAMP} ${TIMEZONE_OFFSET}"

# 3. Execute the git commit command with the dates set.
# The `GIT_AUTHOR_DATE` and `GIT_COMMITTER_DATE` environment variables
# override the default values.
echo "Committing with timestamp $(date -d "@$TIMESTAMP" "+%Y-%m-%d %H:%M:%S")"
GIT_AUTHOR_DATE="$GIT_DATE_STRING" GIT_COMMITTER_DATE="$GIT_DATE_STRING" git commit -m "$COMMIT_MESSAGE"

# Check the exit status of the git commit command.
if [ $? -eq 0 ]; then
    echo "Successfully committed."
else
    echo "Git commit failed. Please check the status and try again."
fi
