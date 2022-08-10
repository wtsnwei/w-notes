## 下载离线安装包

1、准备一台能连接互联网的相同OS服务器，使用 `yumdownloader` 工具下载安装包以及所有依赖包。
以 root 身份安装 Yumdownloader 工具：

```bash
yum install yum-utils
```

2、创建离线安装包下载的文件夹

```bash
mkdir /localrepo
```

3、下载 yum 安装软件（例如 ansible）所需的 epel 源（如果没有的话）：

```bash
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```

4、下载 安装包 ansible 和所有依赖包：

```bash
yumdownloader --resolve --destdir /localrepo ansible
```

5、压缩打包

```bash
tar czvf ansible.tar.gz /localrepo   # 打包下载的rpm包
```

6、上传到目标服务器

 
## 配置本地仓库

1、添加本地 yum 源

```bash
bash -c "cat >> /etc/yum.repos.d/local.repo" << EOF
[local-ansible]
name=ansible
baseurl=file:///localrepo
gpgcheck=0
enabled=1
EOF
```

2、生成本地仓库

```bash
rz    # 上传打包的rpm文件到服务器
tar zxvf ansible.tar.gz
mv localrepo/* /localrepo    # 移动rpm文件到已创建的文件夹
yum install createrepo
createrepo /localrepo    # 生成新的yum仓库
yum clean all
yum repolist
yum list|grep ansible    # 查看yum源是否已有ansible安装包
```

 
## 安装

```bash
yum install ansible
```

