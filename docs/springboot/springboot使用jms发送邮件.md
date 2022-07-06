## 一、导入依赖

```xml
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-mail</artifactId>
    </dependency>
```



## 二、配置

```yaml
spring:
  mail:
    # 配置 SMTP 服务器地址
    host: smtp.qq.com
    # 发送者邮箱
    username: 自己的qq邮箱
    # 配置密码，注意不是真正的密码，而是刚刚申请到的授权码
    password: tksntpyyovoebcai
    # 端口号465或587
    port: 587
    # 默认的邮件编码为UTF-8
    default-encoding: UTF-8
    # 配置SSL 加密工厂
    properties:
      mail:
        smtp:
          socketFactoryClass: javax.net.ssl.SSLSocketFactory
        # 表示开启 DEBUG 模式，这样，邮件发送过程的日志会在控制台打印出来，方便排查错误
        debug: true
```

注意：spring支持的配置只能设置一个邮件服务

## 三、使用

Springboot融合了mail功能，导入依赖后就可以直接使用。

#### 1、发送简单邮件（不带附件，不带格式）

```java
@SpringBootTest
class SpringbootApplicationTests {
    
    @Autowired
    JavaMailSender javaMailSender;
    
    @Test
    void sendMailTest() throws Exception {
        SimpleMailMessage message=new SimpleMailMessage();
        message.setText("内容");
        message.setSubject("主题");
        message.setTo("收件人");
        message.setCc("抄送人");
        message.setBcc("密送人");
        javaMailSender.send(message);
    }

}
```



#### 2、发送带Html格式的附件（多个收件人）

```java
@SpringBootTest
class SpringbootApplicationTests {

    @Autowired
    JavaMailSender javaMailSender;
    
    @Test
    void sendMailTest(List<String> mailList) throws Exception {
        MimeMessage mailMessage=javaMailSender.createMimeMessage();
        //需要借助Helper类
        MimeMessageHelper helper=new MimeMessageHelper(mailMessage);
        String context="<b>尊敬的用户：</b>"
            + "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
            + "您好，管理员已为你申请了新的账号，"
            + "请您尽快通过<a href=\"http://www.liwz.top/\">链接</a>登录系统。"
            + "<br>修改密码并完善你的个人信息。"
            +"<br><br><br><b>员工管理系统<br>Li，Wan Zhi</b>";
        
        try {
            //构造发送人数组
            InternetAddress[] sendTo = new InternetAddress[mailList.size()];
            for (int i = 0; i < mailList.size(); i++) {
                log.info("发送给：" + mailList.get(i));
                sendTo[i] = new InternetAddress(mailList.get(i));
            }
            helper.setTo(sendTo);
            
            helper.setFrom("发送人");
            helper.setTo("收件人");
            helper.setBcc("密送人");
            helper.setSubject("主题");
            helper.setSentDate(new Date());//发送时间
            helper.setText(context,true); //第一个参数要发送的内容，第二个参数是不是Html格式。

            javaMailSender.send(mailMessage);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

}
```



### 3、发送带附件的邮件

```java
@SpringBootTest
class SpringbootApplicationTests {
    @Autowired
    JavaMailSender javaMailSender;
    
    @Test
    void sendMailTest() throws Exception {
        MimeMessage mimeMessage = javaMailSender.createMimeMessage();
        // true表示构建一个可以带附件的邮件对象
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage,true);

        helper.setSubject("这是一封测试邮件");
        helper.setFrom("97******9@qq.com");
        helper.setTo("10*****16@qq.com");
        //helper.setCc("37xxxxx37@qq.com");
        //helper.setBcc("14xxxxx098@qq.com");
        helper.setSentDate(new Date());
        helper.setText("这是测试邮件的正文");
        // 第一个参数是自定义的名称，后缀需要加上，第二个参数是文件的位置
        helper.addAttachment("资料.xlsx",new File("/Users/gamedev/Desktop/测试数据 2.xlsx"));
        javaMailSender.send(mimeMessage);
    }

}

```



### 4、配置多个邮件服务器

因为 springboot 内置支持的mail只能添加一个邮件服务器，所以这里自定义 `MailProperty` 实体类，然后放到容器中，需要用时获取设置相应的配置。

1. 新增配置如下：

    ```yaml
    sender-email:
      mail:
        mail-0:
          # 邮件服务器的SMTP地址，可选，默认为smtp.<发件人邮箱后缀>
          host: 10.22.34.66
          # 邮件服务器的SMTP端口，可选，默认25
          #      port: 25
          # 发件人（必须正确，否则发送失败）
          from: test@qq.com
          # 密码（注意，某些邮箱需要为SMTP服务单独设置授权码）
          pass: fangxu199502.
          # 重试次数
          retryCount: 10
        mail-1:
          # 邮件服务器的SMTP地址，可选，默认为smtp.<发件人邮箱后缀>
          host: smtp.126.com
          # 邮件服务器的SMTP端口，可选，默认25
          port: 25
          # 发件人（必须正确，否则发送失败）
          from: test@126.com
          # 密码（注意，某些邮箱需要为SMTP服务单独设置授权码）
          pass: UKPFAMAOAXKFCRAA
          # 重试次数
          retryCount: 10
    ```

2. 新增实体类如下

    ```java
    @Component
    @ConfiguraionProperties(prefix="sender-email")
    public class EmailProperties{
        private Map<String, Map<String, String>> mail;
        
        public Map<String, Map<String, String>> getMail(){
            return mail;
        }
        
        public Map<String, Map<String, String>> setMail(){
            this.mail = mail;
            return this.mail;
        }
    }
    ```

3. 在使用的地方注入自定义 mail 配置

    ```java
    @Autowired
    private JavaMailSender jms;
    
    @Autowired
    private EmailProperties emailProperties;
    ```

   

4. 使用不同配置进行邮件发送

    ```java
    private Boolean sendMail(List<String> emailList, Integer notifyMethod, MailSendDTO mailSendDTO) {
            if (emailList.isEmpty()) return true;
    
            if (mailSendDTO == null) {
                throw new BusinessException("邮件服务器不能为空");
            }
    
            // 设置邮件服务器
            Map email = emailProperties.getMail().get("mail-" + notifyMethod);
            JavaMailSenderImpl jmsi = (JavaMailSenderImpl) jms;
    
            jmsi.setHost((String) email.get("host"));
            jmsi.setPort(Integer.parseInt((String) email.get("port")));
            jmsi.setPassword((String) email.get("pass"));
            jmsi.setUsername((String) email.get("from"));
    
            MimeMessage mailMessage = javaMailSender.createMimeMessage();
            try {
                MimeMessageHelper helper = new MimeMessageHelper(mailMessage);
                //构造发送人
                InternetAddress[] sendTo = new InternetAddress[emailList.size()];
                for (int i = 0; i < emailList.size(); i++) {
                    log.info("发送给：" + emailList.get(i));
                    sendTo[i] = new InternetAddress(emailList.get(i));
                }
                mailMessage.setFrom((String) email.get("from"));
                helper.setTo(sendTo);
                helper.setSubject(mailSendDTO.getTitle());
                helper.setSentDate(new Date());
                helper.setText(mailSendDTO.getContent(), true);
                jmsi.send(mailMessage);
                return true;
            } catch (MessagingException e){
                e.printStackTrace();
            }
    ```