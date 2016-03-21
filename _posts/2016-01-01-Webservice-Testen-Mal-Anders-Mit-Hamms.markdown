---
layout: post
author: Alexander Bischof
authorkey: alexanderbischof
title: "Webservice Testen mal anders mit Hamms"
categories: Testing HTTP Microservice Hamms
---
Vor kurzem las ich im Java Magazin *11/2015* den Artikel **Fundierte Entscheidungen treffen können**, in dem 
 beschrieben wird, worauf man bei analysierbaren Systemen achten kann/sollte. Dabei ist ein wichtiger Bestandteil und Treiber
 immer auch die Architektur, die sich im Service Layer zumeist in Backend- und Integration-Layer unterteilen lässt, wie in 
 Abbildung 1 aufgezeigt wird.
 
<p align="center"><img src="{{site.baseurl}}/images/2016/2016-01-01-hamms_design.png"/></p>
  
Der **Backend-Layer** und der **Application Error Catalogue** werden dabei oft mit Unit und Integrationstest abgetestet, was sich im 
Java/JavaEE Umfeld durch z.B. [JUnit](www.junit.org) und [Arquillian](www.arquillian.org) manifestiert. Auch der **Integration-Layer**
ist in vielen Projekten fachlich gut durch z.B. Akzeptanztests abgetestet. Aber was macht man eigentlich mit dem dazugehörigen 
**Service Error Catalogue**?   
Meiner Erfahrung nach ist er in vielen Projekten gar nicht vorhanden, was z.T. aber auch daran liegt, dass dieser technologieabhängig ist. 
Zum Beispiel wird dieser bei einer EJB-Remote Schnittstelle deutlich anders aussehen, als bei einem ReST-Service. Aber schaut man z.B. auf
 Webservices, so ist vielen auch gar nicht bewusst, was zwischen einem HTTP-Client und einem -Server alles schiefgehen kann. Dass das
aus Komplexitätsgründen z.T. für die Entwicklung gewollt ist, sollte jedem klar sein. Möchte man sein System jedoch richtig kennen, wird man um
das Vorhandensein und das Testen eines **Service Error Catalogues** nicht herumkommen. Wie das
 mittels [**Hamms**](https://github.com/kevinburke/hamms) im Java-Umfeld erfolgen kann, wird im weiteren Artikel gezeigt.

## Installation Hamms

Bei [**Hamms**](https://github.com/kevinburke/hamms) handelt es sich um einen in Python geschriebenen HTTP-Server, der auf verschiedenen
 Ports (aktuell 5000-5016) bestimmte fehlerhafte Verhalten anbietet. Zum Beispiel: 
 
 - TCP Reset
 - Sendet jede 5.Sekunde 1 Byte zurück
 - Sendet falschen Responsecode
 - Sendet erst ab x.Request

Die vollständige Port-Auflistung inklusiver URL Beschreibung findet man auf der [Hamms-GitHubPage](https://github.com/kevinburke/hamms).
Die Installation von Hamms kann auf zwei Wegen erfolgen:  
{% highlight bash %}pip install hamms{%endhighlight%}
oder 
{% highlight bash %}git clone https://github.com/kevinburke/hamms.git{%endhighlight%}

Über folgenden Befehl kann *Hamms* jetzt gestartet werden und steht damit für Tests zur Verfügung.

{% highlight bash %}python -m hamms{%endhighlight%}

Ein typischer Aufruf mit zum Beispiel einem *TCP Reset* sieht folgendermaßen aus

{% highlight bash %}
curl 127.0.0.1:5000
curl: (7) Failed to connect to 127.0.0.1 port 5000: Connection refused
{%endhighlight%}

### Hamms JUnit Rule

Damit das Schreiben von Tests mit Hamms einfacher erfolgen kann, wurde die Aufruflogik in einer *JUnit-Rule* gekapselt und
kann über das folgende [Repository](https://github.com/AlexBischof/hammsrule) in das jeweilige Projekt integriert werden.
*(Maven-Central Upload ist geplant)*

{% highlight xml %}
<dependency>
    <groupId>de.bischinger</groupId>
    <artifactId>hammsrule</artifactId>
    <version>1.0.0</version>
    <scope>test</scope>
</dependency>
{%endhighlight%}

Ein entsprechender Test könnte dann wie folgt aussehen und entsprechend dem *Service Error Catalogue* abgetestet werden.

{% highlight java %}
public class HammsRuleIT {
    @Rule
    public HammsRule hammsRule = new HammsRule("http://127.0.0.1");

    private MyOpenWeatherMapService myService;

    private ThrowingCallable callService = () -> myService.getCity("Munich");

    @Test
    public void testTcpReset() {
        myService = new MyOpenWeatherMapService(hammsRule.getTcpResetUrl());
        //test your error catalog behavior here
        assertThatThrownBy(callService).hasCauseInstanceOf(ConnectException.class);
    }

    @Test
    public void testAcceptButNeverSendBack() {
        myService = new MyOpenWeatherMapService(hammsRule.getAcceptButNeverSendBack());
        //test your error catalog behavior here
        assertThatThrownBy(callService).hasCauseInstanceOf(SocketTimeoutException.class);
    }
}{%endhighlight%}

<p align="center"><img src="{{site.baseurl}}/images/2016/2016-01-01-hamms.png"/></p>

Das Repository stellt zusätzlich auch zwei Skripte zur Verfügung, mit denen Hamms gestartet bzw. gestoppt werden kann. Damit ist es 
möglich, *Hamms* über z.B. Maven mit dem **exec-maven-plugin** automatisiert in den Softwarezyklus zu hängen. Folgende *pom.xml* zeigt
eine Konfiguration, über die *Hamms* mit dem **maven-failsafe-plugin** verbunden wird. Somit werden Hamms-Tests immer in der *verify* Phase ausführt.   
Wichtig dabei zu wissen ist jedoch, dass das *maven-failsafe-plugin* die *post-integration-test* Phase nicht ausführt, wenn Testfehler vorhanden
sind. Im Notfall müsste man *Hamms* dann doch händisch stoppen.

{% highlight xml %}
<plugin>
    <artifactId>exec-maven-plugin</artifactId>
    <groupId>org.codehaus.mojo</groupId>
    <executions>
        <execution>
            <id>Start Hamms</id>
            <phase>pre-integration-test</phase>
            <goals>
                <goal>exec</goal>
            </goals>
            <configuration>
                <executable>${basedir}/scripts/start_hamms.sh</executable>
            </configuration>
        </execution>
        <execution>
            <id>Stop Hamms</id>
            <phase>post-integration-test</phase>
            <goals>
                <goal>exec</goal>
            </goals>
            <configuration>
                <executable>${basedir}/scripts/stop_hamms.sh</executable>
            </configuration>
        </execution>
    </executions>
</plugin>
{%endhighlight%}

Obiges Beispiel befindet sich wie immer in meinem [Github-Repository](https://github.com/AlexBischof/hammsrule). 

### Fazit

Webservices (und dadurch auch der Service Error Catalogue) lassen sich gut hinsichtlich Http-Client Errors testen, 
was die Analysierbarkeit und das Verständnis des Systems erhöht.
Dabei lassen sich Tests durch z.B. obige JUnit-Rule einfach und schnell schreiben und auch in 
den kompletten Softwarecycle mit Maven einbinden. 