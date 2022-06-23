为了解决内网容器无法直接安装 xtrabackup 的问题，这里构建了一个容器作为类似小的源仓库。

dockerfile 如下：

```dockerfile
FROM docker.io/library/debian:jessie

RUN \
  sed -i s#deb.debian.org#mirrors.163.com#g /etc/apt/sources.list \
  && sed -i s#security.debian.org#mirrors.163.com#g /etc/apt/sources.list \
  && apt update \
  && mkdir -p /var/www/html/xtrabackup \
  && apt-get install -y -d curl wget lsb-release dpkg-dev apache2 \
  && cp -r /var/cache/apt/archives/* /var/www/html/xtrabackup/ \
  && apt-get install -y --no-install-recommends curl wget lsb-release dpkg-dev apache2 \
  && wget http://repo.percona.com/apt/percona-release_latest.jessie_all.deb \
  && dpkg -i percona-release_latest.jessie_all.deb \
  && apt update \
  && apt install -d -y percona-xtrabackup-24 \
  && cp -r /var/cache/apt/archives/* /var/www/html/xtrabackup/ \
  && cd /var/www/html/xtrabackup/ \
  && dpkg-scanpackages -m . > /var/www/html/xtrabackup/Packages

EXPOSE 80

ENTRYPOINT ["apachectl", "-D", "FOREGROUND"]

# apt install -y percona-xtrabackup-24
```

解释，这个 dockerfile 做了下面几件事：

1. 第 4、5、6 行替换软件源为可用的 163 源。
2. 第 7 行创建一个目录，作为 `httpd` 提供外界下载的资源目录。
3. 第 8 行下载一些必要的工具，将所有依赖包都下载下来，在 `/var/cache/apt/archives/` 下。
4. 第 9 行复制依赖包到 httpd 服务的资源目录下。
5. 第10 行安装之前下载的依赖。（**注意**：安装之后，依赖包会被清理掉，所以这里下载和安装分开进行）。
6. 第 11、12、13 行，按照安装 xtrabackup 的步骤下载依赖包，并安装，作用是提供 xtrabackup 的下载源。
7. 第 14、15 行，下载 xtrabackup 及其依赖包，复制到httpd 服务的资源目录下。
8. 第 16、17 行，生成本地仓库所需的 Packages。



构建镜像：

```bash
podman build -t xtrabackup-24:debian .
```



运行：

```bash
podman run -d --net=host xtrabackup-24:debian
```



使用示例：

运行另外一个容器中，例如 debian

```bash
podman run -ti --rm docker.io/library/debian:jessie bash
```

在容器中执行如下操作，即可使用上面构建的仓库源：

```bash
echo 'deb [trusted=yes] http://reposity_ip/xtrabackup/ /' > /etc/apt/sources.list.d/myrepo.list 

mv /etc/apt/sources.list /etc/apt/sources.list.bak 

apt update

apt install -y percona-xtrabackup-24
```

`reposity_ip`：这里的 ip 是 `xtrabackup-24:debian` 这个镜像所在的 host ip