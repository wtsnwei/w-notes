## 使用 Docker Compose 运行应用程序

```bash
mkdir kafka && cd kafka
curl -sSL https://raw.githubusercontent.com/bitnami/containers/main/bitnami/kafka/docker-compose.yml > docker-compose.yml

docker-compose up -d
```

> 参考：[https://hub.docker.com/r/bitnami/kafka](https://hub.docker.com/r/bitnami/kafka)



## 使用 *UI for Apache Kafka* 管理和操作 kafka

```yaml
version: '2'
services:
  kafka-ui:
    image: provectuslabs/kafka-ui:ee92ea47cb5153de68c573761b00f158e3349b09
    container_name: kafka-ui
    ports:
      - "8080:8080"
    restart: always
    environment:
      KAFKA_CLUSTERS_0_NAME: local
      KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS: kafka:9092
      SERVER_SERVLET_CONTEXT_PATH: /kafkaui
      AUTH_TYPE: "LOGIN_FORM"
      SPRING_SECURITY_USER_NAME: admin
      SPRING_SECURITY_USER_PASSWORD: pass
networks:
  default:
    name: kafka_default
```

参考地址：[kafka-ui](https://github.com/provectus/kafka-ui)

