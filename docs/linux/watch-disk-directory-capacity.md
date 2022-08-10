# 磁盘与目录的容量 

磁盘的整体数据是在 superblock 区块中，但是每个文件的容量则在 inode 当中记载的。那在如何查看这些数据呢？底下就让我们来谈一谈这两个指令：

* df：列出文件系统的整体磁盘使用量；
* du：评估文件系统的磁盘使用量(常用在推估目录所占容量) 


## df 

```bash
[root@study ~]# df [-ahikHTm] [目录或文件名] 选项与参数： 
-a ：列出所有的文件系统，包括系统特有的 /proc 等文件系统； 
-k ：以 KBytes 的容量显示各文件系统； 
-m ：以 MBytes 的容量显示各文件系统； 
-h ：以人们较易阅读的 GBytes, MBytes, KBytes 等格式自行显示； 
-H ：以 M=1000K 取代 M=1024K 的进位方式； 
-T ：连同该 partition 的 filesystem 名称 (例如 xfs) 也列出； 
-i ：不用磁盘容量，而以 inode 的数量来显示 
```

1. **范例一**：将系统内所有的 filesystem 列出来！

    ```bash
    [dog@study ~]$ df
    Filesystem              1K-blocks     Used Available Use% Mounted on
    devtmpfs                   914476        0    914476   0% /dev
    tmpfs                      931520        0    931520   0% /dev/shm
    tmpfs                      931520    10524    920996   2% /run
    tmpfs                      931520        0    931520   0% /sys/fs/cgroup
    /dev/mapper/centos-root  10475520 10465036     10484 100% /
    /dev/sda2                 1038336   242752    795584  24% /boot
    /dev/mapper/centos-home   5232640  1077720   4154920  21% /home
    tmpfs                      186304       16    186288   1% /run/user/1000
    ```

    解释：

    * Filesystem：代表该文件系统是在哪个 partition ，所以列出装置名称；
    * 1k-blocks：说明底下的数字单位是1KB 呦！可利用-h 或-m 来改变容量；
    * Used：顾名思义，就是使用掉的磁盘空间啦！
    * Available：也就是剩下的磁盘空间大小；
    * Use%：就是磁盘的使用率啦！如果使用率高达90% 以上时， 最好需要注意一下了，免得容量不足造成系 统问题喔！(例如最容易被灌爆的 /var/spool/mail 这个放置邮件的磁盘)
    * Mounted on：就是磁盘挂载的目录所在啦！(挂载点啦！)



2. **范例二**：将容量结果以易读的容量格式显示出来

    ```bash
    [dog@study ~]$ df -h
    Filesystem               Size  Used Avail Use% Mounted on
    devtmpfs                 894M     0  894M   0% /dev
    tmpfs                    910M     0  910M   0% /dev/shm
    tmpfs                    910M   11M  900M   2% /run
    tmpfs                    910M     0  910M   0% /sys/fs/cgroup
    /dev/mapper/centos-root   10G   10G  6.0M 100% /
    /dev/sda2               1014M  238M  777M  24% /boot
    /dev/mapper/centos-home  5.0G  1.1G  4.0G  21% /home
    tmpfs                    182M   24K  182M   1% /run/user/1000
    ```

    不同于范例一，这里会以 G/M 等容量格式显示出来，比较容易看！

3. **范例三**：将系统内的所有特殊文件格式及名称都列出来

    ```bash
    df -aT
    ```

4. **范例四**：将 /etc 底下的可用的磁盘容量以易读的容量格式显示

    ```bash
    [dog@study ~]$ df -h /etc
    Filesystem               Size  Used Avail Use% Mounted on
    /dev/mapper/centos-root   10G   10G  6.0M 100% /
    ```

    这个范例比较有趣，在 df 后面加上目录或者是文件时，df 会自动的分析该目录或文件所在的 partition ，并将该 partition 的容量显示出来，所以，您就可以知道某个目录底下还有多少容量可以使用了！ ^_^


5. **范例五**：将目前各个 partition 当中可用的 inode 数量列出

    ```bash
    [dog@study ~]$ df -ih
    Filesystem              Inodes IUsed IFree IUse% Mounted on
    devtmpfs                  224K   372  223K    1% /dev
    tmpfs                     228K     1  228K    1% /dev/shm
    tmpfs                     228K   912  227K    1% /run
    tmpfs                     228K    16  228K    1% /sys/fs/cgroup
    /dev/mapper/centos-root   222K  210K   12K   95% /
    /dev/sda2                 512K   348  512K    1% /boot
    /dev/mapper/centos-home   2.5M   11K  2.5M    1% /home
    tmpfs                     228K    18  228K    1% /run/user/1000
    ```



## du

```bash
[root@study ~]# du [-ahskm] 文件或目录名称
选项与参数:
-a ：列出所有的文件与目录容量，因为默认仅统计目录底下的文件量而已。 
-h ：以人们较易读的容量格式 (G/M) 显示；
-s ：列出总量而已，而不列出每个各别的目录占用容量；
-S ：不包括子目录下的总计，与 -s 有点差别。
-k ：以 KBytes 列出容量显示；
-m ：以 MBytes 列出容量显示；
```



1. **范例一**：列出当前目录下的所有文件容量

    ```bash
    du
    ```

2. **范例二**：同范例一，但是将文件的容量也列出来

    ```bash
    du -a
    ```

3. **范例三**：检查根目录底下每个目录所占用的容量

    ```bash
    [dog@study ~]$ sudo du -sm /*
    0		/bin
    205		/boot
    0		/dev
    59		/etc
    1020	/home
    0		/lib
    0		/lib64
    0		/media
    0		/mnt
    654		/opt
    0		/proc
    51		/root
    11		/run
    0		/sbin
    0		/srv
    0		/sys
    1		/tmp
    5248	/usr
    4076	/var
    ```

    du 这个指令会直接到文件系统内去搜寻所有的文件数据！此外，在默认的情况下，容量的输出是以 KB 来设计的， 如果你想要知道目录占了多少MB ，那么就使用 `-m` 这个参数！而如果你只想要知道该目录占了多少容量的话，使用 `-s` 就可以啦！

