## Linux下 split 分割文件 和 cat 合并文件

 <br/>

## split 命令

split 命令可以将一个大文件分割成很多个小文件，有时需要将文件分割成更小的片段，比如为提高可读性，生成日志等。

> 选项
>
> -b：值为每一输出档案的大小，单位为 byte。
>
> -C：每一输出档中，单行的最大 byte 数。
>
> -d：使用数字作为后缀, 作为输出文件名的后缀。
>
> -l：值为每一输出档的列数大小。

**实例**

生成一个大小为100KB的文件

```bash
[root@localhost split]# dd if=/dev/zero bs=100k count=1 of=data.file
1+0 records in 
1+0 records out 
102400 bytes (102 kB) copied, 0.00043 seconds, 238 MB/s
```

使用 split 命令将上面创建的 data.file 分割成大小为10KB的文件

```bash
[root@localhost split]# split -b 10k data.file
[root@localhost split]# ls 
date.file xaa xab xac xad xae xaf xag xah xai xaj
```

文件被分割成多个带有字母的后缀文件，如果想用数字后缀可使用 `-d` 参数，同时可以使用 `-a length` 来指定后缀的长度：

```bash
[root@localhost split]# split -b 10k data.file -d -a 3
[root@localhost split]# ls 
date.file x000 x001 x002 x003 x004 x005 x006 x007 x008 x009
```

为分割后的文件名指定前缀

```bash
[root@localhost split]# split -b 10k data.file -d -a 3 split_file
[root@localhost split]# ls 
date.file split_file000 split_file001 split_file002 split_file003 split_file004  split_file005 split_file006 split_file007 split_file008 split_file009
```



使用`-l`选项根据文件的行数来分割文件，例如把文件分割成每个包含10行的小文件：

```bash
split -l 10 data.file
```

 <br/>

## cat 合并文件

有两种实现方式，一种是将两个文件合并输出一个新的文件，一种是将一个文件追加到另外一个文件后面。

方法一：读入两个文件，将两个文件重定向到新的文件，这种方式可以读入任意多个文件

```bash
cat file1.txt file2.txt > file.txt
```

方法二：使用`>>`将文本流将文件添加到另外一个文件的末尾

```bash
cat file1.txt >> file2.txt
```