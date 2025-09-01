#!/bin/bash

# A simple script to commit changes with a specific timestamp.
# Usage: ./commit_script.sh "YYYY-MM-DD_hh:mm:ss" "Commit message"

# Check if the correct number of arguments is provided.
if [ "$#" -ne 2 ]; then
  echo "Error: Incorrect number of arguments."
  echo "Usage: $0 \"YYYY-MM-DD_hh:mm:ss\" \"Commit message\""
  exit 1
fi

TIMESTAMP="$1"
MESSAGE="$2"

# Define the expected date format using a regular expression.
# It checks for YYYY-MM-DD_hh:mm:ss format.
DATE_REGEX="^[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}:[0-9]{2}:[0-9]{2}$"

# Check if the timestamp format matches the regex.
if [[ ! "$TIMESTAMP" =~ $DATE_REGEX ]]; then
  echo "Error: The provided timestamp format is invalid."
  echo "Expected format: YYYY-MM-DD_hh:mm:ss"
  exit 1
fi

# Convert the timestamp from the provided format to the one git expects.
# The 's' at the end of the format tells 'date' to parse it from a string.
# We no longer append a timezone offset, which tells git to use the
# system's local time.
GIT_DATE=$(date -d "${TIMESTAMP//_/\ }" "+%Y-%m-%d %H:%M:%S")

# Set the GIT_COMMITTER_DATE and GIT_AUTHOR_DATE environment variables
# to use the provided timestamp for the commit.
GIT_COMMITTER_DATE="$GIT_DATE" GIT_AUTHOR_DATE="$GIT_DATE" git commit -m "$MESSAGE"

if [ $? -eq 0 ]; then
  echo "Successfully committed with timestamp $TIMESTAMP."
else
  echo "Git commit failed. Please check the status of your repository."
fi
