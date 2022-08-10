# 获取动态分配的 ip，以及对应的网卡，关键词是 dynamic
ip addr |grep dynamic |awk '{print $NF"-->"$4}'

# 获取指定网卡: eth1 的ip
ip addr show eth1 |grep 'inet '|awk '{print $4}'

# 多网卡情况下，k8s 使用指定网卡
nodeIP=$(ip addr show eth1 |grep 'inet '|awk '{print $4}')
echo KUBELET_EXTRA_ARGS=\"--node-ip=${nodeIP}\" > /etc/sysconfig/kubelet

# 多网卡情况下，添加 sealos 指定路由到指定网卡 ip 上
nodeIP=$(ip addr show eth1 |grep 'inet '|awk '{print $4}')
ipvsExist=$(ip route |grep 10.103.97.2 |wc -l)
if [ ${ipvsExist} -eq 0 ]; then
    ip route add  10.103.97.2  via  ${nodeIP}
    echo 'Adding route successfully!'
else
    echo exist
fi