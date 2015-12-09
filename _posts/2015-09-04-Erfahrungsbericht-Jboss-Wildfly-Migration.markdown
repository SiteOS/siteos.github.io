---
layout: post
title: "Erfahrungsbericht JBoss->WildFly Migration"
categories: JBoss Wildfly JavaEE, Java
---
SiteOS hat bei mehreren Bestandsanwendungen (Projekte und Produkten) eine Migration von „JBoss AS FINAL 7.1.1 Community Edition“
 nach WildFly 8.2.0.Final durchgeführt. Dieser Artikel ist keine HowTo-Anleitung für eine Migration, sondern beschreibt 
 die konkreten aufgetretenen „Herausforderungen“ und deren mögliche Lösungen oder Workarounds.

Wer eine Umstellung von JBoss 7 auf WildFly plant, findet hier nützliche Tipps und erhält einen Einblick in die zu meisternden „Herausforderungen“ auf Java-Ebene.

 

## Umstellung der Dependencies

Als Hilfestellung für eine Umstellung nachfolgend ein Auszug der vorgenommenen Änderungen an den verschiednen Sektionen der Maven “pom.xml” der entsprechenden Maven Software-Modulen. Je nach dem, welche WildFly Version konkret verwendet wird und welche Features davon genutzt werden, kann dies natürlich projektspezifisch variieren.

### EJB-Version
Umstellung der EJB-Version.

#### JBoss:
{% highlight xml %}
<!-- Import the EJB API, we use provided scope as the API is included in JBoss AS 7 -->
<dependency>
    <groupId>org.jboss.spec.javax.ejb</groupId>
    <artifactId>jboss-ejb-api_3.1_spec</artifactId>
    <scope>provided</scope>
</dependency>
<dependency>
    <groupId>org.jboss.ejb3</groupId>
    <artifactId>jboss-ejb3-ext-api</artifactId>
    <version>2.0.0</version>
    <scope>provided</scope>
</dependency>
{% endhighlight %}
#### WildFly:
{% highlight xml %}
<!-- Import the EJB API, we use provided scope as the API is included in WildFly AS 8.2 -->
    
<dependency>
    <groupId>org.jboss.spec.javax.ejb</groupId>
    <artifactId>jboss-ejb-api_3.2_spec</artifactId>
    <version>1.0.0.Final</version>
    <scope>provided</scope>
</dependency>

<dependency> 
    <groupId>org.jboss.ejb3</groupId> 
    <artifactId>jboss-ejb3-ext-api</artifactId>
    <version>2.1.0</version>
    <scope>provided</scope>
</dependency>
{% endhighlight %}  

### Maven EJB-Plugin
Umstellung der EJB-Version für das Maven-Plugin.

#### JBoss:
{% highlight xml %}
<plugin>
    <artifactId>maven-ejb-plugin</artifactId>
    <version>${version.ejb.plugin}</version>
    <configuration>
        <!-- Tell Maven we are using EJB 3.1 -->
        <ejbVersion>3.1</ejbVersion>
    </configuration>
</plugin>
{% endhighlight %} 

#### WildFly:
{% highlight xml %}
<plugin>
    <artifactId>maven-ejb-plugin</artifactId>
    <version>${version.ejb.plugin}</version>
    <configuration>
        <!-- Tell Maven we are using EJB 3.2 -->
        <ejbVersion>3.2</ejbVersion>
    </configuration>
</plugin>
{% endhighlight %} 
            
### Arquillian
Umstellung der Arquillian –Dependencies in den entsprechenden Maven-Profilen auf WildFly.

#### JBoss:
{% highlight xml %}
<profile>
    <!-- An optional Arquillian testing profile that executes tests
        in yourJBossASinstance -->
    <!-- This profile will start a newJBossASinstance, and execute
        the test, shutting it down when done -->
    <!-- Run with: mvn clean test -Parq-jbossas-managed -->
    <id>arq-jbossas-managed</id>
         <dependencies>
             <dependency>
                 <groupId>org.jboss.spec</groupId>
                 <artifactId>jboss-javaee-6.0</artifactId>
                 <version>1.0.0.Final</version>
                 <type>pom</type>
                 <scope>provided</scope>
             </dependency>
             <dependency>
                 <groupId>org.jboss.as</groupId>
                 <artifactId>jboss-as-arquillian-container-managed</artifactId>
                 <version>7.1.1.Final</version>
                 <scope>test</scope>
             </dependency>
             <dependency>
                 <groupId>org.jboss.arquillian.protocol</groupId>
                 <artifactId>arquillian-protocol-servlet</artifactId>
                 <scope>test</scope>
             </dependency>
         </dependencies>
     </profile>

