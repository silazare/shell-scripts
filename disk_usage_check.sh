#!/bin/bash

MY_DIR="/home /staging"
echo "Top Ten Disk Space Usage"
for DIR in $MY_DIRECTORIES
  do
	echo "The $DIR Directory:"
	du -S $DIR 2>/dev/null |sort -rn |sed '{11,$D; =}' |sed 'N; s/\n/ /' |awk '{printf $1 ":" "\t" $2 "\t" $3 "\n"}'
	du -S $DIR | sort -rn | head | cat -n | awk '{printf $1 ":" "\t" $2 "\t" $3 "\n"}'
  done
exit