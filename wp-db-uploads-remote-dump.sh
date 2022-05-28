#!/bin/bash

# This is an example of DB bump script for WordPress site.
# It uses WP-CLI to import DB dump to local machine.
#
# Along with DB dump, at the bottom you can see rsync command for coping entire
# uploads folder from remote server to your local computer.
#
#
#

# Allowed params:
# 1) comma-separated tables names to import into local table (if set then dump file will not be saved to 'dump' folder).

REMOTE_DOM='dev.holder.io'
LOCAL_DOM='holder.loc'

SSH_ID='holder'

# remote site root dir - relative to ~/ (login user dir)
REMOTE_DIR="web/www/$REMOTE_DOM/www"  # holder
#REMOTE_DIR="$REMOTE_DOM/www"         # beget

# local site root dir
LOCAL_DIR="$HOME/sites/WORK/$LOCAL_DOM/www"
WP_MAINTENANCE_FILE_DIR="$LOCAL_DIR/wp/.maintenance"

# full path to the dir where collect bumps
DUMP_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
DUMP_DIR+="/dump"

# switch to local dir
cd "$LOCAL_DIR" || exit


TABLES=''
if [ -n "$1" ]; then
	TABLES="--tables=$1"
fi

info(){
	BLUE='\033[1;34m'
    NC='\033[0m' # No Color
	printf "${BLUE}[%s]${NC}\n" "$1";
}


# Create DB DUMP
info 'generate dump'; ssh $SSH_ID "cd $REMOTE_DIR && wp db export - $TABLES --add-drop-table --default-character-set=utf8mb4 | gzip > ./dump.sql.gz"

# copy dump file to current dir
info 'download dump'; scp $SSH_ID:$REMOTE_DIR/dump.sql.gz .

# remove remote
info 'remove remote'; ssh $SSH_ID "rm $REMOTE_DIR/dump.sql.gz"


# TABLES empty - save bump
if [ -z "$TABLES" ]; then
	# save to dumps folder and ungzip
	cp dump.sql.gz "$DUMP_DIR/dump-$( date +%Y-%m-%d ).sql.gz"
fi

gzip -d dump.sql.gz

echo "<?php \$upgrading = $(date +%s);" > "$WP_MAINTENANCE_FILE_DIR"

info 'WP MAINTENANCE ON - sleep 60 sec to complate php parser processes (if there is some)'
sleep 60

# import to curent db
info 'Import dump';   wp db import dump.sql
info 'rm dump';       rm dump.sql
info 'Replace in DB'; wp search-replace $REMOTE_DOM $LOCAL_DOM wp_options wp_posts wp_comments wp_postmeta wp_usermeta wp_commentmeta
wp cache flush
rm "$WP_MAINTENANCE_FILE_DIR"

# TABLES empty - save bump
if [ -z "$TABLES" ]; then
	# copy uploads from remote
	#rsync -azvhe ssh $SSH_ID:$REMOTE_DIR/wp-content/uploads wp-content
	true
fi




