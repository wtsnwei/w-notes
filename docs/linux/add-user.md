## 一、创建帐号

创建一个用户名为 fish 的账号：

```bash
adduser fish
```

你也可以使用下面的命令删除这个用户账号和它的用户主目录：

```bash
deluser --remove-home fish
```



## 二、sudo 配置

对于典型的单用户工作站，例如运行在笔记本电脑上的桌面 Debian 系统，通常简单地配置 sudo 来使非特权用户（例如用户 penguin）只需输入用户密码而非 root 密码就能获得管理员权限。

```bash
# echo ”penguin  ALL=(ALL) ALL” >> /etc/sudoers
```


另外，可以使用下列命令使非特权用户（例如用户 penguin）**无需密码**就获得管理员权限。

```bash
echo ”penguin  ALL=(ALL) NOPASSWD:ALL” >> /etc/sudoers
```


这些技巧只对你管理的单用户工作站中那个唯一的用户有用。



> **警告**
>
> 在多用户工作站中不要建立这样的普通用户账户，因为它会导致非常严重的系统安全问题。