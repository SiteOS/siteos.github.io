---
layout: post
author: Alexander Bischof
authorkey: alexanderbischof
title: Micro-Benchmarking with JMH
description: Calculate digits of a number
categories: Java JMH Benchmarck
---
I have been working with [JMH](http://openjdk.java.net/projects/code-tools/jmh) for 4 weeks now and this week we had a 
small problem [@SITEOS](http://www.siteos.de) for which it is perfect. The question was **what is the fastest way to calculate
the digits of a number** which is shown in this post.

The three naive solutions were 

 - Conversion to String and make use of *String.length*
 - Division by ten while result is greater zero
 - Use the *Math.log10*
 
The *JMH* Benchmark is written within a couple of minutes

{% highlight java %}
@State(Scope.Thread)
public class NumberDigitsBenchmark {
    private Random random;
    @Setup(Level.Trial)
    public void init() throws IOException {
        random = new Random();
    }
    @Benchmark
    public void log() throws InterruptedException {
        double digits = log10(abs(random.nextInt()))+1;
    }
    @Benchmark
    public void viaString() throws InterruptedException {
        int digits = valueOf(abs(random.nextInt())).length();
    }
    @Benchmark
    public void division() throws InterruptedException, IOException {
        int i = abs(random.nextInt());
        int digits = 0;
        while (i>0){
            digits++;
            i/=10;
        }
    }
}
{% endhighlight %}

And the winner is...

{% highlight text %}
Benchmark                   Mode    Cnt         Score         Error  Units
NumberDigitsBenchmark.division     thrpt   20  36736065.552 ± 2660920.537  ops/s
NumberDigitsBenchmark.log          thrpt   20  96100324.274 ± 1414190.490  ops/s
NumberDigitsBenchmark.viaString    thrpt   20  22498305.716 ±  147162.060  ops/s
{% endhighlight %}

