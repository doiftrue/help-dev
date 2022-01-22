#!/bin/bash

DOM='yoursite.ru'
LOCAL_DOM='yoursite.dev'

# site document root dir path
LOCAL_DIR="$HOME/sites/$LOCAL_DOM/public_html"
# dir on the remove server relative to login dir
REMOTE_DIR="$DOM/public_html"
# full path to the dir where collect bumps
DUMP_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"


cd "$LOCAL_DIR" || exit

# Create DB DUMP
ssh beget "cd $REMOTE_DIR && wp db export - --add-drop-table --default-character-set=utf8mb4 | gzip > ./dump.sql.gz"

# copy dump file to current dir
scp beget:$REMOTE_DIR/dump.sql.gz .

# remove remote
ssh beget "rm $REMOTE_DIR/dump.sql.gz"

# save to dumps folder and ungzip
cp dump.sql.gz "$DUMP_DIR/dump-$( date +%Y-%m-%d ).sql.gz"
gzip -d dump.sql.gz

# import to curent db
wp db import dump.sql
wp search-replace $DOM $LOCAL_DOM
rm dump.sql

# copy uploads from remote
rsync -avzhe ssh beget:homyachishka.ru/public_html/wp-content/uploads wp-content