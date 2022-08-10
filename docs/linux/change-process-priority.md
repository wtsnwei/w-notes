# 修改进程优先级

Linux 给予进程一个所谓的『优先执行序(priority, PRI)』， 这个 PRI 值越低代表越优先的意思。不过这个PRI 值是由核心动态调整的，用户无法直接调整PRI 值的。

如果用户想要调整进程的优先执行序时，就得要透过Nice 值了！Nice 值就是 ps 列出的 NI 啦！

一般来说， PRI 与NI 的相关性如下： $PRI(new) = PRI(old) + nice$

> 注意：
>
> * nice 值可调整的范围为-20 ~ 19 ； 
> * root 可随意调整自己或他人进程的Nice 值，且范围为-20 ~ 19；
> * 一般使用者仅可调整自己进程的Nice 值，且范围仅为0 ~ 19 (避免一般用户抢占系统资源)； 
> * 一般使用者仅可将nice 值越调越高，例如本来nice 为5 ，则未来仅能调整到大于5；



## nice：新执行指令时给予新 nice 值

范例一：用 root 给一个 nice 值为 -5 ，用于执行 vim ，并观察该进程！

```bash
[root@study ~] nice -n -5 vim & 
[1] 19865
```



## renice：已存在进程的 nice 重新调整

范例一：找出自己的 bash PID ，并将该 PID 的 nice 调整到 -5 

```bash
[root@study ~]# ps -l 
F S UID PID PPID C PRI NI ADDR SZ WCHAN TTY TIME CMD 
4 S 0 14836 14835 0 90 10 - 29068 wait pts/0 00:00:00 bash 
0 R 0 19900 14836 0 90 10 - 30319 - pts/0 00:00:00 ps 

[root@study ~]# renice -5 14836 
14836 (process ID) old priority 10, new priority -5
```

