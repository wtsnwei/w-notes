## 什么是RBAC

RBAC全称Role-Based Access Control，是Kubernetes集群基于角色的访问控制，实现授权决策，允许通过Kubernetes API动态配置策略。



## 什么是Role

Role是一组权限的集合，例如Role可以包含列出Pod权限及列出Deployment权限，Role用于给某个NameSpace中的资源进行鉴权。

通过YAML资源定义清单创建Role： `kubectl apply -f pod-role.yaml`



```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-role
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```



## 什么是ClusterRole

ClusterRole是一组权限的集合，但与Role不同的是，ClusterRole可以在包括所有NameSpce和集群级别的资源或非资源类型进行鉴权。

通过YAML资源定义清单创建ClusterRole： `kubectl apply -f pod-clusterrole.yaml`

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: pod-clusterrole
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```



## 相关参数

Role、ClsuterRole Verbs 可配置参数

```
"get", "list", "watch", "create", "update", "patch", "delete", "exec"
```



Role、ClsuterRole Resource 可配置参数

```
"services",
"endpoints",
"pods",
"secrets",
"configmaps",
"crontabs",
"deployments",
"jobs",
"nodes",
"rolebindings",
"clusterroles",
"daemonsets",
"replicasets",
"statefulsets",
"horizontalpodautoscalers",
"replicationcontrollers",
"cronjobs"
```





Role、ClsuterRole APIGroup可配置参数

```
"","apps", "autoscaling", "batch"
```
