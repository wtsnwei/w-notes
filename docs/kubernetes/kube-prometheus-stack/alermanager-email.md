告警通知配置如下

```yaml
config:
    global:
      resolve_timeout: 5m
      smtp_smarthost: 'smtp.126.com:25'
      smtp_from: 'kaifa5ssend@126.com'
      smtp_auth_username: 'kaifa5ssend@126.com'
      smtp_auth_password: 'XTUGNPNIICHTQHWO'
    templates:
    - '/etc/alertmanager/config/*.tmpl'

    route:
      group_by: [cluster, alertname]
      group_wait: 30s
      group_interval: 5m
      repeat_interval: 5m
      receiver: 'default'
      routes:
        - match_re:
            severity: page
          receiver: webhook
    receivers:
    - name: 'webhook'
      webhook_configs:
      - url: 'http://alert-msg.platform/v1/message/receiveInfo';

    - name: 'default'
      email_configs:
      - to: 'kaifa5ss@126.com'
      webhook_configs:
      - url: 'http://scan-code.platform/scan';
```
