# Alertmanager路由配置详解

alertmanager配置文件中比较重要的点是route的配置，可以使我们的告警根据不同的标签告警到不同的渠道。配置文件解析如下：

```yaml
global:  # 配置邮箱、url、微信等
route： # 配置主路由
  - receiver:  # 从receivers 中选择 receiver
  - group_by: []  # 要对所有可能的标签进行聚合，分类依据
  - continue: false  # 告警是否继续去路由子节点
  # 通过标签去匹配这次告警是否符合这个路由节点，必须全部匹配才可以告警
  - match: [labelname:labelvalue,labelname1,labelvalue1]
  # 通过正则表达是匹配标签，意义同上
  - match_re: [labelname:regex]
  # 通过PromQL和OpenMetrics来匹配
  - matchers:
  # 为发送一组警报的通知最初等待多长时间，通常为0-几分钟。
  - group_wait: 30s
  # 当组内已经发送过一个告警，组内若有新增告警需要等待的时间，通常为5分钟或以上
  - group_interval: 5m
  # 告警已经发送，且无新增告警，重复告警所需间隔，通常为3小时以上，默认4小时
  - repeat_inteval: 4h
  routes:
     - route:# 路由子节点 配置信息跟主节点的路由信息一致
```

例如：

```yaml
route:
  receiver: 'default-receiver'
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  group_by: [cluster, alertname]
  routes:
  - receiver: 'database-pager'
    group_wait: 10s
    match_re:
      service: mysql|cassandra
  - receiver: 'frontend-pager'
    group_by: [product, environment]
    match:
      team: frontend
```
