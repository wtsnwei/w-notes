## 启动 reids

### docker 启动 redis

```bash
docker run \
-p 6379:6379 \
--name redis \
-v /data/redis/redis.conf:/etc/redis/redis.conf  \
-v /data/redis/data:/data \
-d --restart=always redis redis-server /etc/redis/redis.conf \
--appendonly yes
```



### docker compose 启动 redis

```yaml
version: '2'

services:
  redis:
    image: docker.io/bitnami/redis:7.0
    environment:
      # ALLOW_EMPTY_PASSWORD is recommended only for development.
      # - ALLOW_EMPTY_PASSWORD=yes
      - REDIS_PASSWORD=123456
      # - REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL
    ports:
      - '6379:6379'
    volumes:
      - 'redis_data:/bitnami/redis/data'

volumes:
  redis_data:
    driver: local
```

启动：

```bash
docker-compose up -d
```

> 参考：[https://hub.docker.com/r/bitnami/redis](https://hub.docker.com/r/bitnami/redis)