<profile>
    <!-- An optional Arquillian testing profile that executes tests
        in a remoteJBossASinstance -->
    <!-- Run with: mvn clean test -Parq-jbossas-remote -->
    <id>arq-jbossas-remote</id>
    <dependencies>
        <dependency>
            <groupId>org.jboss.as</groupId>
            <artifactId>jboss-as-arquillian-container-remote</artifactId>
            <version>7.1.1.Final</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
</profile>
{% endhighlight %} 

#### WildFly:
{% highlight xml %}
<profile>
    <!-- An optional Arquillian testing profile that executes tests
        in yourWildFlyASinstance -->
    <!-- This profile will start a newWildFlyASinstance, and execute
        the test, shutting it down when done -->
    <!-- Run with: mvn clean test -Parq-wildfly-managed -->
    <id>arq-wildfly-managed</id>
         <dependencies>
             <dependency>
                 <groupId>org.jboss.spec</groupId>
                 <artifactId>jboss-javaee-7.0</artifactId>
                 <version>1.0.0.Final</version>
                 <type>pom</type>
                 <scope>provided</scope>
             </dependency>
                   <dependency>
                       <groupId>org.wildfly</groupId>
                       <artifactId>wildfly-arquillian-container-managed</artifactId>
                       <version>8.2.0.Final</version>
                   </dependency>
             <dependency>
                 <groupId>org.jboss.arquillian.protocol</groupId>
                 <artifactId>arquillian-protocol-servlet</artifactId>
                 <scope>test</scope>
             </dependency>
             <dependency>
                  <groupId>org.jboss.shrinkwrap.resolver</groupId>
                  <artifactId>shrinkwrap-resolver-api</artifactId>
                  <scope>test</scope>
                </dependency>
                <dependency>
                  <groupId>org.jboss.shrinkwrap.resolver</groupId>
                  <artifactId>shrinkwrap-resolver-spi</artifactId>
                  <scope>test</scope>
                </dependency>
                <dependency>
                  <groupId>org.jboss.shrinkwrap.resolver</groupId>
                  <artifactId>shrinkwrap-resolver-api-maven</artifactId>
                  <scope>test</scope>
                </dependency>
                <dependency>
                  <groupId>org.jboss.shrinkwrap.resolver</groupId>
                  <artifactId>shrinkwrap-resolver-spi-maven</artifactId>
                  <scope>test</scope>
                </dependency>
                <dependency>
                  <groupId>org.jboss.shrinkwrap.resolver</groupId>
                  <artifactId>shrinkwrap-resolver-impl-maven</artifactId>
                  <scope>test</scope>
                </dependency>
                <dependency>
                  <groupId>org.jboss.shrinkwrap.resolver</groupId>
                  <artifactId>shrinkwrap-resolver-impl-maven-archive</artifactId>
                  <scope>test</scope>
                </dependency>
         </dependencies>       
     </profile>

<profile>
    <!-- An optional Arquillian testing profile that executes tests
        in a remoteJBossASinstance -->
    <!-- Run with: mvn clean test -Parq-wildfly-remote -->
    <id>arq-wildfly-remote</id>
    <dependencies>
           <dependency>
                       <groupId>org.wildfly</groupId>
                       <artifactId>wildfly-arquillian-container-remote</artifactId>
                       <version>8.2.0.Final</version>
                   </dependency>
           
                    <dependency>
                  <groupId>org.jboss.shrinkwrap.resolver</groupId>
                  <artifactId>shrinkwrap-resolver-api</artifactId>
                  <scope>test</scope>
                </dependency>
                <dependency>
                  <groupId>org.jboss.shrinkwrap.resolver</groupId>
                  <artifactId>shrinkwrap-resolver-spi</artifactId>
                  <scope>test</scope>
                </dependency>
                <dependency>
                  <groupId>org.jboss.shrinkwrap.resolver</groupId>
                  <artifactId>shrinkwrap-resolver-api-maven</artifactId>
                  <scope>test</scope>
                </dependency>
                <dependency>
                  <groupId>org.jboss.shrinkwrap.resolver</groupId>
                  <artifactId>shrinkwrap-resolver-spi-maven</artifactId>
                  <scope>test</scope>
                </dependency>
                <dependency>
                  <groupId>org.jboss.shrinkwrap.resolver</groupId>
                  <artifactId>shrinkwrap-resolver-impl-maven</artifactId>
                  <scope>test</scope>
                </dependency>
                <dependency>
                  <groupId>org.jboss.shrinkwrap.resolver</groupId>
                  <artifactId>shrinkwrap-resolver-impl-maven-archive</artifactId>
                  <scope>test</scope>
                </dependency>
    </dependencies>
