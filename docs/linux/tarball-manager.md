## 一、源码编译所需基础软件

* gcc 或 cc 等 C 语言编译程序(compiler)；

* make 及 autoconfig 等软件：

  由于不同的系统里面可能具有的基础软件环境并不相同， 所以就需要检测用户的作业环境，好自行建立一个 makefile 文件。这个自行侦测的小程序也必须要藉由 autoconfig 这个相关的软件来辅助才行。

* 需要 Kernel 提供的 Library 以及相关的 Include 文件： 

  很多软需要调用用系统核心提供的函式库与 include 文件的，这样才可以与这个操作系统兼容啊！尤其是在 <span style="color:#ea4355">『驱动程序方面的模块』</span>，例如网络卡、声卡、USB 等驱动程序。在Red Hat 的系统当中(包含 Fedora/CentOS 等系列) ，这个核心相关的功能通常都是被包含在 <span style="color:#ea4355">kernel-source</span> 或 <span style="color:#ea4355">kernel-header</span> 这些软件名称当中，所以记得要安装这些软件喔！



## 二、安装基础环境

透过 yum 的软件群组安装功能，你可以这样做： 

* 如果是要安装gcc 等软件开发工具，请使用『yum groupinstall "Development Tools" 』 
* 若待安装的软件需要图形接口支持，一般还需要『yum groupinstall "X Software Development" 』
* 若安装的软件较旧，可能需要『yum groupinstall "Legacy Software Development" 』



## 三、源码安装的基本步骤

1. 取得原始档：将tarball 文件在 `/usr/local/src` 目录下解压缩； 
2. 取得步骤流程：进入新建立的目录底下，<span style="color:#ea4355">去查阅 INSTALL 与 README </span>等相关文件内容(很重要的步骤！) ； 
3. 相依属性软件安装：根据 INSTALL/README 的内容察看并安装好一些相依的软件(非必要)；
4. 建立makefile：以自动侦测程序(configure 或config) 侦测作业环境，并建立 Makefile 这个文件； 
5. 编译：以 make 这个程序并使用该目录下的 Makefile 做为他的参数配置文件，来进行make (编译或其他) 的动作；
6. 安装：以 make 这个程序，并以 Makefile 这个参数配置文件，依据 install 这个目标(target) 的指定来安装到正确的路径！

OK！我们底下约略提一下大部分的tarball 软件之安装的指令下达方式：

1. <span style="color:#ea4355">`./configure`</span>

    这个步骤就是在建立Makefile 这个文件啰！通常程序开发者会写一支scripts 来检查你的Linux 系统、相关的软件属性等等，这个步骤相当的重要， 因为未来你的安装信息都是这一步骤内完成的！另外，**这个步骤的相关信息应该要参考一下该目录下的 README 或 INSTALL 相关的文件**！

2. <span style="color:#ea4355">`make clean`</span>

    make 会读取 Makefile 中关于 clean 的工作。这个步骤不一定会有，但是希望执行一下，因为他可以去除目标文件！因为谁也不确定原始码里面到底有没有包含上次编译过的目标文件(*.o) 存在，所以当然还是清除一下比较妥当的。至少等一下新编译出来的执行档我们可以确定是使用自己的机器所编译完成的嘛！

3. <span style="color:#ea4355">`make`</span>

    make 会依据 Makefile 当中的预设工作进行编译的行为！编译的工作主要是进行gcc 来将原始码编译成为可以被执行的object files ，但是这些 object files 通常还需要一些函式库之类的 link 后，才能产生一个完整的执行档！使用 make 就是要将原始码编译成为可以被执行的可执行文件，而这个可执行文件会放置在目前所在的目录之下，尚未被安装到预定安装的目录中；

4. <span style="color:#ea4355">`make install`</span>

    通常这就是最后的安装步骤了，make 会依据 Makefile 这个文件里面关于 install 的项目，将上一个步骤所编译完成的数据给他安装到预定的目录中，就完成安装啦！



