## 固定 pod 的 ip

**前提**：使用 calico 作为网络插件。

**方法**：在 pod 模板中添加注解，如下：

```yaml
  template:
    annotations:
      cni.projectcalico.org/ipAddrs: '["100.115.95.26"]'
```

