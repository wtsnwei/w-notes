## helm 卸载时不删除 pvc

问题：使用 helm 部署 deployment 资源时，创建的 pvc 会在 uninstall 时一起被删除。

目的：uninstall 时不会自动删除 pvc。

解放方法：在创建 pvc 时添加注解，如下：

```yaml
  annotations:
    helm.sh/resource-policy: "keep"
```

