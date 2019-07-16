#!/usr/bin/env bash

cd "$(dirname "$0")"

if [ -f .env ]; then
	export $(cat .env | sed 's/#.*//g' | xargs)
fi

LOCKFILE=".lock"

if [ -f "$LOCKFILE" ] && kill -0 "$(cat $LOCKFILE)" 2>/dev/null; then
	echo "Updating"
	exit 1
fi

echo $$ > $LOCKFILE

git pull

$UPDATER

git add -A
git commit --no-gpg-sign -a -m "$(git status --porcelain | wc -l) files | $(git status --porcelain | sed '{:q;N;s/\n/, /g;t q}' | sed 's/^ *//g')"
git push

rm $LOCKFILE
