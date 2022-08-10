安装Cmder过程的issue

出现一下提示信息：

```
cmder waring conEmu binaries were marked as 'Downloaded from internet'
```

![img](/img/14371593-c2dcea573e581598.png)

解决方法如下。



#### 一、找到以下文件：

1、目录 cmder\vendor\conemu-maximus5 下：

![img](/img/14371593-4938c4a835faca84.png)

2、目录 cmder\vendor\conemu-maximus5\ConEmu 下：

![img](/img/14371593-937688e3779888eb.png)



#### 二、找到以上文件右键属性，检查是否有解除锁定选项，有的话，把勾打上，点击应用，重启即可。

![img](/img/14371593-081f5c8c4bad14cf.png)



参考：https://conemu.github.io/en/ZoneId.html

