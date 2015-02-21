#!/bin/bash

svn_repo_name=$1
sae_version=$(echo $2|bc 2>/dev/null)
log() {
	echo "[push.sh]: $1"
}
print_usage() {
	echo "[usage]: sae-push.sh [repo_name] [SAE-version(1-10)]"
	echo "[example]: sae-push.sh sjtubus 2"
}

if [ ! $sae_version ]; then
	print_usage
	exit
fi
if [ ! $svn_repo_name ]; then
	print_usage
	exit
fi
if [ $sae_version -lt 1 -o $sae_version -gt 10 ] ; then
	print_usage
	exit
fi

svn_repo_url="https://svn.sinaapp.com/$svn_repo_name"
log "url> $svn_repo_url"
svn_dir_name="$svn_repo_name/$sae_version"

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
fi

log "check local repo whether it is the latest..."
cd ".svn/$svn_repo_name"
svn update

log "remove all previous files..."
if [ ! -e "$sae_version" ]; then
	log "Oh! It seems that you haven't create version $sae_version on SAE!"
	log "Abort!"
	exit 1
fi
cd "$sae_version"
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
#log "apply gitignore..."
#svn propset svn:ignore `cat ../../../.gitignore | awk '{if ($1 != ".svn" && $1 != ".svn/*") print $1}'` .
#add all files
log "svn add all..."
svn st | awk '{if ( $1 == "?") { print $2 }}' | xargs svn add
log "svn commit..."
svn commit -m "modify"
log "If there is no error below, the pushing job has been done."