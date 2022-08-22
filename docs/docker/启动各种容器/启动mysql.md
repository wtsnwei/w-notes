## 启动 mysql

### docker 启动 mysql

```bash
docker run --name mysql \ 
    -p 3306:3306 \
    -v /data/mysql/conf:/etc/mysql/conf.d \
    -v /data/mysql/logs:/var/log/mysql \
    -v /data/mysql/data:/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=root \
    -d mysql:5.7.30
```

### docker compose 启动 mysql

```yaml
version: '2.1'

services:
  mysql:
    image: docker.io/bitnami/mysql:8.0
    ports:
      - '3306:3306'
    volumes:
      - 'mysql_data:/bitnami/mysql/data'
    environment:
      # ALLOW_EMPTY_PASSWORD is recommended only for development.
      # - ALLOW_EMPTY_PASSWORD=yes
      - MYSQL_ROOT_PASSWORD=123456
    healthcheck:
      test: ['CMD', '/opt/bitnami/scripts/mysql/healthcheck.sh']
      interval: 15s
      timeout: 5s
      retries: 6

volumes:
  mysql_data:
    driver: local
```

启动：

```bash
docker-compose up -d
```

> 参考：[https://hub.docker.com/r/bitnami/mysql](https://hub.docker.com/r/bitnami/mysql)

## 进入mysql容器

```bash
docker exec -it mysql bash
```

1. 登录 MySQL

    `mysql -u root -p`

    输入密码：`123456`

2. 创建 Sonar 数据库

    `create database test;`

3. 添加远程登录用户：test ，并授予权限。

    ```bash
    CREATE USER 'test'@'%' IDENTIFIED WITH mysql_native_password BY 'test';
    
    GRANT ALL PRIVILEGES ON *.* TO 'test'@'%';
    ```

4. 退出 MySQL 容器

    `exit`

## 查看 mysql 日志

```bash
docker logs mysql
```
