## 什么是RoleBinding

RoleBinding通过已经定义的Role权限授予到用户、用户组，从而让用户获得在NameSpace对应的操作资源权限。

RoleBinding基本操作

通过YAML资源定义清单创建RoleBinding：`kubectl apply -f pod-rolebinding.yaml`

```yaml
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: RoleBinding
metadata:
  name: pod-rolebinding
  namespace: default
subjects:
- kind: User
  name: carry
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-role
  apiGroup: rbac.authorization.k8s.io
```



## 什么是ClusterRoleBinding

ClusterRoleBinding通过已经定义的ClusterRole权限授予到用户或用户组，从而让用户获得集群内对应的操作资源权限。

ClusterRoleBinding基本操作

通过YAML资源定义清单创建ClusterRoleBinding：`kubectl apply -f pod-clusterrolebinding.yaml`

```yaml
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: pod-clusterrolebinding
subjects:
- kind: Group
  name: super-admin
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: pod-clusterrole
  apiGroup: rbac.authorization.k8s.io
```



## 相关参数

RoleBinding、ClusterRoleBinding绑定的Subject对象可以是User、Group、Service Account