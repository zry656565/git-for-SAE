git-for-SAE
===========

本工具的作用只是把git管理的项目内容自动部署到SAE的svn服务器上，仅此而已。

#Features
- 一个脚本搞定将git项目部署到SAE的svn服务器上
- 自动将缓存文件夹`.svn`加入`.gitignore`

#How to use
```
#部署，数字表示版本号，SAE支持1-10
Terminal$ push.sh 1
#清空本地svn缓存
Terminal$ clean.sh
```

#Config
```
svn_repo_name=your_repo_name_on_sae
```
如果svn服务器是: `https://svn.sinaapp.com/sjtubus/`
那么上面的参数请填写: `sjtubus`


#Issues
- 暂不支持在svn:ignore中导入.gitignore，即此提交方法暂时无法忽略文件
