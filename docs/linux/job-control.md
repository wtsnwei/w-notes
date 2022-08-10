bash 只能管理自己的工作而不能管理其他 bash 的工作

 <br/>

## 将指令丢到背景中执行：<span style="color:#ea4355">&</span>

范例一：将 /etc/ 备份成为 /tmp/etc.tar.gz

```bash
tar -zpcf /tmp/etc.tar.gz /etc &
```

范例二：将 /etc/ 备份成为 /tmp/etc.tar.gz，并将输出数据传送至某个文件

```bash
tar -zpcvf /tmp/etc.tar.gz /etc >/tmp/log.txt 2&>$1 &
```

 <br/>

## 将「当前」的工作丢到背景中「暂停」：<span style="color:#ea4355">[Ctrl]-z</span>

范例1：当前正在使用vim，需要到bash环境下搜索文件

```bash
[root@study ~]# vim ~/.bashrc
# 在 vim 的一般模式下，按下 [ctrl]-z 这两个按键
[1]+ Stopped vim ~/.bashrc
[root@study ~]# <==顺利取得了前景的操控权！

[root@study ~]# find / -print
....(输出省略)....
# 此时屏幕会非常的忙碌！因为屏幕上会显示所有的文件名。请按下 [ctrl]-z 暂停
[2]+ Stopped find / -print
```

 <br/>

## 观察目前的背景工作状态：<span style="color:#ea4355">jobs</span>

```bash
[root@study ~]# jobs [-lrs]

选项与参数：
-l ：除了列出 job number 与指令串之外，同时列出 PID 的号码；
-r ：仅列出正在背景 run 的工作；
-s ：仅列出正在背景当中暂停 (stop) 的工作。
```

范例1：观察目前的 bash 当中，所有的工作，与对应的 PID 

```bash
[root@study ~]# jobs -l 
[1]- 14566 Stopped vim ~/.bashrc 
[2]+ 14567 Stopped find / -print
```

 <br/>

## 将背景工作拿到前景来处理：<span style="color:#ea4355">fg</span>

范例一：先以 jobs 观察工作，再将工作取出：

```bash
[root@study ~]# jobs -l
[1]- 14566 Stopped vim ~/.bashrc
[2]+ 14567 Stopped find / -print

[root@study ~]# fg <==预设取出那个 + 的工作，亦即 [2]。立即按下[ctrl]-z
[root@study ~]# fg %1 <==直接规定取出的那个工作号码！再按下[ctrl]-z

[root@study ~]# jobs -l
[1]+ 14566 Stopped vim ~/.bashrc
[2]- 14567 Stopped find / -print
```

 <br/>

## 让工作在背景下的状态变为「run」：<span style="color:#ea4355">bg</span>

```bash
fg %number  # number为工作job号
```

 <br/>

## 管理背景中的工作：<span style="color:#ea4355">kill</span>

**选项与参数**：

* `-l` ：这个是 L 的小写，列出目前 kill 能够使用的讯号 (signal) 有哪些？ 
* `signal` ：代表给予后面接的那个工作什么样的指示啰！用 man 7 signal 可知：
  *  -1 ：重新读取一次参数的配置文件 (类似 reload)； 
  * -2 ：代表与由键盘输入 [ctrl]-c 同样的动作； 
  * -9 ：立刻强制删除一个工作； 
  * -15：以正常的进程方式终止一项工作。与 -9 是不一样的。



范例1：找出目前的 bash 环境下的背景工作，并将该工作『强制删除』。

```bash
[root@study ~]# kill -9 %2; jobs
[1]+ Stopped vim ~/.bashrc
[2] Killed find / -print
# 再过几秒你再下达 jobs 一次，就会发现 2 号工作不见了！因为被移除了！
```

范例二：找出目前的 bash 环境下的背景工作，并将该工作『正常终止』掉。

```bash
[root@study ~]# jobs 
[1]+ Stopped vim ~/.bashrc 

[root@study ~]# kill -SIGTERM %1 
# -SIGTERM 与 -15 是一样的！您可以使用 kill -l 来查阅！ 
# 不过在这个案例中， vim 的工作无法被结束喔！因为他无法透过 kill 正常终止的意思！
```

> 注意：kill 后面接的数字默认会是 PID ，如果想要管理 bash 的工作控制，就得要加上 %jobnumber 了， 这点也得特别留意才行喔

 <br/>

## 脱机管理：<span style="color:#ea4355">nohup</span>

```bash
[root@study ~]# nohup [指令与参数] <==在终端机前景中工作
[root@study ~]# nohup [指令与参数] & <==在终端机背景中工作
```



范例：

```bash
# 1. 先编辑一支会『睡着 500 秒』的程序：
[root@study ~]# vim sleep500.sh
#!/bin/bash
/bin/sleep 500s
/bin/echo "I have slept 500 seconds."

# 2. 丢到背景中去执行，并且立刻注销系统：
[root@study ~]# chmod a+x sleep500.sh
[root@study ~]# nohup ./sleep500.sh &
[2] 14812

[root@study ~]# nohup: ignoring input and appending output to `nohup.out' <==会告知这个讯息！
[root@study ~]# exit
```

