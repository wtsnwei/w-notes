# 一、什么是Ingress？

我们知道到`Kubernetes `暴露服务的方式目前只有三种：`LoadBlancer Service`、`ExternalName`、`NodePort Service、Ingress`；而我们将集群内的服务提供外界访问就会产生以下几个问题：

## 1、Pod 漂移问题

随着 Pod 的创建和销毁，Pod IP 肯定会动态变化；

那么如何把这个动态的 Pod IP 暴露出去？

这里借助于 Kubernetes 的 Service 机制。Service 可以以标签的形式选定一组带有指定标签的  Pod，并监控和自动负载他们的 Pod IP，那么我们向外暴露只暴露 Service IP 就行了；

这就是 NodePort  模式：即在每个节点上开起一个端口，然后转发到内部 Pod IP 上，如下图所示：

![](/img/1.png)



## 2、端口管理问题

采用 NodePort 方式暴露服务面临问题是，服务一旦多起来，NodePort  在每个节点上开启的端口会及其庞大，而且难以维护；

这时，我们可以使用一个Nginx直接对内进行转发。

Pod与Pod之间是可以互相通信的，而Pod可以共享宿主机的网络名称空间，也就是说，Pod上所监听的就是Node上的端口。

那么这又该如何实现呢？

简单的实现就是使用 DaemonSet 在每个 Node 上监听 80，然后写好规则，因为 Nginx 外面绑定了宿主机 80 端口（就像  NodePort），本身又在集群内，那么向后直接转发到相应 Service IP 就行了，如下图所示：

![](/img/2.png)

## 3、域名分配及动态更新问题

当每次有新服务加入又该如何修改 Nginx  配置呢？？

假设后端的服务开始只有 ecshop，后面增加了bbs和member服务，那么又该如何将这2个服务加入到Nginx-Pod进行调度呢？

在日常使用中只需要修改nginx.conf即可实现，那在K8S中又该如何实现这种方式的调度呢？？？

此时 Ingress 出现了，除了上面的Nginx，Ingress 还包含两大组件：Ingress Controller 和 Ingress。

![](/img/3.png)

Ingress 简单的理解就是你原来需要改 Nginx 配置，然后配置各种域名对应哪个 Service。

现在把这个动作抽象出来，变成一个  Ingress 对象，你可以用 yaml 创建，每次不要去改 Nginx 了，直接改 yaml 然后创建/更新就行了；

那么问题来了：”Nginx 该怎么处理？”

**Ingress Controller 这东西就是解决 “Nginx 的处理方式” 的。**

Ingress Controler 通过与  Kubernetes API 交互，动态的去感知集群中 Ingress 规则变化，然后读取它，按照它自己的模板生成一段 Nginx 配置，再写到  Nginx Pod 里，最后 reload 一下，工作流程如下图：

![](/img/4.png)

实际上Ingress也是Kubernetes API的标准资源类型之一，它其实就是一组基于DNS名称（host）或URL路径把请求转发到指定的Service资源的规则。简而言之，**ingress 就是转发规则**。

Ingress 自身不能进行“流量穿透”，仅仅是一组规则的集合，它还需要其他功能的辅助，比如监听某套接字然后根据这些规则的匹配进行路由转发，这些**能够为 Ingress 资源监听套接字并将流量转发的组件就是 Ingress Controller**。



# 二、如何创建Ingress资源

Ingress资源是基于HTTP虚拟主机或URL的转发规则，需要强调的是，**这是一条转发规则**。

它在`spec`字段中嵌套了`rules`、`backend`和`tls`等字段进行定义。

如下示例中定义了一个 Ingress 资源，它包含转发规则：将发往 myapp.magedu.com 的请求，转发给一个名字为 myapp 的 Service 资源。

```yaml
apiVersion: extensions/v1beta1		
kind: Ingress		
metadata:			
  name: ingress-myapp   
  namespace: default     
  annotations:          
    kubernetes.io/ingress.class: "nginx"
spec:     
  rules:   
  - host: myapp.magedu.com   
    http:
      paths:       
      - path:       
        backend:    
          serviceName: myapp
          servicePort: 80
```

Ingress 中的 spec 字段是 Ingress 资源的核心组成部分，主要包含以下3个字段：

- rules：用于定义当前Ingress资源的转发规则列表；

- backend：默认的后端用于服务那些没有匹配到任何规则的请求；

  > 定义 Ingress 资源时，必须要定义 backend 或 rules，该字段用于让负载均衡器指定一个全局默认的后端。

- tls：TLS配置，目前仅支持通过443端口提供服务，如果要配置指定的列表成员指向不同的主机，则需要通过SNI TLS扩展机制来支持该功能。

  - backend 对象的定义由2个必要的字段组成：`serviceName` 和 `servicePort`，分别用于指定流量转发的后端目标 Service 资源名称和端口。
  - rules 对象由一系列的 host 规则组成，这些 host 规则用于将一个主机上的某个URL映射到相关后端Service对象，其定义格式如下：

    ```yaml
    spec:
      rules:
      - hosts: <string>
        http:
          paths:
          - path:
            backend:
              serviceName: <string>
              servicePort: <string>
    ```

需要注意的是，`.spec.rules.host` 属性值，目前暂不支持使用IP地址定义，也不支持 `IP:Port` 的格式，该字段留空，代表着通配所有主机名。

tls 对象由2个内嵌的字段组成，仅在定义 TLS 主机的转发规则上使用。

