## 使用 Docker Compose 运行应用程序

```bash
mkdir rabbitmq && cd rabbitmq
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/rabbitmq/docker-compose.yml > docker-compose.yml

docker-compose up -d
```

> 参考：[https://hub.docker.com/r/bitnami/kafka](https://hub.docker.com/r/bitnami/rabbitmq)



## 使用 web 界面管理和操作 rabbitmq

访问 `127.0.0.1:15672`，帐号：`user`，密码：`bitnami`