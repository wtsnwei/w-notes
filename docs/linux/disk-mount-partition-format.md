# 磁盘的分区、格式化、检验与挂载

如果我们想要在系统里面新增一颗磁盘时，应该有哪些动作需要做的呢： 

1. 对磁盘进行分区，以建立可用的 partition；
2. 对该 partition 进行格式化(format)，以建立系统可用的 filesystem；
3. 若想要仔细一点，则可对刚刚建立好的 filesystem 进行检验；
4. 在Linux 系统上，需要建立挂载点(亦即是目录)，并将他挂载上来；

<br/>

## 观察磁盘分区状态

<br/>

#### 一、`lsblk` 列出系统上的所有磁盘列表

lsblk 可以看成『list block device 』的缩写，就是列出所有储存装置的意思！

```bash
[root@study ~]# lsblk [-dfimpt] [device]
选项与参数：
-d ：仅列出磁盘本身，并不会列出该磁盘的分区数据
-f ：同时列出该磁盘内的文件系统名称
-i ：使用 ASCII 的线段输出，不要使用复杂的编码 (再某些环境下很有用)
-m ：同时输出该装置在 /dev 底下的权限数据 (rwx 的数据)
-p ：列出该装置的完整文件名！而不是仅列出最后的名字而已。
-t ：列出该磁盘装置的详细数据，包括磁盘队列机制、预读写的数据量大小等范例
```

1. **范例一**：列出本系统下的所有磁盘与磁盘内的分区信息

    ```bash
    [dog@study ~]$ lsblk
    NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    sda               8:0    0   40G  0 disk 
    ├─sda1            8:1    0    2M  0 part 
    ├─sda2            8:2    0    1G  0 part /boot
    └─sda3            8:3    0   30G  0 part 
      ├─centos-root 253:0    0   10G  0 lvm  /
      ├─centos-swap 253:1    0    1G  0 lvm  [SWAP]
      └─centos-home 253:2    0    5G  0 lvm  /home
    sr0              11:0    1 1024M  0 rom
    ```

    默认输出的信息如下。

    * NAME：就是装置的文件名啰！会省略 /dev 等前导目录！
    * MAJ:MIN：其实核心认识的装置都是透过这两个代码来熟悉的！分别是主要：次要装置代码！
    * RM：是否为可卸除装置(removable device)，如光盘、USB 磁盘等等
    * SIZE：当然就是容量啰！
    * RO：是否为只读装置的意思
    * TYPE：是磁盘(disk)、分区槽(partition) 还是只读存储器(rom) 等输出
    * MOUTPOINT：就是挂载点！

    <br/>

2. **范例二**：仅列出 /dev/sda 装置内的所有数据的完整文件名

    ```bash
    [dog@study ~]$ lsblk -ip /dev/sda
    NAME                        MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
    /dev/sda                      8:0    0  40G  0 disk 
    |-/dev/sda1                   8:1    0   2M  0 part 
    |-/dev/sda2                   8:2    0   1G  0 part /boot
    `-/dev/sda3                   8:3    0  30G  0 part 
      |-/dev/mapper/centos-root 253:0    0  10G  0 lvm  /
      |-/dev/mapper/centos-swap 253:1    0   1G  0 lvm  [SWAP]
      `-/dev/mapper/centos-home 253:2    0   5G  0 lvm  /home
    ```

   <br/>

#### 二、`blkid` 列出装置的 UUID 等参数

UUID 是全局单一标识符(universally unique identifier)，Linux 会将系统内所有的装置都给予一个独一无二的标识符， <span style="color:#ea4355">这个标识符就可以拿来作为挂载或者是使用这个装置/文件系统之用了</span>。

