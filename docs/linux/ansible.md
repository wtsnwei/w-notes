# 一、Ansible 远程执行脚本

1. 先在服务端创建一个 shell 脚本
   
    ```bash
    echo > /tmp/test.sh <<EOF
    #!/bin/bash  # 这一行非常重要，不要掉了
    pwd
    hostname
    EOF
    ```

2. 直接执行
   
    ```bash
    ansible other -m script -a '/tmp/test.sh'
    ```

3. 切换目录执行
   
    ```bash
    ansible other -m script -a 'chdir=/tmp/ /tmp/test.sh'
    ```

4. 存在文件/目录，则不执行
   
    ```bash
    ansible other -m script -a 'creates=/tmp/test.sh /tmp/test.sh'
    ```

5. 存在文件/目录，则执行
   
    ```bash
    ansible other -m script -a 'removes=/tmp/test.sh /tmp/test.sh'
    ```

# 二、playbook

## 1、copy 模块

```yaml
---
# hosts 是目标, 在/etc/ansible/hosts中定义- hosts: worker
  # 指定用户
  remote_user: root
  tasks:
    # 任务名
    - name: Transfer file
      # 模块名
      ansible.builtin.copy:
        # 模块参数
        src: /tmp/ceph-common.tar.gz
        dest: /tmp/ceph-common.tar.gz
        # owner: root
        # group: root
        # mode: u=rwx,g-wx,o-rwx
```

## 2、script 模块

```yaml
---
- hosts: worker
  remote_user: root
  tasks:
    # 任务名
    - name: install ceph-common (free form)
      # 模块名
      ansible.builtin.script: /tmp/install-ceph-common.sh
      # 模块参数
      # args:
        # 如果文件/目录不存在，则执行
        # creates: /tmp/install-ceph-common.sh
        # 如果文件/目录存在，则执行
        # removes: /tmp/install-ceph-common.sh
```

## 3、yum 模块

```yaml
---
- hosts: worker
  tasks:
    - name: uninstallthe ceph-common
      yum:
        name: ceph-common
        state: absent
```

## 4、file 模块

```yaml
- name: delete files
  file:
    path: "{{ item }}"
    state: absent
  with_items:
    - /tmp/test.sh

- name: delete directory or file
  file:
    path: /tmp/test
    state: absent
```