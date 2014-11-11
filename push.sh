#!/bin/bash

dir_name="SJTU-Bus"
svn_repo_url="https://svn.sinaapp.com/sjtubus"
svn_repo_name="sjtubus"
svn_dir_name="sjtubus/$2"
sae_version=$2
init=$1

if [ $init == false ]
then
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