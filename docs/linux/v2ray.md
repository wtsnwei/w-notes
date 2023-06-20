## Linux使用v2ray

v2ray本身是不区分服务端和客户端的，只要配置好相关文件，反正都可正常使用。（就是配置文件的区别）

### 1. 下载 v2ray-linux-64.zip

v2ray的Github地址：[v2ray](https://github.com/v2ray/v2ray-core/releases/)


在页面中找到 v2ray-linux-64.zip 文件下载。

下载后解压出来是一个 v2ray-linux-64 目录，用工具上传到 linux 的服务器上。

当然，也可以直接把解压包上传后，再用 `unzip` 命令解压。

### 2. 赋予文件可执行权限

首先，进入 v2ray-linux-64 目录，可以用 `ls -l` 查看目录下的文件。

目录中的几个文件需要修改下权限，需要添加下可执行的权限。

```bash
cd v2ray-linux-64

chmod 755 v2ray
chmod 755 v2ctl
chmod 755 systemd/system/v2ray.service
chmod 755 systemd/system/v2ray@.service
```

### 3. config.json配置文件

原生的V2ray并不支持订阅，反正我本来就在windows下用的，直接在v2rayN的客户端，服务器列表中`右键` -> `导出所选服务器为客户端配置`，保存成 config.json 文件。

然后把这个config.json文件也上传到 v2ray-linux-64 目录中，再来复制。

### 4. 启动v2ray

启动脚本
```bash
/root/v2ray-linux-64/v2ray –config=config.json
```

### 5. 检验代码是否生效

```bash
curl -x socks5://127.0.0.1:10808 https://www.google.com -v
```