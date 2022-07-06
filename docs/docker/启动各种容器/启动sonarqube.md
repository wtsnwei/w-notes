## 前提

* docker 能够正常启动
* 已经 pull 了 sonarqube 镜像

## 启动 Sonar

1. 在 /data 目录下创建 sonarqube/
   
    ```bash
    mkdir /data/sonarqube
    ```

2. 【**重要**】创建一个简单的 sonarqube 容器，目的是取出里面的配置文件。为之后创建 sonarqube 时，可以挂载目录。
   
    ```bash
    docker run -d --name sonartest sonarqube:7.4-community
    ```

3. 进入容器（a0 是容器 ID）
   
    ```bash
    docker exec -it sonartest bash
    ```

4. 使用 `docker cp` 命令，将重要文件复制到本机的 /data/sonarqube/ 下
   
    ```bash
    $ docker cp sonartest:/opt/sonarqube/conf /data/sonarqube/
    $ docker cp sonartest:/opt/sonarqube/logs /data/sonarqube/
    $ docker cp sonartest:/opt/sonarqube/data /data/sonarqube/
    $ docker cp sonartest:/opt/sonarqube/extensions /data/sonarqube/
    ```
   
    **解释：** 将 conf/ data/ extensions/ logs/ 复制到 /data/sonarqube 目录下

5. 退出并删除容器
   
    ```bash
    docker stop sonartest
    docker rm sonartest
    ```

6. 修改文件夹权限
   
    ```bash
    chmod -R 777 /data/sonarqube/
    ```

7. 启动 Sonar
   
    ```bash
    sudo docker run \
    -d \
    --name sonarqube \
    -p 9000:9000 \
    -p 9092:9092 \
    --link=mysql:mysql \
    -v /data/sonarqube/logs:/opt/sonarqube/logs \
    -v /data/sonarqube/conf:/opt/sonarqube/conf \
    -v /data/sonarqube/data:/opt/sonarqube/data \
    -v /data/sonarqube/extensions:/opt/sonarqube/extensions \
    -e SONARQUBE_JDBC_USERNAME=sonar \
    -e SONARQUBE_JDBC_PASSWORD=sonar \
    -e SONARQUBE_JDBC_URL="jdbc:mysql://mysql:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance&useSSL=false" \  # 此处的mysql://mysql:3306是访问容器的url,容器ip即是mysql的dns映射
    sonarqube:7.4-community
    ```

    **参数解释：**
    
    - `-d` ： 后台运行容器，并返回容器 ID
    - `–name sonarqube` ： 命名为 sonarqube
    - `-p 9000:9000` ： 将本机的 9000 端口，映射到容器的 9000 端口(web server使用)
    - `-p 9092:9092`： 将本机的 9002 端口，映射到容器的 9002 端口(数据库使用)
    - `–link=mysql:mysql` ： 是指和 mysql 容器连接通讯
    - `-v /data/sonarqube/logs:/opt/sonarqube/logs` ： 将本机 /data/sonarqube/logs 挂载到容器的 /opt/sonarqube/logs
    - `-v /data/sonarqube/conf:/opt/sonarqube/conf` ： 将本机 /data/sonarqube/conf 挂载到容器的 /opt/sonarqube/conf
    - `-v /data/sonarqube/data:/opt/sonarqube/data` ： 将本机 /data/sonarqube/data 挂载到容器的 /opt/sonarqube/data
    - `-v /data/sonarqube/extensions:/opt/sonarqube/extensions` ： 将本机 /data/sonarqube/extensions 挂载到容器的 /opt/sonarqube/extensions
    - `-e SONARQUBE_JDBC_USERNAME=sonar` ： Sonar 使用 sonar 用户连接 MySQL
    - `-e SONARQUBE_JDBC_PASSWORD=sonar` ： MySQL 中 sonar 用户的密码
    - `-e SONARQUBE_JDBC_URL="jdbc:mysql://10.9.40.121:3307/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance&useSSL=false"` ： MySQL 的 URL
    - `sonarqube:7.4-community` ：基于镜像的版本为 sonarqube:7.4-community

8. 启动 Sonar 可能要持续一、两分钟，可以通过查看 logs 日志和正在运行的容器，来判断容器是否启动成功。
   
    `docker logs sonarqube`： 这里的 c 是容器 ID
    
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/2019060108511136.png)
    
    `docker ps -a`