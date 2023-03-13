#!/bin/bash

####
# Extract single table data from MySQL dump SQL file to .sql file
#
# chmod -x extract-table-from-dump.sh
# bash extract-table-from-dump.sh {dumpfile.sql} {table_name_to_extract}
#
# Example:
#
#     bash /dir/extract-table-from-dump.sh  /dir/dump/dump.sql price_recent
#
# Will Create file: /dir/dump/dump--price_recent.sql
####

if [ $# -lt 2 ] ; then
  echo "Wrong usage. Correct is: $ bash extract-table-from-dump.sh {dumpfile.sql} {table_name_to_extract}"
  exit
fi

# CURRENT_FILE_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
DUMP_FILE="$1"
DEST_FILE="${DUMP_FILE%.sql}--$2.sql"

sed -n -e "/-- Table structure for table \`$2\`/,/-- Table structure for table/p" "$DUMP_FILE" > "$DEST_FILE"


