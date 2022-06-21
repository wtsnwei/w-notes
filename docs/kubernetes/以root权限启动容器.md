## k8s deployment 以 root 角色启动容器

```yaml
containers:
  - name: ...
    image: ...
    securityContext:
      runAsUser: 0
```

这样可以使容器以 root 用户运行。
0 指 root 用户的 uid。
