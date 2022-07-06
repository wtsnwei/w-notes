# github push过程中的timeout问题

### 一、改用 ssh key

GitHub配置SSH Key的目的是为了帮助我们在通过git提交代码是，不需要繁琐的验证过程，简化操作流程。

步骤

#### 1、设置git的username和email

如果你是第一次使用，或者还没有配置过的话需要操作一下命令，自行替换相应字段。

```bash
git config --global user.name "Luke.Deng"
git config --global user.email  "xiangshuo1992@gmail.com"
```

说明：`git config --list` 查看当前Git环境所有配置，还可以配置一些命令别名之类的。

#### 2、检查是否存在SSH Key

```bash
cd ~/.ssh
ls
# 看是否存在 id_rsa 和 id_rsa.pub文件，如果存在，说明已经有SSH Key
```

如果没有SSH Key，则需要先生成一下

```bash
ssh-keygen -t rsa -C "example@gmail.com"
```

#### 3、获取SSH Key

```bash
cat id_rsa.pub
# 拷贝密钥 ssh-rsa 开头，邮箱结尾
```

#### 4、GitHub添加SSH Key

GitHub点击用户头像，选择setting-->新建一个SSH Key-->复制上门拷贝的密钥。

#### 5、验证和修改

测试是否成功配置SSH Key

```bash
$ ssh -T git@github.com
Hi xiangshuo1992! You've successfully authenticated, but GitHub does not provide shell access.
```

之前已经是https的链接，现在想要用SSH提交怎么办？

直接修改项目目录下 `.git` 文件夹下的config文件，将 url 的地址修改为 ssh 地址就好了。

### 二、配置github hosts

**此内容只适合 timeout 的问题情况！**

不知道为什么今天我的github突然就连不上了，如下：

```bash
[root@archlinux ~]# ping github.com
PING github.com (20.205.243.166) 56(84) bytes of data.
连接超时。
连接超时。
连接超时。
--- github.com ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 3034ms
```

#### 1、优先考虑修改host

- 访问 http://github.global.ssl.fastly.net.ipaddress.com/#ipinfo

- 获取 `记录IP Address ${ip1}`，将该记录添加到 hosts 中

- 访问 http://github.com.ipaddress.com/#ipinfo

- 获取 `记录IP Address ${ip2}`，将该记录添加到 hosts 中

- 刷新 ip
  
    ```bash
    ipconfig /flushdns
    ```

**如果还是连不上**

#### 2、修改 `~/.gitconfig`

* 关闭代理
  
    如果 `[http]` 后有内容的话，删掉 `[http]` 后的内容；

### 三、使用代理

然后打开 Git Bash 然后输入这个命令 

```bash
$ git config --global http.proxy 
```

**如果没有输出，则未设置 Git Bash 中的代理**。使用如下命令设置使用代理，第一段中显示的代理和端口 

```bash
$ git config --global http.proxy proxyaddress:port
```

然后再次输入此命令 

```bash
$ git config --global http.proxy 
```

到这，你已经设置好代理了。 

要在 Git Bash 上重置代理，只需输入此命令 

```bash
 $ git config --global --unset http.proxy 
```
