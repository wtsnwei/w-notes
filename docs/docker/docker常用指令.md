

#### 复制容器里面的文件到本地

```bash
docker cp containerID:/opt/sonarqube/conf /etc/sonar/conf
```

解释：复制容器里面的文件到本地

#### 内存限额

```bash
docker run -m 200M --memory-swap=300M ubuntu
```

解释：

* -m: 最多使用 200M 的内存
* --memory-swap：最多使用 100M 的 swap。
* 默认情况：上面两组参数为 -1，即对容器内存和 swap 的使用没有限制。



#### 停止所有容器

```bash
docker stop $(docker ps -aq)
```



#### 删除所有容器

```bash
docker rm $(docker ps -aq)
```

#### 删除所有的镜像

```bash
docker rmi $(docker images -q)
```

#### 查看容器 ip

```bash
docker inspect -f "{{.NetworkSettings.IPAddress}}" 容器ID
```
