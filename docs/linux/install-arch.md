# Archlinux安裝指南

## 一、BIOS + GPT

1. ##### 创建分区
   
    ```bash
    # GPT 分区使用 gdisk 分区工具
    /dev/sda1  2M  biosboot ef02
    /dev/sda2  1G  /boot    8300
    /dev/sda3  60G /        8300
    /dev/sda4  40G /home    8300
    /dev/sda5  8G  swap     8200
    ```

2. ##### 安装文件系统
   
    ```bash
    mkfs.xfs /dev/sda2
    mkfs.xfs /dev/sda3
    mkfs.xfs /dev/sda4
    mkswap /dev/sda5
    swapon /dev/sda5  # 最后一条命令是开启交换分区
    ```

3. ##### 挂载分区
   
    ```bash
    mkdir /mnt/{boot,home}
    mount /dev/sda2 /mnt/boot
    mount /dev/sda3 /mnt
    mount /dev/sda4 /mnt/home
    ```

4. ##### 部署基本系统
   
     使用 [pacstrap](https://git.archlinux.org/arch-install-scripts.git/tree/pacstrap.in) 脚本，安装 [base](https://www.archlinux.org/packages/?name=base) 软件包和 Linux [内核](https://wiki.archlinux.org/index.php/Kernel)以及常规硬件的固件，如果你想使用netstat和ifconfig之类的指令，请加上net-tools。：
        
    ```bash
    pacstrap /mnt base linux linux-firmware net-tools
    ```

5. ##### 生成 Fstab
   
    用以下命令生成 [fstab](https://wiki.archlinux.org/index.php/Fstab) 文件 (用 `-U` 或 `-L` 选项设置UUID 或卷标)：
    
    ```bash
    genfstab -U /mnt >> /mnt/etc/fstab
    ```

6. ##### 设置 Root 密码：
   
    ```bash
    passwd
    ```

7. ##### 安装网络服务
   
    务必记得安装networkmanager，不然无法开启网络的自动探测。
    
    ```bash
    pacman -S networkmanager
    ```
   
    开启网络服务
   
    ```bash
    systemctl enable NetworkManager
    ```

8. ##### 安装启动程序
   
    ```bash
    pacman -S grub-bios 
    grub-install /dev/sda 
    grub-mkconfig -o /boot/grub/grub.cfg
    ```

## 二、UEFI + GPT

1. ##### 创建分区
   
    ```bash
    # GPT 分区使用 gdisk 分区工具
    /dev/sda1  2M  biosboot ef02
    /dev/sda2  1G  /efi     ef00
    /dev/sda3  1G  /boot    8300
    /dev/sda4  60G /        8300
    /dev/sda5  40G /home    8300
    /dev/sda6  8G  swap     8200
    ```

2. ##### 安装文件系统
   
    ```bash
    mkfs.xfs /dev/sda3
    mkfs.xfs /dev/sda4
    mkfs.xfs /dev/sda5
    mkswap /dev/sda6
    swapon /dev/sda6  # 最后一条命令是开启交换分区
    
    # 添加efi系统分区
    mkfs.fat -F32 /dev/sda2
    ```

3. ##### 挂载分区
   
    ```bash
    mkdir /mnt/{boot,home}
    mkdir /mnt/efi
    
    # 先挂载根
    mount /dev/sda4 /mnt
    mount /dev/sda2 /mnt/efi
    mount /dev/sda3 /mnt/boot
    mount /dev/sda5 /mnt/home
    ```
   
    > **注意：** 挂载分区一定要遵循顺序，先挂载根（root）分区（到 `/mnt`），再挂载引导（boot）分区（到 `/mnt/boot` 或 `/mnt/efi`，如果单独分出来了的话），最后再挂载其他分区。否则您可能遇到安装完成后无法启动系统的问题。。

4. ##### 部署基本系统
   
    使用 [pacstrap](https://git.archlinux.org/arch-install-scripts.git/tree/pacstrap.in) 脚本，安装 [base](https://www.archlinux.org/packages/?name=base) 软件包和 Linux [内核](https://wiki.archlinux.org/index.php/Kernel)以及常规硬件的固件，如果你想使用netstat和ifconfig之类的指令，请加上net-tools。：
   
    ```bash
    pacstrap /mnt base linux linux-firmware net-tools
    ```

5. ##### 生成 Fstab
   
    用以下命令生成 [fstab](https://wiki.archlinux.org/index.php/Fstab) 文件 (用 `-U` 或 `-L` 选项设置UUID 或卷标)：
   
    ```bash
    genfstab -U /mnt >> /mnt/etc/fstab
    ```

6. ##### 设置 Root 密码：
   
    ```bash
    passwd
    ```

7. ##### 安装网络服务
   
    务必记得安装networkmanager，不然无法开启网络的自动探测。
   
    ```bash
    pacman -S networkmanager
    ```
   
    开启网络服务
   
    ```bash
    systemctl enable NetworkManager
    ```

8. ##### 安装启动程序
   
    ```bash
    pacman -S grub efibootmgr os-prober#(双系统需要) 
    grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=grub
    grub-mkconfig -o /boot/grub/grub.cfg
    ```

**biosboot 分区**

此分区为 BIOS+GPT 必须，但UEFI+GPT最好也加上，提高兼容性。

> 安装 GRUB 前，在一个没有文件系统的磁盘上，创建一个1兆字节（使用 [fdisk](https://wiki.archlinux.org/index.php/Fdisk) 或 [gdisk](https://wiki.archlinux.org/index.php/Gdisk) 和参数`+1M`）的分区，将分区类型设置为 GUID `21686148-6449-6E6F-744E-656564454649`。
> 
> - 对于 [fdisk](https://wiki.archlinux.org/index.php/Fdisk)，选择分区类型 `BIOS boot`。
> - 对于 [gdisk](https://wiki.archlinux.org/index.php/Gdisk)，选择分区类型代码 `ef02`。
> - 对于 [parted](https://wiki.archlinux.org/index.php/Parted)， 在新创建的分区上设置/激活 `bios_grub` 标记。
> 
> 这个分区可以处于磁盘的前 2TB 空间中的任意位置，但需要在安装 GRUB 之前创建好。

## 三、BIOS+MBR

1. ##### 创建分区
   
    ```
    # MBR 分区使用 disk 分区工具
    /dev/sda1  1G  /boot    8300
    /dev/sda2  60G /        8300
    /dev/sda3  40G /home    8300
    /dev/sda4  8G  swap     8200
    ```

2. ##### 安装文件系统
   
    ```bash
    mkfs.xfs /dev/sda1
    mkfs.xfs /dev/sda2
    mkfs.xfs /dev/sda3
    mkswap /dev/sda4
    swapon /dev/sda4  # 最后一条命令是开启交换分区
    ```

3. ##### 挂载分区
   
    ```bash
    mkdir /mnt/{boot,home}
    mount /dev/sda1 /mnt/boot
    mount /dev/sda2 /mnt
    mount /dev/sda3 /mnt/home
    ```

4. ##### 部署基本系统
   
    使用 [pacstrap](https://git.archlinux.org/arch-install-scripts.git/tree/pacstrap.in) 脚本，安装 [base](https://www.archlinux.org/packages/?name=base) 软件包和 Linux [内核](https://wiki.archlinux.org/index.php/Kernel)以及常规硬件的固件，如果你想使用netstat和ifconfig之类的指令，请加上net-tools。：
   
    ```bash
    pacstrap /mnt base linux linux-firmware net-tools
    ```

5. ##### 生成 Fstab
   
    用以下命令生成 [fstab](https://wiki.archlinux.org/index.php/Fstab) 文件 (用 `-U` 或 `-L` 选项设置UUID 或卷标)：
   
    ```bash
    genfstab -U /mnt >> /mnt/etc/fstab
    ```

6. ##### 设置 Root 密码：
   
    ```bash
    passwd
    ```

7. ##### 安装网络服务
   
    务必记得安装networkmanager，不然无法开启网络的自动探测。
   
    ```bash
    pacman -S networkmanager
    ```
   
    开启网络服务
   
    ```bash
    systemctl enable NetworkManager
    ```

8. ##### 安装启动程序
   
    ```bash
    pacman -S grub
    grub-install --target=i386-pc /dev/sda 
    grub-mkconfig -o /boot/grub/grub.cfg
    ```
