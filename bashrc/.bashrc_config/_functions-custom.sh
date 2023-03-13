# Custom functions.
# Usage:
#     chmodd 0775 .
#     chmodf 0664 .
chmodf() {
	find "$2" -type f -exec chmod "$1" {} \;
}

chmodd() {
	find "$2" -type d -exec chmod "$1" {} \;
}