```bash
[dog@study ~]$ sudo blkid
/dev/sda1: PARTUUID="e3eee1fa-ba34-4ba0-8102-d6acae8c9637" 
/dev/sda2: UUID="88fbed26-3766-4501-b295-20333fb7b4f6" TYPE="xfs" PARTUUID="2e1115ce-0c37-4f35-a225-cc97915cdb28" 
/dev/sda3: UUID="QLBjf7-Wh9t-v4C4-dGKy-u2e7-WOqd-2Kdxjk" TYPE="LVM2_member" PARTUUID="c9321285-160e-4189-87d3-b448df54d4ee" 
/dev/mapper/centos-root: UUID="28189c22-0949-4355-ad4e-5f241a6b32c8" TYPE="xfs" 
/dev/mapper/centos-swap: UUID="2e8ecee5-e565-4c85-9d5a-63ccfb77a7e4" TYPE="swap" 
/dev/mapper/centos-home: UUID="245dce76-d561-4a6c-8225-44eae083b604" TYPE="xfs"
```

<br/>

#### 三、`parted` 列出磁盘的分区表类型与分区信息

虽然我们已经知道了系统上面的所有装置，并且通过 `blkid` 也知道了所有的文件系统！不过，还是不清楚磁盘的分区类型。这时我们可以透过简单的 parted 来输出喔！

```bash
[root@study ~]# parted device_name print
```

1. **范例一**：列出 /dev/sda 磁盘相关的数据

    ```bash
    [dog@study ~]$ sudo parted /dev/sda print
    Model: VMware, VMware Virtual S (scsi)
    Disk /dev/sda: 42.9GB
    Sector size (logical/physical): 512B/512B
    Partition Table: gpt
    Disk Flags: pmbr_boot
    
    Number  Start   End     Size    File system  Name  Flags
     1      1049kB  3146kB  2097kB                     bios_grub
     2      3146kB  1077MB  1074MB  xfs
     3      1077MB  33.3GB  32.2GB                     lvm
    ```

   <br/>



## 磁盘分区

注意：<span style="color:#ea4355">『MBR 分区表请使用fdisk 分区， GPT 分区表请 使用gdisk 分区！』</span>

<br/>

### 一、`gdisk`

```bash
[root@study ~]# gdisk 装置名称

范例：由前一小节的 lsblk 输出，我们知道系统有个 /dev/vda，请观察该磁盘的分区与相关数据
[dog@study ~]$ sudo gdisk /dev/sda	<==仔细看，不要加上数字喔！
GPT fdisk (gdisk) version 0.8.10

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.	<==找到了 GPT 的分区表！

Command (? for help): ?	<==这里可以让你输入指令动作，可以按问号 (?) 来查看可用指令
b	back up GPT data to a file
c	change a partition's name
d	delete a partition	<==删除一个分区
i	show detailed information on a partition
l	list known partition types
n	add a new partition	<==增加一个分区
o	create a new empty GUID partition table (GPT)
p	print the partition table	<==打印出分区表 (常用)
q	quit without saving changes	<==不储存分区就直接离开 gdisk
r	recovery and transformation options (experts only)
s	sort partitions
t	change a partition's type code
v	verify disk
w	write table to disk and exit	<==储存分区操作后离开 gdisk
x	extra functionality (experts only)
?	print this menu

Command (? for help): 
```



##### 用 `gdisk` 新增分区槽

假设我需要有如下的分区需求：

* 1GB 的xfs 文件系统(Linux)
* 1GB 的vfat 文件系统(Windows)
* 0.5GB 的swap (Linux swap)(这个分区等一下会被删除喔！)

```bash
[dog@study ~]$ sudo gdisk /dev/sda
Command (? for help): p
Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048            6143   2.0 MiB     EF02  
   2            6144         2103295   1024.0 MiB  0700  
   3         2103296        65026047   30.0 GiB    8E00  
# 找到最后一个 sector 的号码很重要

Command (? for help): n
Partition number (4-128, default 4): 4
First sector (34-83886046, default = 65026048) or {+-}size{KMGTP}: 65026048 #可以使用默认值
# 输入+1G,分区容量(默认为剩余全部)
Last sector (65026048-83886046, default = 83886046) or {+-}size{KMGTP}: +1G
Hex code or GUID (L to show codes, Enter = 8300): #默认值即可
# 这里在让你选择未来这个分区槽预计使用的文件系统！预设都是 Linux 文件系统的 8300 啰！

Command (? for help): p
Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048            6143   2.0 MiB     EF02  
   2            6144         2103295   1024.0 MiB  0700  
   3         2103296        65026047   30.0 GiB    8E00  
   4        65026048        67123199   1024.0 MiB  8300  Linux filesystem	<==新增分区

Command (? for help): W	<==保存
```

