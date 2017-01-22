---
layout: post
author: Alexander Bischof
authorkey: alexanderbischof
title: How To Use ChronicleMap with JavaEE
description: Overcome classloader problems with a workaround
categories: Java JavaEE ChronicleMap
---
Recently i needed a cache for a JavaEE project with the following requirements *almost zero rampup time, throughput >250000 ops/s and
 kind of big data (>4g)* and since I am a big fan of [Chronicle-Map](https://github.com/OpenHFT/Chronicle-Map) and it covers the requirements
i tried to use it right away. This post describes a failure at deploy time if you use ChronicleMap right away and provides a
solution to overcome this issue.


The following demo repository ([https://github.com/AlexBischof/chroniclemap-wildfly](https://github.com/AlexBischof/chroniclemap-wildfly)) 
contains two maven modules. The first one creates a cache (*MyMap.class*) with a CM containing postalcodes which are persisted into a file (test.dat). 
For demo purposes it only contains 19 samples.

{% highlight java %}
public class MyMap implements AutoCloseable {
    private final ChronicleMap<LongValue, PostalCodeRange> map;
    private LongValue longValue = Values.newHeapInstance(LongValue.class);
    public MyMap(File file) throws IOException {
        map = ChronicleMapBuilder.of(LongValue.class, PostalCodeRange.class).entries(50).createPersistedTo(file);
        PostalCodeRange postalCodeRange = Values.newHeapInstance(PostalCodeRange.class);
        //Creates 19 sample entries
        LongStream.range(1, 20).forEach(value -> {
            longValue.setValue(value);
            postalCodeRange.minCode((int) value);
            postalCodeRange.maxCode((int) (value*42));
            map.put(longValue, postalCodeRange);
        });
    }
    ...snip...
{% endhighlight %} 

Within the second module
i created a JavaEE singleton which simply opens *MyMap*.

{% highlight java %}
@Singleton
@Startup
public class MySingleton {
    @PostConstruct
    public void init() throws Exception {
        File file = new File(System.getProperty("jboss.home.dir") + "/../../../../postalcodes/test.dat");
        try (MyMap myMap = new MyMap(file)) {
            System.out.println(myMap.get(1));
        } 
    }
} 
{% endhighlight %} 
 
Now if you deploy that *WAR* for example with a wildfly (also configured within that module) you will get the following error.

{% highlight text %}
[0m[31m23:51:35,666 ERROR [stderr] (ServerService Thread Pool -- 58) /net/openhft/chronicle/core/values/LongValue$$Heap.java:12: error: cannot find symbol
[0m[31m23:51:35,666 ERROR [stderr] (ServerService Thread Pool -- 58) import net.openhft.chronicle.core.Jvm;
...snip...
[0m[31m23:51:35,728 ERROR [stderr] (ServerService Thread Pool -- 58)   location: class net.openhft.chronicle.core.values.LongValue$$Heap
[0m[31m23:51:35,764 ERROR [stderr] (ServerService Thread Pool -- 58)    net.openhft.chronicle.values.ImplGenerationFailedException: java.lang.ClassNotFoundException: net.openhft.chronicle.core.values.LongValue$$Heap from [Module "deployment.wildfly.war:main" from Service Module Loader]
[0m[31m23:51:35,764 ERROR [stderr] (ServerService Thread Pool -- 58) 	at net.openhft.chronicle.values.ValueModel.createClass(ValueModel.java:349)
[0m[31m23:51:35,764 ERROR [stderr] (ServerService Thread Pool -- 58) 	at net.openhft.chronicle.values.ValueModel.createHeapClass(ValueModel.java:326)
{% endhighlight %}

The problem is relatively simple. CM does some dynamic compilation under the hood and this results in problems with the classloader of the application server. Unfortunately there
is no way (at least not known to me) to configure the class loader in that way the application server can be satisfied. But there is a kind of messy workaround which involves 
the following manual steps:

 - Set system property **chronicle.values.dumpCode=true** during CM file creation. Now you can see all the generated classes on System.out
 - Manually seperate the classes and copy that output into the respective packages (e.g. net.openhft.chronicle.hash.VanillaGlobalMutableState$$Native)

That way you kind of pollute your source code but it works without failures. The following screenshot displays the generated classes
in the demo project.

<p align="center"><img width="30%" height="30%" src="{{site.baseurl}}/images/2016/2016-05-16-generated_classes.png"/></p>

