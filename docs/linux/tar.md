长时间不解压缩，命令就会忘记，给自己留个记录，没事来看看。

打包成tar.gz格式压缩包

```bash
$ tar -zcvf renwolesshel.tar.gz /renwolesshel
```

解压tar.gz格式压缩包

```bash
$ tar zxvf renwolesshel.tar.gz
```

打包成tar.bz2格式压缩包

```bash
$ tar -jcvf renwolesshel.tar.bz2 /renwolesshel
```

解压tar.bz2格式的压缩包

```bash
$ tar jxvf renwolesshel.tar.bz2
```

压缩成zip格式

```bash
$ zip -q -r renwolesshel.zip renwolesshel/
```

解压zip格式的压缩包

```bash
$ unzip renwolesshel.zip
```

暂时先这些吧，后期遇到了再添加。