## Introduction

所有的现代操作系统都配备了防火墙——一种调节计算机网络流量的应用程序。防火墙在可信网络(如办公网络)和不可信网络(如互联网)之间创建了一道屏障。[防火墙通过定义规则工作](https://phoenixnap.com/blog/types-of-firewalls)，这些规则管理哪些流量被允许，哪些被阻塞的。为Linux系统开发的实用防火墙是**iptables**。

**在本教程中，学习如何在Linux安装iptables，配置和使用iptables**

![Introduction to a guide on how to secure your Linux system with iptables.](https://phoenixnap.com/kb/wp-content/uploads/2021/04/iptables-tutorial.png)

前提

- 一个具有 **sudo** 权限的用户
- 一个可以访问终端的窗口或命令行(Ctrl-Alt-T, Ctrl-Alt-F2)

## How iptables Work

网络流量由数据包组成。数据被分成更小的部分(称为数据包)，通过网络发送，然后重新组合在一起。Iptables识别接收到的数据包，然后使用一组规则来决定如何处理它们。

Iptables根据以下条件过滤数据包:

- **Tables:** 表是连接类似操作的文件。一个表由几个**chains**组成。
- **Chains:** 链是由**rules**组成的字符串。当一个数据包被接收时，iptables找到合适的table，然后通过**规则**链来运行它，直到找到匹配的。
- **Rules:** 规则是告诉系统如何处理数据包的语句。规则可以阻止一种类型的数据包，也可以转发另一种类型的数据包。数据包被处理的结果称为**target**。
- **Targets:** 目标是一个如何处理一个包决策。通常，是接受它，删除它，或拒绝它(将一个错误发回给发送方)。

### Tables and Chains

Linux防火墙iptables有四个默认表。我们将列出这四个表以及每个表所包含的链。

#### 1\. Filter

**Filter** 表是最常用的一个。它就像一个保镖，决定谁进出你的网络。它有以下默认链:

- **Input** – the rules in this chain control the packets received by the server.
- **Output** – this chain controls the packets for outbound traffic.
- **Forward** – this set of rules controls the packets that are routed through the server.

#### 2\. Network Address Translation (NAT)

该表包含NAT (Network Address Translation)规则，用于将数据包路由到不能直接访问的网络。当数据包的目的或来源发生改变时，使用NAT表。它包括以下链:

- **Prerouting –** this chain assigns packets as soon as the server receives them.
- **Output –** works the same as the output chain we described in the **filter** table.
- **Postrouting –** the rules in this chain allow making changes to packets after they leave the output chain.

#### 3\. Mangle

**Mangle**表调整数据包的IP头属性。表中包含我们上面描述的所有链:

- **Prerouting**
- **Postrouting**
- **Output**
- **Input**
- **Forward**

#### 4\. Raw

**Raw**表用于免除数据包连接跟踪。row表包含前面提到的两个链:

- **Prerouting**
- **Output**

![Diagram with iptables and chains tables contain](https://phoenixnap.com/kb/wp-content/uploads/2021/04/iptables-diagram.png)

#### 5\. Security (Optional)

一些版本的Linux也使用一个**Security**表来管理特殊的访问规则。这个表包括**input、output** 和 **forward**链，很像过滤表。

### Targets

目标是数据包匹配规则条件后发生的事情。**non-terminating(非终止)**目标会根据链中的规则不断匹配数据包，即使数据包匹配了一条规则。

当匹配到了**终止的**目标，一个包会立即被评估，而不会与另一个链匹配。Linux iptables中的终止目标有:

- **Accept** – this rule accepts the packets to come through the iptables firewall.
- **Drop** – the dropped package is not matched against any further chain. When Linux iptables drop an incoming connection to your server, the person trying to connect does not receive an error. It appears as if they are trying to connect to a non-existing machine.
- **Return** – this rule sends the packet back to the originating chain so you can match it against other rules.
- **Reject** – the iptables firewall rejects a packet and sends an error to the connecting device.

## How to Install and Configure Linux Firewall iptables

## Installing Iptables Ubuntu

Iptables are installed default on most Linux systems. To confirm that iptables is installed, use the following command:

```output
sudo apt-get install iptables
```

The example output in Ubuntu confirms that the latest version of iptables is already present:

![command to install iptables on ubuntu](https://phoenixnap.com/kb/wp-content/uploads/2021/04/install-iptables-ubuntu.png)

If you want to keep iptables firewall rules when you reboot the system, install the persistent package:

```output
sudo apt-get install iptables-persistent
```

## Installing Iptables CentOS

**In CentOS 7**, iptables was replaced by **firewalld**.

To install iptables, first you need to stop firewalld. Enter the following commands:

```output
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask firewalld
```

The commands stop and [prevent firewalld from starting at boot](https://phoenixnap.com/kb/how-to-disable-stop-firewall-centos), and do not let other services start firewalld*.*

![how to prevent firewalld from starting at boot](https://phoenixnap.com/kb/wp-content/uploads/2021/04/disable-stop-masd-firewalld-centos.png)

Next, install and enable iptables. First, install the iptables services package with the following command:

```output
sudo yum –y install iptables-services
```

This package preserves your rules after a system reboot. The information displayed below confirms that the installation is complete:

![installing iptables tool on centos](https://phoenixnap.com/kb/wp-content/uploads/2021/04/install-iptables-centos-1.png)

Enter the following commands to enable and start iptables in CentOS 7:

```output
sudo systemctl enable iptables
sudo systemctl start iptables
```

The status command confirms the status of the application:

```output
sudo systemctl status iptables
```

![status of firewalld in centos 7](https://phoenixnap.com/kb/wp-content/uploads/2021/04/install-enable-iptables-centos.png)

> **Note:**There are two different versions of iptables, for IPv4 and IPv6. The rules we are covering in this Linux iptables tutorial is for IPv4.
>
> To configure iptables for IPv6, you need to use the **iptables6** utility. These two different protocols do not work together and have to be configured independently.

## Basic Syntax for iptables Commands and Options

In general, an iptables command looks as follows:

```output
sudo iptables [option] CHAIN_rule [-j target]
```

Here is a list of some common iptables options:

- **`–A ––append`** – Add a rule to a chain (at the end).
- **`–C ––check`** – Look for a rule that matches the chain’s requirements.
- **`–D ––delete`** – Remove specified rules from a chain.
- **`–F ––flush`** – Remove all rules.
- **`–I ––insert`** – Add a rule to a chain at a given position.
- **`–L ––list`** – Show all rules in a chain.
- **`–N ––new–chain`** – Create a new chain.
- **`–v ––verbose`** – Show more information when using a list option.
- **`–X ––delete–chain`** – Delete the provided chain.

Iptables is case-sensitive, so make sure you’re using the correct options.

## Configure iptables in Linux

By default, these commands affect the **filters** table. If you need to specify a different table, use the **`–t`** option, followed by the name of the table.

### Check Current iptables Status

To view the current set of rules on your server, enter the following in the terminal window:

```output
sudo iptables –L
```

![current status of iptables on linux server](https://phoenixnap.com/kb/wp-content/uploads/2021/04/iptables-l-current-status.png)

The system displays the status of your chains. The output will list three chains:

```output
Chain INPUT (policy ACCEPT)
Chain FORWARD (policy ACCEPT)
Chain OUTPUT (policy ACCEPT) By default, rules do not block any traffic, and everyone is granted access.
```

### Enable Loopback Traffic

It’s safe to allow traffic from your own system (the localhost). Append the **Input** chain by entering the following:

```output
sudo iptables –A INPUT –i lo –j ACCEPT
```

This command configures the firewall to accept traffic for the localhost (**`lo`**) interface (**`-i`**)**.** Now anything originating from your system will pass through your firewall. You need to set this rule to allow applications to talk to the localhost interface.

### Allow Traffic on Specific Ports 

These rules allow traffic on different **ports** you specify using the commands listed below. A port is a communication endpoint specified for a specific type of data.

To allow HTTP web traffic, enter the following command:

```output
sudo iptables –A INPUT –p tcp ––dport 80 –j ACCEPT
```

To allow only incoming SSH (Secure Shell) traffic, enter the following:

```output
sudo iptables –A INPUT –p tcp ––dport 22 –j ACCEPT
```

To allow HTTPS internet traffic, enter the following command:

```output
sudo iptables –A INPUT –p tcp ––dport 443 –j ACCEPT
```

The options work as follows:

- **`–p`** – Check for the specified protocol (**tcp**).
- **`––dport`** – Specify the destination port.
- **`–j jump`** – Take the specified action.

### Control Traffic by IP Address

Use the following command to ACCEPT traffic from a specific IP address.

```output
sudo iptables –A INPUT –s 192.168.0.27 –j ACCEPT
```

Replace the IP address in the command with the IP address you want to allow.

You can also DROP traffic from an IP address:

```output
sudo iptables –A INPUT –s 192.168.0.27 –j DROP
```

You can REJECT traffic from a range of IP addresses, but the command is more complex:

```output
sudo iptables –A INPUT –m iprange ––src–range 192.168.0.1–192.168.0.255 -j REJECT
```

The iptables options we used in the examples work as follows:

- **`–m`** – Match the specified option.
- **`–iprange`** – Tell the system to expect a range of IP addresses instead of a single one.
- **`––src-range`** – Identifies the range of IP addresses.

### Dropping Unwanted Traffic

If you define **dport** iptables firewall rules, you need to prevent unauthorized access by dropping any traffic that comes via other ports:

```output
sudo iptables –A INPUT –j DROP
```

The **`–A`** option appends a new rule to the chain. If any connection comes through ports other than those you defined, it will be dropped.

### Delete a Rule

You can use the **`–F`** option to clear all iptables firewall rules. A more precise method is to delete the line number of a rule.

First, list all rules by entering the following:

```output
sudo iptables –L ––line–numbers
```

![displaying list of iptables firewall rules numbers](https://phoenixnap.com/kb/wp-content/uploads/2021/04/iptables-list-rules.png)

Locate the line of the firewall rule you want to delete and run this command:

```output
sudo iptables –D INPUT <Number>
```

Replace **<\*Number\*>** with the actual rule line number you want to remove.

### Save Your Changes

Iptables does not keep the rules you created when the system reboots. Whenever you configure iptables in Linux, all the changes you make apply only until the first restart.

To save the rules in Debian-based systems, enter:

```output
sudo /sbin/iptables–save
```

To save the rules in Red-Hat based systems, enter:

```output
sudo /sbin/service iptables save
```

The next time your system starts, iptables will automatically reload the firewall rules.



## Conclusion

阅读本Linux iptables教程之后，您应该对iptables如何工作以及如何安装iptables工具有了更好的理解。

您现在还可以为您的Linux系统配置基本的iptables防火墙规则。您可以随意尝试，因为您总是可以删除不需要的规则，或者刷新所有规则并重新开始。

