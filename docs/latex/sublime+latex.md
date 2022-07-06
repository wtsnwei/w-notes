# 一、准备软件

* [sublime text2/3](http://www.sublimetext.com/3)

* TeX Live（[在线安装](http://mirror.ctan.org/systems/texlive/tlnet/install-tl-windows.exe) 或者 [离线安装](http://mirror.ctan.org/systems/texlive/Images/)）

* [SumatraPDF](https://www.sumatrapdfreader.org/downloadafter.html)），只支持Windows，可以选择installer版，也可以选择portable版（不安装，可直接运行）。




# 二、安装

## 安装TeX Live

1、按照上述链接下载镜像文件，然后解压。

2、解压后，以管理员权限运行 *install-tl-advanced.bat* ，然后会跳出如下图片

![img](/img/v2-76310a754ffeff5c7e7499894442739b_720w.jpg)

3、可以自己选择安装路径，相应的设置好后，点击<span style="color:#ea4355">安装TeXLive</span>，等待二三十分钟左右，就装好了，其实我还挺喜欢自带的编辑器的，界面简单干净。

![img](/img/v2-a03d2892271e02c03e9c2417577d80be_720w.jpg)



## 安装Sublime Text3

1、按照上述链接地址下载安装包

2、双击运行即可



## 安装SumatraPDF

1、按照上述链接地址下载安装包

2、双击运行即可安装



# 三、配置步骤

1、依次安装好 sublime text、LaXTeX 和 SumatraPDF。

2、在 sublime text 中安装 latexTools 插件：

- **方式1**:（事先安装好了Package Control）：打开sublime text，按组合键ctrl+shift+p；输入*install*；再输入*latexTools*；回车键安装。

- **方式2**：访问latexTools插件官方GitHub：[LaTeXTools](https://github.com/SublimeText/LaTeXTools)；下载或clone代码库；打开sublime text安装目录，打开文件夹`Data\Packages`；将latexTools源代码解压到Packages文件夹中；将解压后的文件夹名称改为`LaTeXTools`；重启sublime text，安装完毕。

3、打开 LaTeXTools 文件夹，然后用 sublime text 打开 LaTeXTools.sublime-settings，给“texpath”添加 miktex 的安装路径，给“sumatra”添加 SumatraPDF 的可执行文件路径，如下图所示。保存退出。![img](/img/v2-6237aa0cbc78d3d8ea986d28f63853d3_720w.jpg)

4、配置反向搜索，打开 SumatraPDF，点击<span style="color:#ea4355">设置→选项</span>，在弹出的对话框的最下面一栏中填入：<span style="color:#ea4355">`"D:\\sublime\\newsublime\\Sublime Text3\\sublime_text.exe" "%f:%l"`</span>。注意修改成自己的sublime text安装目录。

![img](/img/v2-5bb992a889892f93179f77e2d40303bf_720w.jpg)

>**注意**：如果下载的SumatraPDF点击 *设置->选项* 之后，找不到红色框框这个地方，就是说明没有开启TeX功能，那就**设置->高级选项**，然后找到
>
>![img](/img/v2-ceee8cc034f51ed136a1ea576881ccb4_720w.png)
>
>把 **EnableTeXEnhancements** 的参数改成 true 即可，再按照前面的方法配置，这样就配置好反向搜索啦。



# 三、使用

1、打开或创建一个 `.tex` 文件。

2、编辑完之后，按 ctrl+B 可编译。第一次编译可能会需要安装一些其他插件，默认点击“install”即可。

3、编译完成后，会弹出 SumatraPDF 窗口，里边所展示的 pdf 内容即是你在 sublime text 所编辑的内容。双击 SumatraPDF 的某个内容，可以自动跳转到 sublime text 的代码段。

4、编译后会在 .tex 文件的同文件夹下生成一些其他文件，包括 pdf 文件，编译的详细 log 等。


**参考**

> [在sublime text3上配置并使用LaTeX](https://zhuanlan.zhihu.com/p/149047457)