**注意**：保存之后不会立即生效，因为分区表并没有被更新喔！

这个时候我们有两个方式可以来处理！ 其中一个是重新启动，不过很讨厌！另外一个则是透过 partprobe 这 个指令来处理即可！

<br/>

##### `partprobe` 更新Linux 核心的分区表信息 

```bash
[root@study ~]# partprobe [-s]	# 你可以不要加 -s ！那么屏幕不会出现讯息！ 

[dog@study ~]$ sudo partprobe -s # 不过还是建议加上 -s 比较清晰！
[sudo] password for dog: 
/dev/sda: gpt partitions 1 2 3 4 5 6
```

<br/>

##### 用 `gdisk` 删除一个分区槽

```bash
[dog@study ~]$ sudo gdisk /dev/sda
Command (? for help): d
Partition number (1-6): 6

[dog@study ~]$ sudo partprobe -s
/dev/sda: gpt partitions 1 2 3 4 5
```

<br/>

### 二、`fdisk`

作为指令提示数据，一个使用 `m` 作为提示这样而已。此外，fdisk 有时会使用磁柱(cylinder) 作为分区的最小单位，与 gdisk 默认使用 sector 不太一样！大致上只是这点差别！另外，MBR 分区是有限制的(Primary, Extended, Logical...)！

<br/>

## 磁盘格式化

### 一、XFS 文件系统 mkfs.xfs

1. **范例一**：将分区出来的 /dev/sda4 格式化为 xfs 文件系统

    ```bash
    [dog@study ~]$ sudo mkfs.xfs /dev/sda4
    meta-data=/dev/sda4              isize=512    agcount=4, agsize=65536 blks
             =                       sectsz=512   attr=2, projid32bit=1
             =                       crc=1        finobt=0, sparse=0
    data     =                       bsize=4096   blocks=262144, imaxpct=25
             =                       sunit=0      swidth=0 blks
    naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
    log      =internal log           bsize=4096   blocks=2560, version=2
             =                       sectsz=512   sunit=0 blks, lazy-count=1
    realtime =none                   extsz=4096   blocks=0, rtextents=0
    
    [dog@study ~]$ sudo blkid /dev/sda4  # 确认一下
    /dev/sda4: UUID="6a4a9ae6-b303-4ad2-a42e-0216a479d15c" TYPE="xfs" PARTLABEL="Linux filesystem" PARTUUID="b39b2398-4645-49bb-b220-84771da7bfd9"
    ```

2. **范例二**：找出你系统的 CPU 数，并据以设定你的 agcount 数值

    因为 xfs 可以使用多个数据流来读写系统，以增加速度，因此那个 agcount 可以跟CPU 的核心数来做搭配！

    ```bash
    [dog@study ~]$ grep 'processor' /proc/cpuinfo
    processor	: 0
    processor	: 1
    processor	: 2
    processor	: 3
    # 有四颗CPU
    
    [dog@study ~]$ sudo mkfs.xfs -f -d agcount=4 /dev/sda4
    ```

   <br/>

### 二、EXT4 文件系统 mkfs.ext4

1. **范例一**：将分区出来的 /dev/sda5 格式化为 EXT4 文件系统

    ```bash
    [dog@study ~]$ sudo mkfs.ext4 /dev/sda5
    mke2fs 1.42.9 (28-Dec-2013)
    Filesystem label=
    OS type: Linux
    Block size=4096 (log=2)                                # 每一个 block 的大小
    Fragment size=4096 (log=2)
    Stride=0 blocks, Stripe width=0 blocks
    65536 inodes, 262144 blocks                            # 总计 inde/block 的数量
    13107 blocks (5.00%) reserved for the super user
    First data block=0
    Maximum filesystem blocks=268435456
    8 block groups                                         # 共有8个 block group 组
    32768 blocks per group, 32768 fragments per group
    8192 inodes per group
    Superblock backups stored on blocks: 
    	32768, 98304, 163840, 229376
    
    Allocating group tables: done                            
    Writing inode tables: done                            
    Creating journal (8192 blocks): done
    Writing superblocks and filesystem accounting information: done
    ```

   <br/>

