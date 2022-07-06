## 启动 reids

```bash
docker run \
-p 6379:6379 \
--name redis \
-v /data/redis/redis.conf:/etc/redis/redis.conf  \
-v /data/redis/data:/data \
-d --restart=always redis redis-server /etc/redis/redis.conf \
--appendonly yes
```

