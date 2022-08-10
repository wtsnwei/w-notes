## 一、free：观察内存情况

范例：显示目前系统的内存容量

```bash
[root@study ~]# free -m
              total        used        free      shared  buff/cache   available
Mem:           1819        1018         222          29         578         619
Swap:          1023           6        1017
```


## 二、uanme：查阅系统与核心相关信息

范例一：输出系统的基本信息

```
[root@study ~]# uname -a 
Linux study.centos.vbird 3.10.0-229.el7.x86_64 #1 SMP Fri Mar 6 11:36:42 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
```


## 三、uptime：观察系统启动时间与工作负载

这个指令就是显示出目前系统已经开机多久的时间，以及1, 5, 15 分钟的平均负载。

```bash
[root@study ~]# uptime
02:35:27 up 7:48, 3 users, load average: 0.00, 0.01, 0.05
```


## 四、netstat：追踪网络或插槽文件

netstat 的输出分为两大部分，分别是网络与系统自己的进程相关性部分。

```bash
[root@study ~]# netstat -[atunlp] 
选项与参数： 
-a ：将目前系统上所有的联机、监听、Socket 数据都列出来 
-t ：列出 tcp 网络封包的数据 
-u ：列出 udp 网络封包的数据 
-n ：不以进程的服务名称，以埠号 (port number) 来显示； 
-l ：列出目前正在网络监听 (listen) 的服务； 
-p ：列出该网络服务的进程 PID
```

范例：找出目前系统上已在监听的网络联机及其 PID 

```bash
[root@study ~]# netstat -tulnp 
Active Internet connections (only servers)
……
```


## 五、分析核心产生的信息

范例一：输出所有的核心开机时的信息 

```bash
[root@study ~]# dmesg | more
```

范例二：搜寻开机的时候，硬盘的相关信息为何？ 

```bash
[root@study ~]# dmesg | grep -i vda
[ 0.758551] vda: vda1 vda2 vda3 vda4 vda5 vda6 vda7 vda8 vda9 
[ 3.964134] XFS (vda2): Mounting V4 Filesystem 
....(底下省略)....
```


## 六、检测系统资源变化

范例一：统计目前主机 CPU 状态，每秒一次，共计三次！ 

```bash
[root@study ~]# vmstat 1 3
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 1  0   6144 220596      0 599188    0    0    54    13   41   64  0  0 100  0  0
 0  0   6144 220728      0 599220    0    0     0     0  248  397  0  0 100  0  0
 0  0   6144 220728      0 599220    0    0     0     0  217  396  1  0 100  0  0
```

范例二：系统上面所有的磁盘的读写状态 

```bash
[root@study ~]# vmstat -d
disk- ------------reads------------ ------------writes----------- -----IO------
       total merged sectors      ms  total merged sectors      ms    cur    sec
sda    25393     84 2403437    7789   4827   2174  594702    2725      0      4
sr0        0      0       0       0      0      0       0       0      0      0
dm-0   22235      0 2304613    7412   5178      0  568190    2836      0      4
dm-1     140      0    4824      22   1445      0   11560    7173      0      0
dm-2    2516      0   30864     240    362      0   10775     212      0      0
```

