#### 第一步：获取离线包

添加仓库

```bash
cat > /etc/copr-be.repo << EOF
[copr-be]
name=copr
baseurl=https://copr-be.cloud.fedoraproject.org/results/kwizart/kernel-longterm-4.19/epel-7-x86_64/
enabled=1
gpgcheck=0
EOF
```

> 这里选择的是 copr 的 yum 源仓库，也可以选择其他包含你所需包的仓库



下载内核包：

```bash
yum install --enablerepo=copr-be --downloadonly --downloaddir=/root/kernel-4.19 kernel-longterm
```

> 内核版本介绍：
>
> lt: longterm的缩写：长期维护版
> ml: mainline的缩写：最新稳定版



#### 第二步：更新内核

手动安装内核包：

```bash
rpm -Uvh kernel-longterm-core-4.19.207-300.el7.x86_64.rpm
rpm -Uvh kernel-longterm-modules-4.19.207-300.el7.x86_64.rpm
rpm -Uvh kernel-longterm-4.19.207-300.el7.x86_64.rpm
```

检查内核版本：

```bash
awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
```

这里会看到输出的有两种版本的内核



#### 第三步：设置 GRUB 默认的内核版本

1. 将 `/etc/default/grub` 中的  `GRUB_DEFAULT` 设置为 0。

2. 更新内核配置

    ```bash
    grub2-mkconfig -o /boot/grub2/grub.cfg
    ```

#### 第四步：重启

```bash
reboot
```

