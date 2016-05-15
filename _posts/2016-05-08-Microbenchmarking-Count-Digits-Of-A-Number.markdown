---
layout: post
author: Alexander Bischof
authorkey: alexanderbischof
title: Micro-Benchmarking with JMH (Update)
description: Calculate digits of a number
categories: Java JMH Benchmarck
---
*After it was mentioned out (thx Fabian Lange) that my benchmark was flawed i have done some additional research on that
matter and corrected my benchmark. I also add another method to calculate which is mentioned [here](http://stackoverflow.com/questions/1306727/way-to-get-number-of-digits-in-an-int/1308407#1308407).   
As lesson learned: Use constant data for alle benchmarks and use blackholes or method returns to prevent JIT optimizations like dead code elimination.*

I have been working with [JMH](http://openjdk.java.net/projects/code-tools/jmh) for 4 weeks now and this week we had a 
small problem [@SiteOS](http://www.siteos.de) for which it is perfect. The question was **what is the fastest way to calculate
the digits of a number** which is shown in this post.

I considered the following four solutions 

 - Conversion to String and make use of *String.length*
 - Division by ten while result is greater zero
 - Use the *Math.log10*
 - Use an binary if else construct
 
The *JMH* Benchmark is written within a couple of minutes

{% highlight java %}
@State(Scope.Thread)
public class NumberDigitsBenchmark {
    private int[] data;
    @Setup(Level.Trial)
    public void init() throws IOException {
        Random random = new Random();
        Path path = get("/tmp/numbers.txt");
        if (!exists(path)) {
            write(path,
                    (Iterable<String>) random.ints().filter(i -> i > 0).limit(1_000_000).mapToObj(String::valueOf)::iterator);
        }
        data = readAllLines(path).stream().mapToInt(Integer::valueOf).toArray();
    }
    @Benchmark
    public void log(Blackhole bh) throws InterruptedException {
        for (int nr : data) {
            bh.consume((int) (log10(nr) + 1));
        }
    }
    @Benchmark
    public void viaString(Blackhole bh) throws InterruptedException {
        for (int nr : data) {
            bh.consume(("" + nr).length());
        }
    }
    @Benchmark
    public void divide(Blackhole bh) throws InterruptedException, IOException {
        for (int nr : data) {
            bh.consume(division(nr));
        }
    }
    private int division(int nr) {
        int digits = 0;
        while (nr > 0) {
            digits++;
            nr /= 10;
        }
        return digits;
    }
    @Benchmark
    public void theIfWay(Blackhole bh) {
        for (int nr : data) {
            bh.consume(ifSolution(nr));
        }
    }
    private static int ifSolution(int n) {
        if (n < 100000) {
            // 5 or less
            if (n < 100) {
                // 1 or 2
                if (n < 10)
                    return 1;
                else
                    return 2;
            } else {
                // 3 or 4 or 5
                if (n < 1000)
                    return 3;
                else {
                    // 4 or 5
                    if (n < 10000)
                        return 4;
                    else
                        return 5;
                }
            }
        } else {
            // 6 or more
            if (n < 10000000) {
                // 6 or 7
                if (n < 1000000)
                    return 6;
                else
                    return 7;
            } else {
                // 8 to 10
                if (n < 100000000)
                    return 8;
                else {
                    // 9 or 10
                    if (n < 1000000000)
                        return 9;
                    else
                        return 10;
                }
            }
        }
    }
    public static void main(String[] args) throws RunnerException, IOException {
        Options options = new OptionsBuilder()
                .include(NumberDigitsBenchmark.class.getSimpleName()).forks(1).build();
        new Runner(options).run();
    }
}
{% endhighlight %}

On my machine the if-else construct was the fastest solution but keep in mind that this implementation is an integer
specialized version. So if you want to use it for longs you have to code a little bit more.

{% highlight text %}
Benchmark                   Mode    Cnt         Score         Error  Units
NumberDigitsBenchmark.divide     thrpt   20   40.986 ± 1.029  ops/s
NumberDigitsBenchmark.log        thrpt   20   31.435 ± 2.213  ops/s
NumberDigitsBenchmark.theIfWay   thrpt   20  118.407 ± 7.492  ops/s
NumberDigitsBenchmark.viaString  thrpt   20   29.617 ± 1.613  ops/s
{% endhighlight %}

