这里使用 spring 中的 `BeanUtils`

```java
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.BeanUtils;

public class BeanCopyUtils {

    private BeanCopyUtils() {}

    /**
     * 单个bean的拷贝
     * @param source: 源bean
     * @param clazz: 目标bean的字节码对象
     * @param <V>: 范型，目标bean的类型
     * @return 拷贝后的目标bean
     */
    public static <V> V copyBean(Object source, Class<V> clazz){
        // 创建目标对象
        V result = null;
        try {
            result = clazz.newInstance();
            BeanUtils.copyProperties(source, result);
        } catch (Exception e){
            e.printStackTrace();
        }

        return result;
    }

    /**
     * 对Bean List的拷贝
     * @param source: 源bean的List
     * @param clazz: 目标bean的字节码对象
     * @param <T>: 范型，源bean的类型
     * @param <V>: 范型，目标bean的类型
     * @return 拷贝后目标bean的List
     */
    public static <T,V> List<V> copyBeanList(List<T> source, Class<V> clazz){
        return source.stream()
                .map(o->copyBean(o, clazz))
                .collect(Collectors.toList());
    }
}

```

