## 离线安装 Docker 和 compose

### 一、下载离线安装包

去官网下载 docker 安装二进制包，选择适合自己的版本。这里下载的是 `docker-19.03.9.tgz`，在centos7中安装。

下载地址：[https://download.docker.com/linux/static/stable/x86_64/](https://download.docker.com/linux/static/stable/x86_64/)



### 二、将 docker 离线包解压并移动到 `/usr/bin` 下

复制 docker-19.03.9.tgz 到服务器上，解压：

```bash
tar xzvf docker-19.03.9.tgz
cp docker/* /usr/bin/
```



### 三、添加docker配置文件

```bash
cat > /etc/systemd/system/docker.service <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target
[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStart=/usr/bin/dockerd
ExecReload=/bin/kill -s HUP $MAINPID
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
# restart the docker process if it exits prematurely
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s
[Install]
WantedBy=multi-user.target
EOF
```

### 四、启动docker

```bash
chmod +x /etc/systemd/system/docker.service	 # 增加权限
systemctl daemon-reload                      # 重新加载配置文件
systemctl start docker
systemctl enable docker.service
docker ps                                    # 验证docker是否正常启动
```

### 五、设置 http 代理

修改配置：`/etc/systemd/system/docker.service`，在 `[service]` 下面加入代理的配置，比如：

```bash
Environment=HTTP_PROXY=http://127.0.0.1:10809
Environment=HTTPS_PROXY=http://127.0.0.1:10809
Environment=NO_PROXY=localhost,127.0.0.1
```

重启

```bash
systemctl daemon-reload
systemctl restart docker
```



## 离线安装 docker compose

### 一、下载安装包

运行以下命令以下载 Docker Compose 的当前稳定版本：

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

要安装其他版本的 Compose，请替换 `v2.2.2`。

### 二、添加执行权限

将可执行权限应用于二进制文件：

```bash
sudo chmod +x /usr/local/bin/docker-compose
```

创建软链：

```bash
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

测试是否安装成功：

```bash
docker-compose --version
```