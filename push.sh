#!/bin/bash

#include config
source "../git-for-SAE/config"

sae_version=$1
svn_repo_url="https://svn.sinaapp.com/$svn_repo_name"
svn_dir_name="$svn_repo_name/$1"

#if [.svn] doesn't exist, checkout svn project
if [ ! -e ".svn" ]; then
	echo "initializing: checkout svn project..."
	mkdir .svn
	cd .svn
	svn checkout $svn_repo_url
	cd ..
fi

echo "remove all previous files..."
cd ".svn/$svn_dir_name"
mv config.yaml ../config.yaml
rm -rf *
mv ../config.yaml config.yaml
svn st | awk '{print $2}' | xargs svn delete
svn commit -m "clean"
cd ../../..

echo "copy git repo to SAE-svn..."
mv -f .svn ../.svn
cp -rf * "../.svn/$svn_dir_name"
mv -f ../.svn .svn
echo "copy Done."
cd ".svn/$svn_dir_name"
echo "svn add all..."
#add all files
svn st | awk '{if ( $1 == "?") { print $2 }}' | xargs svn add
echo "svn commit..."
svn commit -m "modify"
echo "If there is no error below, the pushing job has been done."