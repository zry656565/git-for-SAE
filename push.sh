#!/bin/bash

#include config
source "../git-for-SAE/config"

arg=$(echo $1|bc 2>/dev/null)
log() {
	echo "[push.sh]: $1"
}

if [ $arg -lt 1 -o $arg -gt 10 ]; then
	echo "[usage]: push.sh $num(SAE-version)"
	echo "[example]: push.sh 1"
	exit
fi

sae_version=$1
svn_repo_url="https://svn.sinaapp.com/$svn_repo_name"
svn_dir_name="$svn_repo_name/$1"

#if [.svn] doesn't exist, checkout svn project
if [ ! -e ".svn" ]; then
	log "checkout svn project..."
	mkdir .svn
	cd .svn
	svn checkout $svn_repo_url
	cd ..
	log "add .svn to .gitignore"
	if [ -e ".gitignore" ]; then
		echo "" >> .gitignore
	fi
	echo ".svn" >> .gitignore
	echo ".svn/*" >> .gitignore
fi

log "remove all previous files..."
cd ".svn/$svn_dir_name"
mv config.yaml ../config.yaml
rm -rf *
mv ../config.yaml config.yaml
svn st | awk '{print $2}' | xargs svn delete
svn commit -m "clean"
cd ../../..

log "copy git repo to SAE-svn..."
mv -f .svn ../.svn
cp -rf * "../.svn/$svn_dir_name"
mv -f ../.svn .svn
log "copy Done."
cd ".svn/$svn_dir_name"
log "svn add all..."
#add all files
svn st | awk '{if ( $1 == "?") { print $2 }}' | xargs svn add
#log "apply gitignore..."
#cat ../../../.gitignore | awk '{if ($1 != ".svn" && $1 != ".svn/*")print $1}' | xargs svn propset svn:ignore .
log "svn commit..."
svn commit -m "modify"
log "If there is no error below, the pushing job has been done."