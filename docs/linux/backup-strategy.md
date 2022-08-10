## 完整备份之累积备份

完整备份常用的工具有 dd, cpio, xfsdump/xfsrestore 等等。因为这些工具都能够备份装置与特殊文件！



1. 用 `dd` 来将 /dev/sda 备份到完全一模一样的 /dev/sdb 硬盘上：

    ```bash
    dd if=/dev/sda of=/dev/sdb
    # 由于 dd 是读取扇区，所以 /dev/sdb 这颗磁盘可以不必格式化！非常的方便！
    # 只是你会等非常非常久！因为 dd 的速度比较慢！
    ```

2. 使用 `cpio` 来备份与还原整个系统，假设储存媒体为 SATA 磁带机：

    ```bash
    find / -print | cpio -covB > /dev/st0 <==备份到磁带机
    cpio -iduv < /dev/st0 <==还原
    ```

3. 使用 `xfsdump` 来备份

    假设 /home 为一个独立的文件系统，而 /backupdata 也是一个独立的用来备份的文件系统，那如何使用 dump 将 /home 完整的备份到 /backupdata 上呢？可以像底下这样进行看看：

    ```bash
    # 1. 完整备份
    xfsdump -l 0 -L 'full' -M 'full' -f /backupdata/home.dump /home
    
    # 2. 第一次进行累积备份
    xfsdump -l 1 -L 'full-1' -M 'full-1' -f /backupdata/home.dump1 /home
    ```

4. 使用 `tar` 进行备份

    举例来说，/backupdata 是个独立的文件系统， 你想要将整个系统通通备份起来时，可以这样考虑：将不必要的 /proc, /mnt, /tmp 等目录不备份，其他的数据则予以备份：

    ```bash
    tar --exclude /proc --exclude /mnt --exclude /tmp --exclude /backupdata \
    -jcvp -f /backupdata/system.tar.bz2 /
    ```

   

## 完整备份之差异备份

差异备份常用的工具与累积备份差不多！因为都需要完整备份嘛！如果使用xfsdump 来备份的话，那么每次备份的等级(level) 就都会是 level 1 的意思啦！



1. 使用 tar -N 来备份

    ```bash
    tar -N '2015-09-01' -jpcv -f /backupdata/home.tar.bz2 /home
    # 只有在比 2015-09-01 还要新，且 /home 底下的文件才会被打包进 home.bz2 中！
    # 有点奇怪的是，目录还是会被记录下来，只是目录内的旧文件就不会备份。
    ```

2. 使用 rsync 来进行镜像备份

    这个 rsync 可以对两个目录进行镜像(mirror) ，算是一个非常快速的备份工具！简单的指令语法为：

    ```bash
    rsync -av 来源目录 目标目录
    ```

    范例：将 /home/ 镜像到 /backupdata/home/ 去

    ```bash
    rsync -av /home /backupdata/
    # 此时会在 /backupdata 底下产生 home 这个目录来！
    rsync -av /home /backupdata/
    # 再次进行会快很多！如果数据没有更动，几乎不会进行任何动作！
    ```