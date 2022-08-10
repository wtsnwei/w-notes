stat 中的参数意义如下：

* D 不可中断 Uninterruptible（usually IO）
* R 正在运行，或在队列中的进程
* S 处于休眠状态
* T 停止或被追踪
* Z 僵尸进程
* W 进入内存交换（从内核2.6开始无效）
* X 死掉的进程

<br/>

# 观察进程状态

## ps

作用：观察某个时间点的进程状态

* 仅观察当前 bash 的相关进程：

    ```bash
    ps -l
    ```
    
* 观察所有进程

    ```bash
    ps aux
    ```

<br/>

范例1：根据 **CPU使用**来降序排序

```shell
$ ps -aux --sort='-pcpu' | less
```

范例2：根据 **内存使用** 降升序排序

```shell
$ ps -aux --sort='-pmem' | less
```

范例3：合并到一个命令，并通过管道显示前10个结果：

```bash
$ ps -aux --sort='-pcpu,-pmem' | head -n 10
```

<br/>

## top

作用：动态观察进程状态

>top 预设使用CPU 使用率(%CPU) 作为排序的依据，如果你想要使用内存使用率排序，则可以按下<span style="color:#ea4355">『M』</span>， 若要回复则按下<span style="color:#ea4355">『P』</span>即可。



范例一：每两秒钟更新一次 top ，观察整体信息： 

```bash
[root@study ~]# top -d 2
```

范例二：将 top 的信息进行 2 次，然后将结果输出到 /tmp/top.txt 

```bash
[root@study ~]# top -b -n 2 > /tmp/top.txt 
# 这样一来，嘿嘿！就可以将 top 的信息存到 /tmp/top.txt 文件中了。
```

范例三：我们自己的 bash PID 可由 $$ 变量取得，请使用 top 持续观察该 PID

```bash
[root@study ~]# echo $$ 
14836 <==就是这个数字！他是我们 bash 的 PID 

[root@study ~]# top -d 2 -p 14836
```

<br/>

## pstree

作用：列出进程树

范例一：列出目前系统上面所有的进程树的相关性： 

```bash
[root@study ~]# pstree -A
```

> -A：各进程树之间的连接以 ASCII 字符来连接。为了防止乱码问题，因此加上 -A 选项

范例二：承上题，同时秀出 PID 与 users

```bash
[root@study ~]# pstree -Aup
```

