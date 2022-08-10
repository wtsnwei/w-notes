## makefile 的基本语法与变量 

基本的 makefile 规则是这样的：

```
目标(target): 目标文件1 目标文件2
<tab> gcc -o 欲建立的执行文件 目标文件1 目标文件2
```

**解释**

* 那个目标(target) 就是我们想要建立的信息；
* 而目标文件就是具有相关性的object files ；
* 那建立执行文件的语法就是以 \<tab> 按键开头的那一行！特别给他留意喔。



『命令行必须要以tab 按键作为开头』才行！他的规则基本上是这样的： 

* 在makefile 当中的# 代表批注； 

* \<tab> 需要在命令行(例如gcc 这个编译程序指令) 的第一个字符；

* 目标(target) 与相依文件(就是目标文件)之间需以『:』隔开。 

  

同样的，我们以刚刚上一个小节的范例进一步说明，如果我想要有两个以上的执行动作时， 例如下达一个指令就直接清除掉所有的目标文件与执行文件，该如何制作呢？ 

```bash
# 1. 先编辑 makefile 来建立新的规则，此规则的目标名称为 clean ： 
[root@study ~]# vi makefile 
main: main.o haha.o sin_value.o cos_value.o 
	gcc -o main main.o haha.o sin_value.o cos_value.o -lm 
clean: 
	rm -f main main.o haha.o sin_value.o cos_value.o 

# 2. 以新的目标 (clean) 测试看看执行 make 的结果：
[root@study ~]# make clean <==就是这里！透过 make 以 clean 为目标 
rm -rf main main.o haha.o sin_value.o cos_value.o 
cc -c -o main.o main.c
cc -c -o haha.o haha.c
cc -c -o sin_value.o sin_value.c
cc -c -o cos_value.o cos_value.c
gcc -o main main.o haha.o sin_value.o cos_value.o -lm
```

如此一来，我们的makefile 里面就具有至少两个目标，分别是 main 与 clean 。

1. 如果我们想要建立 main 的话，输入『make main』；
2. 如果想要清除有的没的，输入『make clean』即可啊；
3. 如果想要先清除目标文件再编译main 这个程序的话，就可以这样输入：『make clean main』。



## 在makefile中使用变量

变量的基本语法为： 

1. 变量与变量内容以『=』隔开，同时两边可以具有空格； 
2. 变量左边不可以有 `<tab>` ，例如上面范例的第一行LIBS 左边不可以是 `<tab>`； 
3. 变量与变量内容在『=』两边不能具有『:』； 
4. 在习惯上，变数最好是以『大写字母』为主； 
5. 运用变量时，以 `${变量}` 或 `$(变量)` 使用；
6. 在该 shell 的环境变量是可以被套用的，例如提到的CFLAGS 这个变数！ 
7. 在指令列模式也可以给予变量。

由于 gcc 在进行编译的行为时，会主动的去读取CFLAGS 这个环境变量，所以，你可以直接在shell 定义出这个环境变量，也可以在makefile 文件里面去定义，更可以在指令列当中给予这个咚咚呢！ 例如：

```bash
[root@study ~]# CFLAGS="-Wall" make clean main
# 这个动作在上 make 进行编译时，会去取用 CFLAGS 的变量内容！
```

也可以这样：

```bash
[root@study ~]# vi makefile
LIBS = -lm
OBJS = main.o haha.o sin_value.o cos_value.o
CFLAGS = -Wall
main: ${OBJS}
gcc -o main ${OBJS} ${LIBS}
clean:
rm -f main ${OBJS}
```

环境变量取用的规则是这样的： 

1. make 指令列后面加上的环境变量为优先； 
2. makefile 里面指定的环境变量第二； 
3. shell 原本具有的环境变量第三。 

此外，还有一些特殊的变量需要了解的喔：

4. $@：代表目前的目标(target)