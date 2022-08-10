1. 安装 `yum-priorities`

    ```bash
    yum install yum-priorities
    ```



2. priorities的配置文件是/etc/yum/pluginconf.d/priorities.conf，确认其是否存在。
    其内容为:

    ```bash
    [main]
    enabled=1  # 0禁用 1启用
    ```

   

3. 编辑 /etc/yum.repos.d/ 目录下的 `*.repo` 文件来设置优先级。

    参数为：`priority=N`

    > N的值为1-99



4. 推荐的设置为：

    ```bash
    [base], [addons], [updates], [extras] … priority=1 
    
    [centosplus],[contrib] … priority=2
    
    Third Party Repos such as rpmforge … priority=N  (where N is > 10 and based on your preference)
    ```

    **数字越大,优先级越低**