## 四、管理

为了方便Tarball 的管理，通常鸟哥会这样建议使用者：

1. 最好将tarball 的原始数据解压缩到 `/usr/local/src` 当中； 

2. 安装时，最好安装到 `/usr/local` 这个默认路径下；

3. 考虑未来的反安装步骤，最好可以将每个软件单独的安装在 `/usr/local` 底下； 

4. 为安装到单独目录的软件之 man page 加入 man path 搜寻： 如果你安装的软件放置到 `/usr/local/mysoftware/` ，那么man page 搜寻的设定中，可能就得要在 `/etc/man_db.conf` 内的40~50 行左右处，写入如下一行：

    ```shell
    MANPATH_MAP /usr/local/mysoftware/bin /usr/local/mysoftware/man
    ```

    这样才可以使用 man 来查询该软件的在线文件啰！



## 五、示例演示

我们利用时间服务器(network time protocol) ntp 这个软件来测试安装看看。先请到 http://www.ntp.org/downloads.html 这个目录去下载文件，请下载最新版本的文件即可。

假设我对这个软件的要求是这样的： 

* 假设 `ntp-4.*.*.tar.gz` 这个文件放置在 /root 这个目录下；
* 原始码请解开在 /usr/local/src 底下；
* 我要安装到 /usr/local/ntp 这个目录中； 

那么可以依照底下的步骤来安装。

#### 1、解压缩下载的 tarball，并参阅 README/INSTALL 文件

```bash
[root@study ~]# cd /usr/local/src <==切换目录
[root@study src]# tar -zxvf /root/ntp-4.2.8p3.tar.gz <==解压缩到此目录
ntp-4.2.8p3/ <==会建立这个目录喔！
ntp-4.2.8p3/CommitLog
....(底下省略)....

[root@study src]# cd ntp-4.2.8p3
[root@study ntp-4.2.8p3]# vi INSTALL <==记得 README 也要看一下！ 
# 特别看一下 28 行到 54 行之间的安装简介！可以了解如何安装的流程喔！
```



#### 2、检查configure 支持参数，并实际建置makefile 规则文件 

```bash
[root@study ntp*]# ./configure --help | more <==查询可用的参数有哪些 
--prefix=PREFIX install architecture-independent files in PREFIX 
--enable-all-clocks + include all suitable non-PARSE clocks: 
--enable-parse-clocks - include all suitable PARSE clocks: 
# 上面列出的是比较重要的，或者是你可能需要的参数功能！ 

[root@study ntp*]# ./configure --prefix=/usr/local/ntp \ 
> --enable-all-clocks --enable-parse-clocks <==开始建立makefile 
checking for a BSD-compatible install... /usr/bin/install -c 
checking whether build environment is sane... yes 
....(中间省略).... 
checking for gcc... gcc <==也有找到 gcc 编译程序了！ 
....(中间省略).... 
config.status: creating Makefile <==现在知道这个重要性了吧？ 
config.status: creating config.h 
config.status: creating evconfig-private.h 
config.status: executing depfiles commands 
config.status: executing libtool commands
```

一般来说 configure 设定参数较重要的就是那个 `--prefix=/path` 了，`--prefix` 后面接的路径就是『这个软件未来要安装到那个目录去？』如果你没有指定 `--prefix=/path` 这个参数，通常预设参数就是 `/usr/local` 至于其他的参数意义就得要参考 `./configure --help` 了！

<span style="color:#ea4355">最重要的是最后需要成功的建立起Makefile 才行！</span>



#### 3、最后开始编译与安装噜！

```bash
[root@study ntp*]# make clean; make 
[root@study ntp*]# make check 
[root@study ntp*]# make install 
# 将数据给他安装在 /usr/local/ntp 底下
```

完成之后到 `/usr/local/ntp` 验证看看！