## 通过endpoints代理集群外服务

`endpoints` 充当了一个类似 deployment 的资源，它将到 `endpoint` 的请求转发至真正的服务地址。

创建 `service` 时，不再是通过 `selector` 来确定目标服务，而是直接配置 `targetPort` 即可。

**service 和 endpoint 的名称必须相同， 且在一个命名空间下面。**

```yaml
apiVersion: v1
kind: Endpoints
metadata:
  name: ceph-dashboard
  namespace: monitor
subsets:
- addresses:
  - ip: 10.2.1.14 
  ports:
  - port: 18080
    protocol: TCP

---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: ceph-dashboard
  name: ceph-dashboard
  namespace: monitor
spec:
  ports:
  - port: 80
    targetPort: 18080
    protocol: TCP
  sessionAffinity: None
  type: ClusterIP

---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ceph-dashboard
  namespace: monitor
spec:
  rules:
    - host: ceph-dashboard.ava.com
      http:
        paths:
          - path: /
            backend:
              serviceName: ceph-dashboard
              servicePort: 80
```

