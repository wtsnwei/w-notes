#### 一、准备

案例：在一定时间内限制接口请求次数。

需要用到的知识：注解、AOP、ExpiringMap（带有有效期的 Map）

思路：

1. 自定义注解，把注解添加到我们的接口上。
2. 定义一个切面，执行方法前去 ExpiringMap 查询该 IP 在规定时间内请求了多少次，如超过次数则直接返回请求失败。



#### 二、添加依赖

```java
<!-- AOP依赖 -->
<dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-aop</artifactId>
</dependency>
    
<!-- ExpiringMap依赖 -->
<dependency>
            <groupId>net.jodah</groupId>
            <artifactId>expiringmap</artifactId>
            <version>0.5.10</version>
</dependency>
```



#### 三、定义注解 `@LimitRequest`

```java
@Documented
@Target(ElementType.METHOD) // 说明该注解只能放在方法上面
@Retention(RetentionPolicy.RUNTIME)
public @interface LimitRequest {
    long time() default 6000; // 限制时间 单位：毫秒
    int count() default 1; // 允许请求的次数
}
```



#### 四、使用 AOP 实现

```java
@Aspect
@Component
public class LimitRequestAspect {
 
    private static ConcurrentHashMap<String, ExpiringMap<String, Integer>> book = new ConcurrentHashMap<>();
 
    // 定义切点
    // 让所有有@LimitRequest注解的方法都执行切面方法
    @Pointcut("@annotation(limitRequest)")
    public void excudeService(LimitRequest limitRequest) {
    }
 
    @Around("excudeService(limitRequest)")
    public Object doAround(ProceedingJoinPoint pjp, LimitRequest limitRequest) throws Throwable {
 
        // 获得request对象
        RequestAttributes ra = RequestContextHolder.getRequestAttributes();
        ServletRequestAttributes sra = (ServletRequestAttributes) ra;
        HttpServletRequest request = sra.getRequest();
        
        // 获取Map对象， 如果没有则返回默认值
        // 第一个参数是key， 第二个参数是默认值
        ExpiringMap<String, Integer> uc = book.getOrDefault(request.getRequestURI(), ExpiringMap.builder().variableExpiration().build());
        Integer uCount = uc.getOrDefault(request.getRemoteAddr(), 0);
 
 
 
        if (uCount >= limitRequest.count()) { // 超过次数，不执行目标方法
            return "接口请求超过次数";
        } else if (uCount == 0){ // 第一次请求时，设置有效时间
//            /** Expires entries based on when they were last accessed */
//            ACCESSED,
//            /** Expires entries based on when they were created */
//            CREATED;
            uc.put(request.getRemoteAddr(), uCount + 1, ExpirationPolicy.CREATED, limitRequest.time(), TimeUnit.MILLISECONDS);
        } else { // 未超过次数， 记录加一
            uc.put(request.getRemoteAddr(), uCount + 1);
        }
        book.put(request.getRequestURI(), uc);
 
        // 继续执行被拦截方法
        return pjp.proceed();
    }
 
 
}
```

第一个静态Map是多线程安全的 Map（ConcurrentHashMap），它的 key 是接口对于的 url，它的 value 是一个多线程安全且键值对是有有效期的 Map（ExpiringMap）。

ExpiringMap 的 key 是请求的 ip 地址，value 是已经请求的次数。

ExpiringMap 更多的使用方法可以参考：https://github.com/jhalterman/expiringmap