- hosts： 包含 于 使用 的 TLS 证书 之内 的 主机 名称 字符串 列表， 因此， 此处 使用 的 主机 名 必须 匹配 tlsSecret 中的 名称。
- secretName： 用于 引用 SSL 会话 的 secret 对象 名称， 在 基于 SNI 实现 多 主机 路 由 的 场景 中， 此 字段 为 可选。



# 三、Ingress资源类型

Ingress的资源类型有以下4种：

- 1、单Service资源型Ingress
- 2、基于URL路径进行流量转发
- 3、基于主机名称的虚拟主机
- 4、TLS类型的Ingress资源



# 四、Ingress Nginx部署

使用 Ingress 功能步骤：

1. 安装部署ingress controller Pod

2. 部署后端服务 Deployment（默认是nginx）

3. 部署 ingress-nginx Service

通过 ingress-controller 对外提供服务，现在还需要手动给 ingress-controller 建立一个service，接收集群外部流量。方法如下：

## 1. 准备 ingress-controller 的 yaml

```bash
[root@k8s-master ingress]# wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/baremetal/service-nodeport.yaml

[root@k8s-master ingress]# cat service-nodeport.yaml 
apiVersion: v1
kind: Service
metadata:
  name: ingress-nginx
  namespace: ingress-nginx
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
spec:
  type: NodePort
  ports:
    - name: http
      port: 80
      targetPort: 80
      protocol: TCP
      nodePort: 30080
    - name: https
      port: 443
      targetPort: 443
      protocol: TCP
      nodePort: 30443
  selector:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx

```

## 2. 创建 service 并测试访问

```bash
[root@k8s-master ingress]# kubectl apply -f service-nodeport.yaml 
service/ingress-nginx created

[root@k8s-master ingress]# kubectl get svc -n ingress-nginx
NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
default-http-backend   ClusterIP   10.104.41.201   <none>        80/TCP                       45m
ingress-nginx          NodePort    10.96.135.79    <none>        80:30080/TCP,443:30443/TCP   11s

[root@k8s-master ingress]# curl http:${node_ip}:30080
```

      

## 3. 创建 Ingress 并使用

1. 创建 ingress 资源
```bash
[root@k8s-master ingress]# vim ingress-myapp.yaml
apiVersion: extensions/v1beta1		#api版本
kind: Ingress		#清单类型
metadata:			#元数据
  name: ingress-myapp    #ingress的名称
  namespace: default     #所属名称空间
  annotations:           #注解信息
    kubernetes.io/ingress.class: "nginx"
spec:      #规格
  rules:   #定义后端转发的规则
  - host: myapp.magedu.com    #通过域名进行转发
    http:
      paths:       
      - path:       #配置访问路径，如果通过url进行转发，需要修改；空默认为访问的路径为"/"
        backend:    #配置后端服务
          serviceName: myapp
          servicePort: 80

[root@k8s-master ingress]# kubectl apply -f ingress-myapp.yaml

[root@k8s-master ingress]# kubectl get ingress
NAME            HOSTS              ADDRESS   PORTS     AGE
ingress-myapp   myapp.magedu.com             80        46s
```

2. 查看ingres-myapp的信息
```bash
[root@k8s-master ingress]# kubectl describe ingress ingress-myapp
Name:             ingress-myapp
Namespace:        default
Address:          
Default backend:  default-http-backend:80 (<none>)
Rules:
  Host              Path  Backends
  ----              ----  --------
  myapp.magedu.com  
                       myapp:80 (<none>)
Annotations:
  kubectl.kubernetes.io/last-applied-configuration:  {"apiVersion":"extensions/v1beta1","kind":"Ingress","metadata":{"annotations":{"kubernetes.io/ingress.class":"nginx"},"name":"ingress-myapp","namespace":"default"},"spec":{"rules":[{"host":"myapp.magedu.com","http":{"paths":[{"backend":{"serviceName":"myapp","servicePort":80},"path":null}]}}]}}

  kubernetes.io/ingress.class:  nginx
Events:
  Type    Reason  Age   From                      Message
  ----    ------  ----  ----                      -------
  Normal  CREATE  1m    nginx-ingress-controller  Ingress default/ingress-myapp

[root@k8s-master ingress]# kubectl get pods -n ingress-nginx
NAME                                        READY     STATUS    RESTARTS   AGE
default-http-backend-7db7c45b69-fndwp       1/1       Running   0          31m
nginx-ingress-controller-6bd7c597cb-6pchv   1/1       Running   0          55m
```

3. 进入 nginx-ingress-controller 进行查看是否注入了nginx的配置
```bash
[root@k8s-master ingress]# kubectl exec -n ingress-nginx -it nginx-ingress-controller-6bd7c597cb-6pchv -- /bin/bash
www-data@nginx-ingress-controller-6bd7c597cb-6pchv:/etc/nginx$ cat nginx.conf
......
	## start server myapp.magedu.com
	server {
		server_name myapp.magedu.com ;
		
		listen 80;
		
		set $proxy_upstream_name "-";
		
		location / {
			
			set $namespace      "default";
			set $ingress_name   "ingress-myapp";
			set $service_name   "myapp";
			set $service_port   "80";
			set $location_path  "/";
			
			rewrite_by_lua_block {
				
				balancer.rewrite()
				
			}
			
			log_by_lua_block {
				
				balancer.log()
				
				monitor.call()
			}
......
```

4. 修改本地host文件，进行访问
```bash
echo "${node_ip} ${domain}" >> /etc/hosts
curl ${domain}:${nodePort}
```