---
layout: post
author: Alexander Bischof
authorkey: alexanderbischof
title: AngularJS2 JAX-RS Example
description: How to deal with JAAS and CORS
categories: Java JavaEE AngularJS2
---
The first part of this post describes how you can get a *JAX-RS* endpoint running with an *AngularJS2* app and
afterwards made some changes to get it running with basic authentication and *CORS*.

The following *JavaEE* backend is pretty standard (except of the definition of **Application** within
the resource which is usually done in a seperate class).
{% highlight java %}
@Path("/")
@ApplicationPath("/rest")
public class BlogResource extends Application
{
	@GET
	public JsonArray blog()
	{
		return
				createArrayBuilder()
						.add(createObjectBuilder().add("name", "blog").build())
						.add(createObjectBuilder().add("name", "blog2").build())
						.build();
	}
}
{% endhighlight %}

{% highlight shell %}
curl http://localhost:8080/blog/rest
[{"name":"blog"},{"name":"blog2"}]
{% endhighlight %}

This AngularJS2 app is basically a small variation of the ([AngularJS2 Quickstart](https://github.com/angular/quickstart))
and only displays the data from the **JAX-RS** endpoint.

{% highlight typescript %}
@Component({
    selector: 'my-app',
    template: '<h1>Hello {{name}}</h1><div *ngFor="let blog of blogs">{{blog.name}}</div>',
    providers: [ RestConfig  ]
})
export class AppComponent implements OnInit {
    name = 'Juhu'
    blogs: Blog[] = [];

    constructor(private http: Http, private restConfig: RestConfig) { }

    ngOnInit() {
      this.http.get(this.restConfig.getUrl())
                  .toPromise()
                  .then(r => r.json())
                  .then(r => this.blogs = r);
    }
}
{% endhighlight %}

{% highlight typescript %}
@Injectable()
export class RestConfig {
    getUrl() {
        return 'http://127.0.0.1:8080/blog/rest';
    }
}
{% endhighlight %}

If you now want to use basis authentication you have to do the following changes

Define a **Http** header with the necessary information
{% highlight typescript %}
@Injectable()
export class RestConfig {
    getUrl() {
        return 'http://127.0.0.1:8080/blog/rest';
    }

    getHeaders() {
        let username: string = 'hans';
        let password: string = 'knaut';
        let headers = new Headers();
        headers.append("Authorization", "Basic " + btoa(username + ":" + password));
        headers.append("Content-Type", "application/*+json");
        return headers;
    }
}
{% endhighlight %}

Pass it to the **Http** request
{% highlight typescript %}
export class AppComponent implements OnInit {
    ..snip..
    ngOnInit() {
      this.http.get(this.restConfig.getUrl(), { headers: this.restConfig.getHeaders() })
                  .toPromise()
                  .then(r => r.json())
                  .then(r => this.blogs = r);
    }
}
{% endhighlight %}

Add a **JavaEE** *CORS* Filter
{% highlight java %}
@Provider
public class CORSFilter implements ContainerResponseFilter
{
	public void filter(ContainerRequestContext requestContext, ContainerResponseContext responseContext)
			throws IOException
	{
		responseContext.getHeaders().add("Access-Control-Allow-Origin", "*");
		responseContext.getHeaders().add("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
		responseContext.getHeaders().add("Access-Control-Max-Age", "-1");
		responseContext.getHeaders().add("Access-Control-Allow-Headers", "accept, authorization, content-type");
	}
}
{% endhighlight %}

Omit **Http-Method** *Option* for the secure **JAX-RS** endpoint otherwise you get a 401 for the **preflight** request
{% highlight xml %}
...snip...
<web-resource-collection>
    <web-resource-name>All resources</web-resource-name>
    <url-pattern>/*</url-pattern>
    <http-method-omission>OPTIONS</http-method-omission>
</web-resource-collection>
...snip...
{% endhighlight %}

The complete example can be found ([here](https://github.com/AlexBischof/angular2javaeeauth)).
