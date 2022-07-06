## 关于 Long 转 String 和 js 丢失精度截断的问题

#### 背景

Java 后端的 `Long(long)` 类型字段，在 web 接口返回这种类型的值给前端时，会发生截断（即 js 会精度丢失，因为后端的 `Long` 的最大值超过了前端 js 能表示的值）

哪些情况下发生截断：

* 如果前端不是用 js 框架则不会截断，比如用 postman 调用就不会截断，浏览器地址栏直接请求也不会截断
* 前端用 js 类型的框架可能会发生截断，但是只有在实际值超过js的最大范围的时候才会截断
* 截断的一般特征是 000 结尾，比如 9223372036854776000
* 如果 `Long longValue` 实际值没有超过前端 js 的限制，也不会出现截断

#### 如何解决

1. 建议项目代码编写的一开始就用 `String` 类型不要用 `Long`

2. 如果是接手的代码，并且按 1 的方法改造不切实际，可以配置全局 `Long` 转 `String`

3. 用注解，如下（其实第2点会有问题，我在实际项目中遇到过不生效的情况。原来生效后来可能是jar包版本升级了或者其他未知的原因导致了问题）

   ```java
   @JsonSerialize(using = ToStringSerializer.class)
   ```

   如上，注解加在想要转字串的字段上，比如 `Long`、`long`、`Integer`、`int` 等字段上

   ```java
   // 上述详细的包名是
   import com.fasterxml.jackson.databind.annotation.JsonSerialize;
   import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;
   ```

#### 总结

总体来说我觉得 **2** 中方法应该是最好的。

如果实在没办法用 **3** 也不错，用 **3** 的话不需要改太多代码。

**1** 这种虽然最彻底，改动也大，容易引发新的 bug，虽然 `Long` 改 `String` 这种会触发编译上的报错，提示你需要改动的地方，但是也有一些 bug 很隐蔽。



----

#### 全局 Long 转 String 的配置

#### 1、配置一

```java
@Configuration
public class LongToStringConfig {
    @Bean
    public MappingJackson2HttpMessageConverter jackson2HttpMessageConverter() {
        MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
        ObjectMapper mapper = new ObjectMapper();
        SimpleModule simpleModule = new SimpleModule();
        simpleModule.addSerializer(Long.class, ToStringSerializer.instance);
        simpleModule.addSerializer(Long.TYPE, ToStringSerializer.instance);
        mapper.registerModule(simpleModule);
        converter.setObjectMapper(mapper);
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        return converter;
    }
}
```

实测可以将 `Long`、`long` 转字串，对于 `Integer`、`int` 等其他类型不会



#### 2、配置二

```java
@Configuration
public class LongToStringConfig {
    @Bean
    public MappingJackson2HttpMessageConverter jackson2HttpMessageConverter() {
        MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
        ObjectMapper mapper = new ObjectMapper();
        SimpleModule simpleModule = new SimpleModule();
        simpleModule.addSerializer(Long.class, ToStringSerializer.instance);
        simpleModule.addSerializer(Long.TYPE, ToStringSerializer.instance);
        mapper.registerModule(simpleModule);
        converter.setObjectMapper(mapper);
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        return converter;
    }
}

```

 这种写法也是可以的 