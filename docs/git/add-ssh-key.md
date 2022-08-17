## 一、本地 git 配置

1. 注册

   ```bash
   git config --global user.email 'delphizt@foxmail.com'
   git config --global user.name 'wtsnwei'
   ```

2. 添加公钥到仓库

   * 本地生成公钥：

     ```bash
     ssh-keygen -t rsa -C "delphizt@foxmail.com"
     ```

   * 仓库添加公钥

     复制生成的 id_rsa.pub 文件内容，粘贴到 <span style="color:#ea4355">gitee主页 > 设置  > 安全设置  > SSH公钥</span>

3. 使用 ssh 地址



## 二、克隆远程仓库到本地

```bash
git clone git@gitee.com:wtsnwei/notes.git
```



## 三、同步本地代码到远程仓库

```bash
git commit -m '注释'
git push origin master
```



## 四、常用操作

1. 删除文件

   ```bash
   git rm -r --cached filename
   ```

2. 移动文件

   ```bash
   git mv file1 file2
   ```

    