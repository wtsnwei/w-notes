使用Linux中的tee命令可以一举两得：从标准输入读取结果，同时将结果打印到文件和标准输出。



## Tee命令语法

tee命令语法非常简单，采用以下格式：

```
tee 选项 文件
```


**示例1 - 检查系统中的块设备并将使用tee命令输出显示到终端，同时保存在名为 sda_info.txt 文件中**

```bash
~ >>> lsblk | tee sda_info.txt                                                 
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0   20G  0 disk 
├─sda1   8:1    0    1G  0 part /boot
├─sda2   8:2    0   10G  0 part /
├─sda3   8:3    0    2G  0 part [SWAP]
├─sda4   8:4    0  6.9G  0 part /home
└─sda5   8:5    0 60.4M  0 part 
sr0     11:0    1 1024M  0 rom 
```


**示例2 - 使用tee将命令输出保存到多个文件**

```bash
~ >>> hostnamectl | tee test1.txt test2.txt                                    
   Static hostname: wtsn-manjaro
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 5aab9dafdba74ba3a658a69c846c3fa7
           Boot ID: 2502626117174fe987a52ad4b5661181
    Virtualization: vmware
  Operating System: Manjaro Linux
            Kernel: Linux 5.8.6-1-MANJARO
      Architecture: x86-64

```


**示例3 - 禁止在屏幕输出tee命令**

```bash
~ >>> df -Th | tee test3.txt > /dev/null
```

将输出重定向到/dev/null


**示例4 - 使用tee命令将输出追加到文件**

```bash
~ >>> date | tee -a test1.txt                                                  
2020年 09月 28日 星期一 08:58:15 CST
```


**示例5 - 将tee与sudo命令一起使用**

```bash
~ >>> echo "192.168.1.100 db-01" | sudo tee -a /etc/hosts                      
[sudo] password for wtsn: 
192.168.1.100 db-01
```


**示例6 - 使用tee命令将一个命令的输出重定向到另一个命令**

```bash
~ >>> grep 'root' /etc/passwd | tee /tmp/passwd.tmp | wc -l                    
1
```


**示例7 -** 使用tee命令将更改保存到Vim编辑器中的文件

假设您以非root用户身份工作，正在对root拥有的文件进行更改，但忘记将sudo放在命令前面，现在您想保存更改：那么在vim命令行模式下运行如下命令

```
:w !sudo tee %
```


**示例8 - 使用tee命令时忽略中断信号**

```bash
ping -c 5 www.baidu.com | tee -i /tmp/pingtest.tmp
```


**示例8 - shell脚本中的tee命令用法**

```bash
#!/bin/bash
LOGFILE=/tmp/basic-logs-$(date +%d%m%Y)
FLAVOR=$(cat /etc/*-release  | grep -w 'NAME=' | cut -d"=" -f2 | awk '{print $1}'| sed 's/"//g')
if [ $FLAVOR == CentOS ];
then
   dmesg | grep -i 'error' | tee -a $LOGFILE
   grep -i 'installed' /var/log/dnf.log | tee -a $LOGFILE
else
   echo 'do nothing'
fi
```