</profile>
 {% endhighlight %} 

### Keine „Valves“ mehr

JBoss 7 verwendete als Web-Container „JBossWeb“ aka Tomcat. WildFly verwendet als Web-Container "Undertow" und dieser unterstützt keine „Valves“ mehr. Valves sind eine Art von Lowlevel - Filter über die man Zugriff zu einigen internen Server-APIs hat, die z.T. von im JBoss bereits mitgelieferten Komponenten verwendet werden.

### URL- Rewrites:

URL-Rewrites wurden in JBoss 7 über das RewriteValve abgebildet, z.B. in diesem Fall um auf eine bestimmte Version einer REST-Schnittstelle umzuleiten.

#### JBoss
jboss-web.xml:
{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<jboss-web>
       <security-domain>myapp-rest</security-domain>
       <!--  Rewrite Valve aktivieren, verwendet die rewrite.properties -->
        <valve>
      <class-name>org.jboss.web.rewrite.RewriteValve</class-name>
    </valve>
</jboss-web>
{% endhighlight %} 
rewrite.properties:

{% highlight properties %}
# ohne v1 umleitung auf v1 siehe Jboss "The rewrite Valve"
# alles was nicht mit der Version beginnt
RewriteCond %{REQUEST_URI}  !^/myapp-rest/v1.*$
# [R,L] Mit Redirect
RewriteRule  ^/(.*)$                 /v1/$1  [NC,R,L]
{% endhighlight %} 
 
#### WildFly
Undertow kennt Predicates mit denen man einfache Regeln definieren kann. (siehe [https://github.com/undertow-io/undertow-docs/blob/master/src/main/asciidoc/predicates-attributes-handlers.asciidoc](https://github.com/undertow-io/undertow-docs/blob/master/src/main/asciidoc/predicates-attributes-handlers.asciidoc)

Im WEB-INF- Verzeichnis muss dafür eine Datei **undertow-handlers.conf** anlegt werden, in das die Predicates geschrieben werden.

Damit lässt sich eine Rewrite- Regel über einen Redirect schreiben: 

 **not path-prefix['/v1/'] and regex[pattern='^/realm-rest/(.*)$', value='%{REQUEST_URL}', full-match="true"] -> redirect['/realm-rest/v1/${1}']**
 
Zu beachten ist dabei aber: Um das ${1} im Redirect zu haben benötigt man einen PREDICATE_CONTEXT in dem die Capturing Groups aus dem regulären Ausdruck zwischengespeichert werden.  Der PREDICATE_CONTEXT ist jedoch in der Standardkonfiguration null, so dass es bei der obigen Regel zu einer NullPointerException kommt.

Dieses Problem kann man wiederum über eine Undertow-ServletExtension übergehen:

- META-INF/services/io.undertow.servlet.ServletExtension Datei anlegen 
- Dort siteos.realm.rest.RewriteServletExtension angeben. 

Die RewriteServletExtension fügt einen PredicateContextHandler in die HttpHandler Kette ein, der den Context anlegt. Damit umgeht man die NullPointerException.

Die obenstehende Regel musste umformuliert werden, da der Reguläre Ausdruck für das Predicate kein "not" in der Expression kennt, sondern nur ein "not" über das gesamte Predicat. 
Ausserdem braucht man eine Regel die "matched", sonst wird nichts in den Kontext gelegt.

 

### SPNEGO

Das Modul zur Unterstützung von SPNEGO (Single Sign On über Browser mit Kerberos, Active Directory) wird zwar noch in den Binaries von WildFly mit ausgeliefert, funktioniert aber leider nicht mehr da es über „Valves“ eingebunden ist.

#### JBoss
Prinzipiell basiert SPNEGO unter JBoss 7 auf zwei Klassen: **org.jboss.security.negotiation.NegotiationAuthenticator und org.jboss.security.negotiation.spnego.SPNEGOLoginModule** 
NegotiationAuthenticator ist eine Subklasse eines **org.apache.catalina.authenticator.FormAuthenticator** und wird im Tomcat über ein <valve> (eine Art Servlet Filter) im jboss-web.xml eingebunden. 
Da der NegotiationAuthenticator ein FormAuthenticator ist, ist im web.xml in der
{% highlight xml %}
<auth-method>FORM</auth-method>
{% endhighlight %}
  
korrekt. 
Der NegotiationAuthenticator kümmert sich um die Kerberos Authentifizierung und bietet, als Subklasse des FormAuthenticator, automatisch einen Fallback auf die FORM Authentifizierung. Der NegotiationAuthenticator übergibt dann bereits passende Principal Daten an das SPNEGOLoginModule (Schema: Wenn Kerberos Login, die Kerberos Daten, wenn Form Login Username und Password). Das SPNEGOLoginModule kümmert sich dann um den Login Vorgang.

 

Der Folgende Blog-Artikel beschreibt den SPNEGO Mechanismus und die entsprechende Konfiguration von JBoss:
 [http://blog.andyserver.com/2013/07/integrated-windows-authentication-spnego-web-applications-on-jboss-eap-6-1/](http://blog.andyserver.com/2013/07/integrated-windows-authentication-spnego-web-applications-on-jboss-eap-6-1/) 

 
#### WildFly
In dem folgenden Foren-Post zum Thema WildFly 8.x und SPNEGO wird das Thema diskutiert. 
[https://developer.jboss.org/thread/238095?start=0&tstart=0](https://developer.jboss.org/thread/238095?start=0&tstart=0) 

Wie es aussieht wurde die Implementierung der SPNEGO-Funktionalität für WildFly geplant in Version 8, aber dann immer wieder verschoben und erst in WildFly 10.0.0.CR1 implementiert. 
https://issues.jboss.org/browse/WFLY-2553 

Es gibt ein Open Source Projekt "spnego-auth" auf Git-Hub ([https://github.com/dstraub/spnego-wildfly](https://github.com/dstraub/spnego-wildfly)), welches eine SPNEGO Integration für WildFly bietet und einen Ersatz für den NegotiationAuthenticator enthält (SpnegoAuthenticationMechanism). 
Der Ersatz basiert aber auf AuthenticationMechanism und nicht auf einem FormAuthenticationMechanism.

Dieser muss somit im web.xml als eigene Auth-Methode
{% highlight xml %}
<auth-method>SPNEGO</auth-method>
{% endhighlight %}

eingebunden werden und ist ein kompletter Ersatz für die FORM -Authentifizierung. 
D.h. man hat danach nur die Kerberos Authentifizierung und  keinen Fallback mehr auf die FORM -Authentifizierung.
Um den FORM-Fallback zu erreichen musste eine eigene Implementierung geschaffen werden, die auf dem SourceForge Projekt SPNEGO http://spnego.sourceforge.net/ aufbaut. 
Allerdings gibt es einen Bug/geändertes Verhalten in Java 8, welches dazu führt, dass das alles trotzdem nicht funktioniert. 
Details dazu siehe [http://sourceforge.net/p/spnego/discussion/1003769/thread/700b6941/#cb84](http://sourceforge.net/p/spnego/discussion/1003769/thread/700b6941/#cb84). 
Die Lösung war vorerst, auf ein frühere Java 8 Version "zurückzugehen“.

### Principal Caching

WildFly cached den Principal nach einem Login anders als das bei JBoss der Fall war. 
Das „LoginModule“ wird nicht aufgerufen, wenn der Principal aus dem Cache kommt. Im JBoss war das noch der Fall.

In einer zu migrienden Applikation lagen die Rechte eines Users bisher in einem eigenen SecurityContext, der wiederum über den CDI Session-Scope in der HttpSession liegt. 
Während des Logins wurde in den SiteOS Login-Modulen der SecurityContext erzeugt, initialisiert und in die Session gelegt. Vom System wurden die Rechte dann aus der Session ausgelesen und angewendet. 
WildFly cached die Principals so stark, dass bei einem gecachten Login keines der Login Module aufgerufen wird. Damit landet der SecurityContext bei einem gecachten Principal auch nicht in der Session.

Im JBoss 7 war das Principal-Caching komplett anders: Wenn man sich z.B. zweimal angemeldet hat, wurden auch immer die Login Module aufgerufen. 
Egal ob zweimal hintereinander mit an/abmelden oder über verschiedene HttpSessions. Alles hat immer zu genau einem Aufruf der Login-Module geführt.

Was bei WildFly passiert zeigen die nachfolgenden Beispiele:

#### 1. Anmeldung eines Users, Abmelden und erneut anmelden
Wenn sich also ein User anmeldet und wieder abmeldet, so wird seine Session geleert. Wenn er sich erneut anmeldet, kommt die "Anmeldung" aus dem Cache, 
es wird kein Login Modul aufgerufen und damit landet auch kein neuer SecurityContext in der Session. Der User ist angemeldet, hat aber keine Rechte.


#### 2. Gleichzeitige Anmeldung desselben Users mit anderer HttpSession.
Falls sich ein User zweimal anmeldet, wobei jede Anmeldung eine eigene HttpSession hat: 
Bei der ersten Anmeldung läuft alles „normal“ über die Login-Module. 
Bei der zweiten Anmeldung kommt der Principal wieder aus dem Cache, kein Login-Module wird aufgerufen, der SecurityContext in der Session ist nicht initialisiert und damit hat der User keine Rechte.

### Die Konfigurationsmöglichkeit               
{% highlight xml %}
<security-domain name="other" cache-type="none">
{% endhighlight %}
ist keine praktikable Lösung, da dann bei absolut jedem Request – auch bei Sub-Requests für andere Ressourcen wie Images, CSS,… die Login-Module aufgerufen werden.


#### Lösung mit WildFly
Die Rechte liegen nun nicht mehr im SessionContext in der HttpSession, sondern sind in einem CustomPrincipal. Beim Caching des Principals werden damit auch die Rechte gecached und stehen immer zur Verfügung.

#### WildFly-Bug: Principal im Cache bei abgelaufener Session
Zudem gab es einen Bug in WildFly ([https://issues.jboss.org/browse/WFLY-3221](https://issues.jboss.org/browse/WFLY-3221)), dessen Fix aber erst in einer WildFly Version 9 enthalten ist: 
Wenn die HttpSession abläuft bleibt der Principal im Cache. Das ist ungünstig, da Änderungen am User (z.B. Passwort) dann nicht bemerkt werden, da WildFly immer noch das alte Passwort im Cache hat. 
Hierzu war ein möglicher Workaround einen eigenen **HttpSessionListener (SessionInvalidatedListener)** der beim Ablauf der Session den Principal aus dem Cache entfernt.

 

### Fazit

Bei manchen Projekten/Produkten ging die Migration problemlos von statten und war beschränkt auf das Ändern der Dependencies in den Maven „poms“. Aufgrund der tiefgreifenden Änderungen in WildFly 8, waren die aufgetretenen Probleme zum Teil relativ aufwendig zu identifizieren und zu lösen.

Das nachfolgende Zitat beschreibt die Situation mit WildFly sehr treffend (Quelle [1]):

“Finally we have to realize that WildFly from a certain point of view is like an open beta. It has freely downloadable binaries, but the product is early in its lifecycle and there’s no commercial support available for it yet. When the WildFly branch transitions to JBoss EAP 7 many bugs that the community discovers now will undoubtedly have been fixed and commercial support will be available then. In a way this is the price we pay for a free product such as this. As David Blevins wrote “Open Source Isn’t Free”. Users “pay” by testing the software and producing bug reports and perhaps patches, which IMHO is a pretty good deal.”

 

### Quellen/Links

- [http://stackoverflow.com/questions/19583636/jboss-7-1-1-final-migration-guide-to-wildfly](http://stackoverflow.com/questions/19583636/jboss-7-1-1-final-migration-guide-to-wildfly) [1]
- [http://jdevelopment.nl/experiences-migrating-jboss-7-wildfly-81/](http://jdevelopment.nl/experiences-migrating-jboss-7-wildfly-81/) [2]
- [https://docs.jboss.org/author/display/WFLY8/All+WildFly+8+documentation](https://docs.jboss.org/author/display/WFLY8/All+WildFly+8+documentation) [3]