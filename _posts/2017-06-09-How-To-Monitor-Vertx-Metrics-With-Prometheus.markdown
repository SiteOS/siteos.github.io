---
layout: post
author: Alexander Bischof
authorkey: alexanderbischof
title: How To Monitor Vertx Metrics with Prometheus
categories: Java Vertx Prometheus Monitoring
---
This short article serves as a Java quickstart for getting [Vert.x](http://vertx.io) metrics monitored with
[Prometheus](https://prometheus.io).

### pom.xml

{% highlight xml %}
<dependency>
    <groupId>io.vertx</groupId>
    <artifactId>vertx-dropwizard-metrics</artifactId>
</dependency>
<dependency>
    <groupId>io.prometheus</groupId>
    <artifactId>simpleclient_dropwizard</artifactId>
    <version>0.0.23</version>
</dependency>
<dependency>
    <groupId>io.prometheus</groupId>
    <artifactId>client</artifactId>
    <version>0.0.10</version>
</dependency>
<dependency>
    <groupId>io.prometheus</groupId>
    <artifactId>simpleclient_vertx</artifactId>
    <version>0.0.23</version>
</dependency>
{% endhighlight %}

### Verticle-Snippet

{% highlight java %}
MetricRegistry metricRegistry = SharedMetricRegistries.getOrCreate("exported");
defaultRegistry.register(new DropwizardExports(metricRegistry));

//Bind metrics handler to /metrics
Router router = Router.router(vertx);
router.get("/metrics").handler(new MetricsHandler());

//Start httpserver on localhost:8080
vertx.createHttpServer().requestHandler(router::accept).listen(8080);

//Increase counter every second
vertx.setPeriodic(1_000L, e -> metricRegistry.counter("testCounter").inc());
{% endhighlight %}

### Example

<img src="{{site.baseurl}}/images/2017/2017-06-09-prometheus.png"/>

### Links

- [GitHub](https://github.com/AlexBischof/vertx-prometheus-example)
- [Scale-Example of Jochen Mader](https://github.com/codepitbull/meetup-vertx-scala-demo/blob/master/src/main/scala/io/vertx/scala/meetupdemo/ex5metrics/MetricsVerticle.scala)
