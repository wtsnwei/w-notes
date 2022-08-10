# 进程管理

进程是如何互相管理的呢？其实是透过给予该进程一个讯号（signal）去告知该进程你想要让她作什么。


## kill

主要的讯号与名词及内容如下(更多内容：`kill -l` 查看)：

| 代号 | 名称    | 内容                                                         |
| ---- | ------- | ------------------------------------------------------------ |
| 1    | SIGHUP  | 启动被终止的进程，可让该 PID 重新读取自己的配置文件，类似重新启动 |
| 9    | SIGKILL | 代表强制中断一个进程的进行，如果该进程进行到一半， 那么尚未完成的部分可能会有『半产品』产生，类似 vim 会有 .filename.swp 保留下来 |
| 15   | SIGTERM | 以正常的结束进程来终止该进程。由于是正常的终止， 所以后续的动作会将他完成。不过，如果该进程已经发生问题，就是无法使用正常的方法终止时，输入这个 signal 也是没有用的 |

**示例**

以 ps 找出 rsyslogd 这个进程的 PID 后，再使用 kill 传送讯息，使得 rsyslogd 可以重新读取配置文件。

```bash
# 由于需要重新读取配置文件，因此 signal 是 1 号。至于找出 rsyslogd 的 PID 可以是这样做：
ps aux | grep 'rsyslogd' | grep -v 'grep'| awk '{print $2}'

# 接下来则是实际使用 kill -1 PID，因此，整串指令会是这样：
kill -SIGHUP $(ps aux | grep 'rsyslogd' | grep -v 'grep'| awk '{print $2}')

# 如果要确认有没有重新启动 syslog ，可以参考登录档的内容，使用如下指令查阅：
tail -5 /var/log/messages
```


## killall

kill 后面必须加上 pid，而 killall 后面接"进程名称"。

> 选项与参数：
>
> -i：交互的
>
> -I：进程名忽略大小写



范例一：给予 rsyslogd 这个指令启动的 PID 一个 SIGHUP 的讯号。

```bash
[root@study ~]# killall -1 rsyslogd
# 如果用 ps aux 仔细看一下，若包含所有参数，则 /usr/sbin/rsyslogd -n 才是最完整的！
```

范例二：强制终止所有以 httpd 启动的进程 (其实并没有此进程在系统内)

```bash
[root@study ~]# killall -9 httpd 
```

范例三：依次询问每个 bash 程序是否需要被终止运作！ 

```bash
[root@study ~]# killall -i -9 bash
Signal bash(13888) ? (y/N) n <==这个不杀！
Signal bash(13928) ? (y/N) n <==这个不杀！ 
Signal bash(13970) ? (y/N) n <==这个不杀！ 
Signal bash(14836) ? (y/N) y <==这个杀掉！
```


## 小结

1、要删除某个进程，可以使用 PID 或者是进程名称

2、要删除某个服务，可以使用 killall，因为他可以将系统当中所有**以某个指令名称启动的进程**全部删除。