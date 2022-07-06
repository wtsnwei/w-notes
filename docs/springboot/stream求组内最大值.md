有如下 `List`：

```java
List<Car> carsDetails = UserDB.getCarsDetails();
```

## 需求一

先对集合进行分组，然后求组内的最大值。

### 解决方案

```java
Map<String, Car> mostExpensives = carsDetails.stream()
    .collect(
        Collectors.toMap(
            Car::getMake, 
            Function.identity(),
            BinaryOperator.maxBy(Comparator.comparing(Car::getPrice))
            )
        );

mostExpensives.forEach((make,car) -> System.out.println(make+" "+car));
```



## 需求二

先对集合进行分组，然后求组内的最大和最小值。

### 解决方案1

```java
Map<String, List<Car>> mostExpensivesAndCheapest = carsDetails.stream()
        .collect(
            Collectors.toMap(
                Car::getMake,
                car -> Arrays.asList(car, car),
                (l1, l2) -> Arrays.asList(
                    (l1.get(0).getPrice() > l2.get(0).getPrice() ? l2 : l1).get(0),
                    (l1.get(1).getPrice() < l2.get(1).getPrice() ? l2 : l1).get(1)
                )
            )
        );

mostExpensivesAndCheapest.forEach(
    (make, cars) -> System.out.println(make + " cheapest: " + cars.get(0) + " most expensive: " + cars.get(1))
);
```

### 解决方案2

```java
/**
 * Like {@code DoubleSummaryStatistics}, {@code IntSummaryStatistics}, and
 * {@code LongSummaryStatistics}, but for an arbitrary type {@code T}.
 */
public class SummaryStatistics<T> implements Consumer<T> {
    /**
     * Collect to a {@code SummaryStatistics} for natural order.
     */
    public static <T extends Comparable<? super T>> Collector<T, ?, SummaryStatistics<T>> statistics() {
        return statistics(Comparator.<T>naturalOrder());
    }

    /**
     * Collect to a {@code SummaryStatistics} using the specified comparator.
     */
    public static <T> Collector<T, ?, SummaryStatistics<T>> statistics(Comparator<T> comparator) {
        Objects.requireNonNull(comparator);
        return Collector.of(() -> new SummaryStatistics<>(comparator),
                            SummaryStatistics::accept, SummaryStatistics::merge);
    }

    private final Comparator<T> c;
    private T min, max;
    private long count;
    public SummaryStatistics(Comparator<T> comparator) {
        c = Objects.requireNonNull(comparator);
    }

    public void accept(T t) {
        if (count == 0) {
            count = 1;
            min = t;
            max = t;
        } else {
            if (c.compare(min, t) > 0) min = t;
            if (c.compare(max, t) < 0) max = t;
            count++;
        }
    }
    public SummaryStatistics<T> merge(SummaryStatistics<T> s) {
        if (s.count > 0) {
            if (count == 0) {
                count = s.count;
                min = s.min;
                max = s.max;
            } else {
                if (c.compare(min, s.min) > 0)
                    min = s.min;
                if (c.compare(max, s.max) < 0)
                    max = s.max;
                count += s.count;
            }
        }
        return this;
    }

    public long getCount() {
        return count;
    }

    public T getMin() {
        return min;
    }

    public T getMax() {
        return max;
    }

    @Override
    public String toString() {
        return count == 0 ? "empty" : (count + " elements between " + min + " and " + max);
    }
}
```

将此基础添加到代码库后，您可以像这样使用它。

```java
Map<String, SummaryStatistics<Car>> mostExpensives = carsDetails.stream()
        .collect(
            Collectors.groupingBy(
                Car::getMake,
                SummaryStatistics.statistics(Comparator.comparing(Car::getPrice))
                )
            );
mostExpensives.forEach((make, cars) -> System.out.println(make + ": " + cars));
```

如果 `getPrice` 返回 `double`，则使用 `Comparator.comparingDouble(Car::getPrice)` 而不是 `Comparator.comparing(Car::getPrice)` 可能更有效。