## 文件系统挂载与卸载

进行挂载前，你最好先确定几件事：

* 单一文件系统不应该被重复挂载在不同的挂载点(目录)中；
* 单一目录不应该重复挂载多个文件系统；
* 要作为挂载点的目录，理论上应该都是空目录才是。

<br/>

#### 一、挂载 xfs 等文件系统

1. **范例**：找出 /dev/vda4 的 UUID 后，用该 UUID 来挂载文件系统到 /data/xfs 内

    ```bash
    [dog@study ~]$ sudo blkid /dev/sda4
    /dev/sda4: UUID="ed9e4df4-0ab5-46dd-a7a6-a6a3b6f696c1" TYPE="xfs" PARTLABEL="Linux filesystem" PARTUUID="b39b2398-4645-49bb-b220-84771da7bfd9" 
    
    [dog@study ~]$ sudo mkdir -p /data/xfs
    
    [dog@study ~]$ sudo mount UUID="ed9e4df4-0ab5-46dd-a7a6-a6a3b6f696c1" /data/xfs
    
    [dog@study ~]$ df /data/xfs
    Filesystem     1K-blocks  Used Available Use% Mounted on
    /dev/sda4        1038336 32992   1005344   4% /data/xfs
    ```

2. 范例：使用相同的方式，将 /dev/vda5 挂载于 /data/ext4

    ```bash
    [dog@study ~]$ sudo blkid /dev/sda5
    [dog@study ~]$ sudo mkdir -p /data/ext4
    [dog@study ~]$ sudo mount UUID="4a4e09e1-a6b5-4a39-800b-a4d111ab8691" /data/ext4
    [dog@study ~]$ df /data/ext4
    ```

   <br/>

#### 二、挂载 CD 或 DVD 光盘

1. **范例**：将你用来安装 Linux 的 CentOS 原版光盘拿出来挂载到 /data/cdrom！

    ```bash
    sudo blkid
    sudo mkdir /data/cdrom
    sudo mount /dev/sr0 /data/cdrom
    df /data/cdrom
    ```

<br/>

#### 三、挂载 vfat U盘

**注意**：该 U 盘不能是 NTFS 格式

1. **范例一**：找出你的 U 盘装置的 UUID，并挂载到 /data/usb 目录中

    ```bash
    sudo blkid
    sudo mkdir /data/usb
    sudo mount -o chdepage=950,iocharset=utf8 UUID="35BC-6D6B" /data/usb
    ```

    如果带有中文文件名的数据，那么可以在挂载时指定一下挂载文件系统所使用的语系数据

<br/>

#### 四、重新挂载

1. **范例**：将 / 重新挂载，并加入参数为 rw 与 auto

    ```bash
    sudo mount -o remount,rw,auto /
    ```

   

2. **范例**：将 /var 这个目录暂时挂载到 /data/var 底下

    ```bash
    sudo mkdir /data/var
    sudo mount --bind /var /data/var
    ls -lid /var/data/var  # 验证一下，发现一模一样
    ```

   <br/>

#### 五、卸载

```bash
[root@study ~]# umount [-fn] 装置文件名或挂载点
选项与参数：
-f ：强制卸除！可用在类似网络文件系统 (NFS) 无法读取到的情况下；
-l ：立刻卸除文件系统，比 -f 还强！
-n ：不更新 /etc/mtab 情况下卸除。
```

1. **范例一**：将本章之前自行挂载的文件系统全部卸除

    ```bash
    sudo mount
    ```

    注意：如果装置有被其他方式挂载，则需要使用挂载点在卸载

2. **范例二**：使用装置文件名来卸载

    ```bash
    sudo umount /dev/sda4
    ```

3. **范例三**：使用挂载点来卸载

    ```bash
    sudo umount /data/ext4
    ```

   