#### 1、查看系统当前语言包

```shell
[root@centos ~]# locale
```

<br/>

#### 2. 查看系统拥有的语言包

```shell
[root@centos ~]# locale -a
```



> 如果没有`zh_CN.utf8`，则需要单独安装中文语言包
>
> ```bash
> yum install kde-l10n-Chinese
> ```

<br/>

#### 3. 设置为中文(临时修改,服务器重启之后会还原之前的设置)

```shell
// 设置为中文
[root@centos ~]# LANG="zh_CN.UTF-8"
// 设置为英文
[root@centos ~]# LANG="en_US.UTF-8"
```

<br/>

#### 4. 设置为中文(永久有效)

##### 3.1 方式一

```shell
[root@centos ~]# localectl  set-locale LANG=zh_CN.UTF8
```



##### 3.2 方式二

```shell
[root@centos ~]# vi /etc/locale.conf
```

修改为以下内容

```bash
LANG=en_US.UTF8  # 主语言的环境
LC_NUMERIC="en_US"  # 数字系统的显示讯息
LC_TIME="en_US"  # 时间系统的显示数据
LC_MONETARY="en_US"  # 币值格式的显示等
```

 <br/> 

**常用参数含义**

```shell
[dmtsai@study ~]$ locale <==后面不加任何选项与参数即可！
LANG=en_US <==主语言的环境
LC_CTYPE="en_US" <==字符(文字)辨识的编码
LC_NUMERIC="en_US" <==数字系统的显示讯息
LC_TIME="en_US" <==时间系统的显示数据
LC_COLLATE="en_US" <==字符串的比较与排序等
LC_MONETARY="en_US" <==币值格式的显示等
LC_MESSAGES="en_US" <==讯息显示的内容，如菜单、错误讯息等
LC_ALL= <==整体语系的环境
....(后面省略)....


LC_PAPER="zh_CN.UTF-8"
LC_NAME="zh_CN.UTF-8"
LC_ADDRESS="zh_CN.UTF-8"
LC_TELEPHONE="zh_CN.UTF-8"
LC_MEASUREMENT="zh_CN.UTF-8"
LC_IDENTIFICATION="zh_CN.UTF-8"
LC_ALL=
```

