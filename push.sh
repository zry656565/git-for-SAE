#!/bin/bash

dir_name="SJTU-Bus"
svn_repo_url="https://svn.sinaapp.com/sjtubus"
svn_repo_name="sjtubus"
svn_dir_name="sjtubus/2"
sae_version=1
init=true

if [ $init == false ]
then
	mkdir .svn
	cd .svn
	svn checkout $svn_repo_url
	cd ..
fi

echo "copy git repo to SAE-svn"
mv -f .svn ../.svn
#protect config.yaml
#cp -r "../.svn/$svn_dir_name/config.yaml" ../.svn
#rm -rf "../.svn/$svn_dir_name/"
#end
cp -rf * "../.svn/$svn_dir_name"
mv -f ../.svn .svn
echo "copy Done."
cd ".svn/$svn_dir_name"
echo "svn add all"
#add all files
svn st | awk '{if ( $1 == "?") { print $2}}' | xargs svn add
echo "svn commit"
svn commit -m "modify"