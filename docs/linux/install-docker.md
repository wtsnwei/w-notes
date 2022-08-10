## CentOS Docker 安装

#### 卸载旧版本

较旧的 Docker 版本称为 docker 或 docker-engine 。如果已安装这些程序，请卸载它们以及相关的依赖项。

```shell
$ sudo yum remove docker \
         docker-client \
         docker-client-latest \
         docker-common \
         docker-latest \
         docker-latest-logrotate \
         docker-logrotate \
         docker-engine
```




#### 安装 Docker Engine-Community

使用 Docker 仓库进行安装

```shell
$ sudo yum install -y yum-utils \
 device-mapper-persistent-data \
 lvm2
```



使用以下命令来设置稳定的仓库。

```shell
$ sudo yum-config-manager \
  --add-repo \
  https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/docker-ce.repo
```



安装 docker-ce docker-ce-cli containerd.io

```shell
$ sudo yum install docker-ce \
				   docker-ce-cli \
				   containerd.io -y
```



启动 Docker

```shell
$ sudo systemctl start docker
```



通过运行 hello-world 映像来验证是否正确安装了 Docker Engine-Community 。

```shell
$ sudo docker run hello-world
```



#### 镜像加速

```shell
$ sudo vim /etc/docker/daemon.json  # 添加如下内容

{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]
}
```

重启服务

```shell
$ sudo systemctl daemon-reload
$ sudo systemctl restart docker
```

验证

```shell
$ docker info
Registry Mirrors:
    https://docker.mirrors.ustc.edu.cn  # 出现这行说明配置成功
```



#### 要安装特定版本的 Docker Engine-Community

1、列出并排序您存储库中可用的版本。此示例按版本号（从高到低）对结果进行排序。

```shell
$ yum list docker-ce --showduplicates | sort -r

docker-ce.x86_64  3:18.09.1-3.el7           docker-ce-stable
docker-ce.x86_64  3:18.09.0-3.el7           docker-ce-stable
docker-ce.x86_64  18.06.1.ce-3.el7           docker-ce-stable
docker-ce.x86_64  18.06.0.ce-3.el7           docker-ce-stable
```



2、通过其完整的软件包名称安装特定版本。

```shell
$ sudo yum install docker-ce-18.09.1 docker-ce-cli-18.09.1 containerd.io
```



## Dockerfile

```dockerfile
RUN sed -i "s/archive.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list 
RUN sed -i "s/deb.debian.org/mirrors.ustc.edu.cn/g" /etc/apt/sources.list 
RUN sed -i "s/security.debian.org/mirrors.ustc.edu.cn\/debian-security/g" /etc/apt/sources.list
```

