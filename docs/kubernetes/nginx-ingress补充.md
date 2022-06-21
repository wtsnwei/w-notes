## nginx 转发请求到 ingress-controller

1. 申请域名

2. 域名解析到公网 ip（该公网 ip 需要绑定内网 ip）

3. 配置 nginx （必须公网 ip 绑定的机器上）

   ```nginx
   location / {
       proxy_pass http://ingress-controller;  # 转发到ingress-controller组的机器上
       proxy_set_header Host ava.test.com;  # 该host对应k8s集群ingress中的域名
   }
   ```



## nginx-controller 配置 TCP 连接

1. 部署 nginx-controller 时添加启动参数

   ```
   --tcp-services-configmap=kube-system/tcp-services
   ```

2. 创建 tcp-services configmap

   ```yaml
   kind: ConfigMap
   apiVersion: v1
   metadata:
     name: tcp-services
     namespace: kube-system
   data:
     '13306': 'basic-service/mysql-master-svc:3306'
     '23306': 'basic-service/haproxy-service:3306'
   ```




## 配置前端

直接将前端请求转发给 `/`，然后交给 ingress-controller 处理。

**注意**：需要将 `/` 配置到最后面，否则其他路径的请求都会到 `/`。



## nginx 全局变量

配置跨域时，全局变量需要设置成不同的字符串，即使在不同文件：

```nginx
map $http_origin $allow_origin {
    "~^(https://salestest.ava.com)" $1;
    "~^(https://uaatest.ava.com)" $1;
}

server {
    ……
    add_header Access-Control-Allow-Origin $allow_origin;
    ……
}
```

* `allow_origin` 变量不能和其他文件中的变量名重复