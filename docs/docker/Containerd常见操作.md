### **1. Containerd常见操作**

更换Containerd后，以往我们常用的docker命令也不再使用，取而代之的分别是crictl和ctr两个命令客户端。

- crictl是遵循CRI接口规范的一个命令行工具，通常用它来检查和管理kubelet节点上的容器运行时和镜像
- ctr是containerd的一个客户端工具，

使用crictl命令之前，需要先配置`/etc/crictl.yaml`如下：

```yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
debug: false
```

接下来就是crictl的的常见命令，其中能完全替代docker命令的参照下列表格

![img](https://pic2.zhimg.com/80/v2-a036337823991d621c14599fb3440b11_720w.jpg)

可以看到crictl对容器生命周期的管理基本已经覆盖，不过在crictl我们不能完成操作也比较多，比如对镜像的管理就不属于它的管理范围。这部分还得依靠ctr来实现，操作方式同样可以参照下表

![img](https://pic4.zhimg.com/80/v2-b624dc171f1eb3efd4264b230b6deeeb_720w.jpg)

这里需注意的是，由于Containerd也有namespaces的概念，对于上层编排系统的支持，主要区分了3个命名空间分别是`k8s.io`、`moby`和`default`，以上我们用crictl操作的均在k8s.io命名空间完成如查看镜像列表就需要加上`-n`参数

```bash
ctr -n k8s.io images list
```

### **2. Containerd控制台日志**

在Docker时代，kubernetes的容器控制日志默认格式为json，在更换为Containerd后，容器的控制台输出变为text格式，如下

```text
# docker的json格式日志
{"log":"[INFO] plugin/reload: Running configuration MD5 = 4665410bf21c8b272fcfd562c482cb82\n","stream":"stdout","time":"2020-01-10T17:22:50.838559221Z"}

#contaienrd的text格式日志
2020-01-10T18:10:40.01576219Z stdout F [INFO] plugin/reload: Running configuration MD5 = 4665410bf21c8b272fcfd562c482cb82
```

大多情况情况下这会导致我们默认的日志采集客户端以前用`json格式解析器报错而无法继续采集日志`，所以当我们把Containerd上线后还需要修改日志采集端的配置。

以fluentd为样例，我们需要引入`multi_format`来解析两种格式的容器日志

```text
<source>
  @id fluentd-containers.log
  @type tail
  path /var/log/containers/*.log
  pos_file /var/log/es-containers.log.pos
  tag raw.kubernetes.*
  read_from_head true
  <parse>
    @type multi_format
    <pattern>
      format json
      time_key time
      time_format %Y-%m-%dT%H:%M:%S.%NZ
    </pattern>
    #这部分用来正则匹配CRI容器日志格式
    <pattern>
      format /^(?<time>.+) (?<stream>stdout|stderr) [^ ]* (?<log>.*)$/
      time_format %Y-%m-%dT%H:%M:%S.%N%:z
    </pattern>
  </parse>
</source>
```