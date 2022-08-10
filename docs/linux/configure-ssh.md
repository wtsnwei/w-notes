## 配置用户远程密码登录

1. 创建用户

    ```bash
    $ adduser wtsn
    $ passwd wtsn
    ```

2. 赋予权限

    ```bash
    $ visudo
    ```

    找到 `root ALL ALL` 那一行，在下面添加一行 `wtsn ALL ALL`

3. 修改ssh配置文件

    ```bash
    $ vi /etc/ssh/sshd_config
    ```

    找到 PasswordAuthentication，修改为 yes ；如果想要使用 root 登录，在需要将 PermitRootLogin 修改为 yes。

    然后重启ssh服务：

    ```bash
    $ systemctl restart sshd
    ```


## 配置用户远程密钥登录

1. 新建密钥对

    ```bash
    $ ssh-keygen -t rsa -f ~/.ssh/google_cloud -C wtsn
    ```

2. 在远程主机上添加公钥

3. 连接远程主机

    ```bash
    $ ssh -i C:\Users\whs\.ssh\google_cloud wtsn@35.203.57.155
    ```

   
## 修改ras信息

```bash
vi ~/.ssh/known_hosts
```

删除对应ip的相关rsa信息

优点：其他正确的公钥信息保留

缺点：还要 vi，还要找到对应信息，稍微有点繁琐

