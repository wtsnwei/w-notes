## 一、什么是网络服务

一般来说，会产生一个网络监听端口的程序，就可以称为网络服务了。



## 二、查看网络端口

1. 安装网络工具(如果没有)

    ```bash
    sudo dnf install net-tools
    ```

2. 查看网络端口

    ```bash
    netstat -tunp
    ```

3. 查看对应的服务

    ```bash
    systemctl list-units --all | grep 服务名
    ```

4. 关闭服务

    ```bash
    systemctl stop 服务名
    ```

   