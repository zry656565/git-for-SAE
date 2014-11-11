git-for-SAE
===========

本工具的作用只是把git管理的项目内容自动部署到SAE的svn服务器上，仅此而已。

#Features
- 一个脚本搞定将git项目部署到SAE的svn服务器上
- 自动将缓存文件夹`.svn`加入`.gitignore`

#Setup
第一步，将本项目clone到本地并checkout到release分支，这么做的话你在想要更新到最新版本时可以随时获得更新。或者你直接下载[zip](https://github.com/zry656565/git-for-SAE/archive/release.zip)包。假设你将项目放到了如`/Users/Jerry/Dev/git-for-SAE/`这样的路径下。

第二步，将以下内容添加到`~/.bash_profile`下
```
# Git for SAE
export GIT_FOR_SAE_ROOT=/Users/Jerry/Dev/git-for-SAE/
export PATH=$GIT_FOR_SAE_ROOT:$PATH
```

第三步，应用新的`.bash_profile`
```
Terminal$ source ~/.bash_profile
```

#How to use
如果通过上面那种方式安装好后，你可以这样使用
```
#部署，数字表示版本号，SAE支持1-10
Terminal$ sae-push.sh 1

#清空本地svn缓存
Terminal$ sae-clean.sh
```

#Config
```
svn_repo_name=your_repo_name_on_sae
```
如果svn服务器是: `https://svn.sinaapp.com/sjtubus/`
那么上面的参数请填写: `sjtubus`

#Projects
- 成功案例：将交大校园巴士时刻表部署到SAE上
- Github: https://github.com/zry656565/SJTU-Bus
- SAE: http://sjtubus.sinaapp.com/

#Issues
- 暂不支持在svn:ignore中导入.gitignore，即此提交方法暂时无法忽略文件
