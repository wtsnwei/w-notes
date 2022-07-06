# TeX、LaTeX、TeXLive 小结



## 几个概念

|                  类别                   | 名词                                         | 说明                                                         |
| :-------------------------------------: | :------------------------------------------- | ------------------------------------------------------------ |
|                                         | (Knuth)TeX                                   | 真正的(原始的)TeX                                            |
|                                         | ε-TeX                                        | 相对于原始的TeX它提供了一种扩展模式                          |
|                  引擎                   | pdfTeX                                       | 它从tex文件直接生成pdf文件（开发者已经转向LuaTeX）           |
|                                         | XeTeX                                        | 相对于原始的TeX，主要增加了Unicode和 OpenType 的支持         |
|                                         | LuaTeX                                       | 它使用Lua作为扩展语言，对于LaTeX支持尚不完善？               |
|                                         | ……                                           |                                                              |
|                                         | <span style="color:#bb1100">plain TeX</span> | <span style="color:#bb1100">最古老的TeX宏集，提供了一些最基本的命令</span> |
|                                         | <span style="color:#bb1100">AMSTeX</span>    | <span style="color:#bb1100">是美国数学会提供的一个TeX宏集，它添加了许多数学符号和数学字体</span> |
| <span style="color:#bb1100">宏集</span> | <span style="color:#bb1100">LaTeX</span>     | <span style="color:#bb1100">相对于PlainTeX，它使得科技文档的排版更加直观和方便</span> |
|                                         | <span style="color:#bb1100">ConTeXt</span>   | <span style="color:#bb1100">和LaTeX 相比，它更加灵活和自由</span> |
|                                         | <span style="color:#bb1100">……</span>        |                                                              |
|                                         | TeX Live                                     | 国际TeX用户组织TUG开发,支持不同的操作系统                    |
|                                         | MiKTeX                                       | Windows 下广泛使用的一个TeX发行版                            |
|                 发行版                  | ConTeXt Minimals                             | 它包含了最新版本的 ConTeXt                                   |
|                                         | teTeX                                        | 一个Unix下的TeX发行版，现在已经停止更新且并入TeXLive         |
|                                         | fpTeX                                        | 一个Windows的TeX发行版，已不再更新                           |
|                                         | ……                                           |                                                              |



## LaTeX

原始的TeX已经有了一组宏集，也就是Knuth所写的著名的Plain TeX(原始的TeX和Plain Tex都是《The TeXbook 》一书中介绍的内容)。

但是这些命令仍然很底层，不够方便、直观，于是Leslie Lamport写了另一组宏，称为LaTeX，主要是它版本配置和文中内容适度分开处理。

LaTeX 2ε是自1993年以来LaTeX的一个稳定版本，是目前大部分LaTeX书籍的主体内容。

MiKTeX, TeXlive以及CTeX被称为LaTeX发行版, 是对多种编译器、文档阅读器、LaTeX常用宏包(packages)以及宏包管理工具的打包。



## LaTex发行版

#### CTeX(不推荐使用)

ctex发行版提供了一个统一的中文LaTeX文档框架，底层支持CCT、CJK和xeCJK三种中文LaTeX宏包。

* CCT：非常不推荐了
* CJK：应该在windows下工作还很不错
* xeCJK：比较推荐

ctex 提供了编写中文LaTeX文档常用的一些宏定义和命令。

主要文件包括ctexart.cls、ctexrep.cls、ctexbook.cls 和 ctex.sty、ctexcap.sty。



#### MiKTeX

MiKTeX是主流的LaTeX发行版之一, 编译器齐全, 宏包管理功能方便直观, 更新迭代即时。该发行版适合于Windows系统。



#### TeXlive

同样的, TeXlive是另一款主流的LaTeX发行版, 具备MiKTeX一样的优点。与MiKTeX略有不同之处在于, 其更新策略为每年一个大版本迭代, 版本号以年份标注。该发行版更适合于类Unix系统, 即: Linux与Mac系统(Mac系统更推荐MacTeX, 其内核仍是TeXlive)。



## 生成pdf流程

原始方式

| *.tex | ==>   | *.dvi | ==>   | *.ps | ==>    | *.pdf |
| ----- | ----- | ----- | ----- | ---- | ------ | ----- |
|       | latex |       | divps |      | ps2pdf |       |

dvipdfm(x)，少一个 *.ps 步骤

| *.tex | ==>   | *.dvi | ==>     | *.pdf |
| ----- | ----- | ----- | ------- | ----- |
|       | latex |       | dvipdfm |       |

pdflatex 或 xelatex，直接生成 pdf

| *.tex | ==>              | *.pdf |
| ----- | ---------------- | ----- |
|       | pdflatex/xelatex |       |



## 编辑器

**TeXworks** : 很不错的一个Tex(LaTeX、ConTeXt等)文档的创作环境，一个基于Unicode的可感知TeX的编辑器，集成了PDF浏览功能，干净、简洁的操作界面。

恩，更主要的是Qt4编写的开源软件，跨Windows、Linux、Mac OS环境。



## 中文配置

主要涉及几个宏包，这些宏包进化太快了，远没有latex稳定，了解它们最好的办法可能就是看其自带的手册了。

当前的推荐配置(?)

- 使用XeLaTeX引擎处理中文(推荐)
- 使用xeCJK宏包解决中西文字体选择、标点符号位置、CJK兼容等问题
- 使用ctex宏包和文档类解决中文版式习惯的问题



范例一：使用 XeLaTex 引擎（需要设置所用字体，使用命令<span style="color:#ea4355">fc-list</span>用来查看系统字体）

```latex
\documentclass[11pt,a4paper]{article}
\usepackage{fontspec}
\setmainfont{WenQuanYi Micro Hei}  % 使用系统中有的字体
\begin{document}
TeX Live 2011，XeLaTeX，Texworks，你们好！！
\end{document}
```

>为了进行配置，xetex 安装后 (不管是初始安装还是后来安装的) 都会在 TEXMFSYSVAR/fonts/conf/ 创建一个必需的配置文件 texlive-fontconfig.conf（windows中为 fonts.conf）。为了整个系统中使用 TEX Live 的字体，请依照下面的步骤来做:
>
>有足够的权限：
>
>1. 将 texlive-fontconfig.conf 文件复制到 /etc/fonts/conf.d/09-texlive.conf 。
>2. 运行 fc-cache -fsv。
>
>如果你没有足够的权限执行上述操作，或者只需要把 TEX Live 字体提供给你自己，可以这么做：
>
>1. 将 texlive-fontconfig.conf 文件复制到 ~/.fonts.conf，其中 ~ 是你的主目录。
>2. 运行 fc-cache -fv。
>  你可以运行 fc-list 来查看系统字体的名称。命令 `fc-list : family style file spacing > font.txt` 可以查看一些有趣的信息。



范例二：直接使用 xeCJK 宏包。(属于底层的方案)

```latex
\documentclass{article}
\usepackage{xeCJK}
\setCJKmainfont{WenQuanYi Micro Hei}
\begin{document}
TeX Live 2011，XeLaTeX，Texworks，你们好！！
\end{document}
```

范例三：使用ctex宏包。高层的方案。(默认的字体是为windows准备的，在linux下可以直接设置字体)

```latex
\documentclass{ctexart}
\setCJKmainfont{WenQuanYi Micro Hei}
\begin{document}
TeX Live 2011，XeLaTeX，Texworks，你们好！！
\end{document}
```