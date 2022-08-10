## 查看开放端口

```shell
firewall-cmd --list-ports 
```

## 查看端口是否开放

```shell
firewall-cmd --query-port=80/tcp
```

## 开放端口

```shell
sudo firewall-cmd --zone=public --add-port=1099/tcp --permanent   # 开放1099端口
```

## 关闭端口

```shell
sudo firewall-cmd --zone=public --remove-port=1099/tcp --permanent  #关闭1099端口
```

## 重启防火墙

```shell
sudo firewall-cmd --reload  # 配置立即生效
```

## 关闭防火墙

```shell
sudo systemctl stop firewalld  # 关闭防火墙服务
sudo systemctl start firewalld  # 启动服务
```



## firewalld 的基本使用

启动：`systemctl start firewalld`

关闭： `systemctl stop firewalld`

查看状态： `systemctl status firewalld`

开机禁用 ： `systemctl disable firewalld`

开机启用 ： `systemctl enable firewalld`

