# 一次性工作排程——at



## 啓動

```bash
systemctl restart atd  # 重啓
systemctl enable atd  # 開機自啓動
systemctl status atd  # 查看atd狀態
```



## 權限

只有 root 和 /etc/at.allow 中的用戶可執行



## 使用

範例一：5分鐘後，將/root/.bashrc寄給root

```bash
[root@sutdy ~] at now + 5 minutes
at> /bin/mail -s "testing at job" root < /root/.bashrc
at> <EOF>  # [Ctrl] + d
```



範例二：查看job內容

```bash
 atq  # 查看待執行job
 at -c job號
```



範例三：定時關機

```bash
[root@study ~]# at 23:00 2015-08-04
at> /bin/sync
at> /bin/sync
at> /sbin/shutdown -h now
at> <EOT>
job 3 at Tue Aug 4 23:00:00 2015
```



範例四：刪除job計劃

```bash
atrm job號
```



範例五：空閒時執行updatedb，利用 <span style="color:#ea4355">batch</span>

```bash
[root@study ~]# batch
at> /usr/bin/updatedb
at> <EOT>
job 4 at Thu Jul 30 19:57:00 2015
```







# 循環性工作排程——crontab



## 權限

只有 root 和 /etc/at.allow 中的用戶可執行



## 使用

範例一：用dmtsai的身份在每天的12:00發信給自己

```bash
[dmtsai@study ~]$ crontab -e
# 此时会进入 vi 的编辑画面让您编辑工作！注意到，每项工作都是一行。
0 12 * * * mail -s "at 12:00" dmtsai < /home/dmtsai/.bashrc
#分 时 日 月 周 |<==============指令串========================>|
```



範例二：在每年5月1日23:59發一封信給 kiki，信內容在/home/dmtsai/lover.txt

```bash
59 23 1 5 * mail kiki < /home/dmtsai/lover.txt
```



範例三：每5分鐘執行 /home/dmtsai/test.sh 一次

```bash
*/5 * * * * /home/dmtsai/test.sh
```



範例四：每週星期六下午16:30發郵件給朋友

```bash
30 16 * * 5 mail friend@his.server.name < /home/dmtsai/friend.txt
```



範例五：查看當前用戶例行性工作

```bash
crontab -l
```



範例六：移除所有工作安排

```bash
crontab -r
```



範例七：移除某一項工作

使用 crontab -e 進入編輯頁面，刪除任務所在行。



## 总结与建议

* 个人化的行为使用『crontab -e 』：如果你是依据个人需求来建立的例行工作排程，建议直接使用crontab -e 来建立你的工作排程较佳！ 这样也能保障你的指令行为不会被大家看到（/etc/crontab 是大家都能读取的权限喔！)；

* 系统维护管理使用『vim /etc/crontab 』：如果你这个例行工作排程是系统的重要工作，为了让自己管理方 便，同时容易追踪，建议直接写入/etc/crontab 较佳！

* 自己开发软件使用『vim /etc/cron.d/newfile 』：如果你是想要自己开发软件，那当然最好就是使用全新的配置文件，并且放置于/etc/cron.d/ 目录内即可。
* 固定每小时、每日、每周、每天执行的特别工作：如果与系统维护有关，还是建议放置到/etc/crontab 中来 集中管理较好。如果想要偷懒，或者是一定要在某个周期内进行的任务，也可以放置到上面谈到的几个目录中，直接写入指令即可！



> 注意：
>
> 如果你每个周日的需要执行的动作是放置于/etc/crontab 的话，那么该动作只要过期了就过期了，并不会被抓回来重新执行。
>
> 但如果是放置在/etc/cron.weekly/ 目录下，那么该工作就会定期， 几乎一定会在一周内执行一次～如果你关机超过一周，那么一开机后的数个小时内，该工作就会主动的被执行喔！