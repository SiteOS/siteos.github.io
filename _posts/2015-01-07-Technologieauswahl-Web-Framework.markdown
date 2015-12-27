---
layout: post
title: "Technologieauswahl Web-Framework"
categories: Web
---
SiteOS hat im Rahmen eines Großprojektes eine Technologieauswahl für eine neue Applikation bei einem Kunden durchgeführt.
Ziele dabei waren, eine Technologie zu finden, welche sich in die bestehende IT-Infrastruktur und Applikationslandschaft nahtlos integrieren lässt und mit der die Anforderungen an die neue Applikation möglichst einfach umzusetzen sind.

Die bestehende Infrastruktur bestand aus:

 - Runtime JBoss AS FINAL 7.1.1 Community Edition (mit diversen aktualisierten Libraries für Hibernate/JPA/Envers/RESTeasy)
 - Java 1.7
 - bereits vorhandene Rich-Client (SWT) Applikationen mit Serverkomponenten
 - REST-Schnittstellen
 - Oracle 11g als Datenspeicher
 
Das Vorgehen bei der Technologieauswahl war:

    1. Technische Anforderungen definieren
    2. Webrecherchen
    3. Frameworks festlegen
    4. Evaluation der Frameworks in der möglichen Zielarchitektur (inkl. Entwicklung einer Demo-Applikation)
    5. Bewertung und Auswahl

### 1. Technische Anforderungen
Ein Auszug der technischen Anforderungen:

    - Web-Oberfläche
      - zur Bearbeitung der Daten
      - komfortable Tabellen Bearbeitung (mehrere Datensätze auf einmal)
    - Import und Export Möglichkeiten für Massendaten
    - Große Teile der Oberflächen sind CRUD
    - Aber mit Möglichkeit zum Erstellung von komplexen Oberflächen und Strukturen
    - REST-Schnittstelle für diverse Fremdsysteme
 

### 2. Webrecherchen
Da das neue System mit einer Web-Oberfläche ausgestattet werden soll, hat man sich bei der Technologieauswahl auf die 
Auswahl eines Web-Frameworks konzentriert. Viele nützliche Hinweise und Empfehlungen zum Vorgehen bei der Framework-Auswahl hat der Web-Framework Vergleich von Matt Raible geliefert.

[http://de.slideshare.net/mraible/comparing-jvm-web-frameworks-february-2014](http://de.slideshare.net/mraible/comparing-jvm-web-frameworks-february-2014)

Die nachfolgenden Links beschäftigen sich ebenfalls dem Vergleich/der Gegenüberstellung von Web-Frameworks

 - [http://en.wikipedia.org/wiki/Comparison_of_web_application_frameworks#Java](http://en.wikipedia.org/wiki/Comparison_of_web_application_frameworks#Java)
 - [http://zeroturnaround.com/rebellabs/developer-productivity-report-2012-java-tools-tech-devs-and-data](http://zeroturnaround.com/rebellabs/developer-productivity-report-2012-java-tools-tech-devs-and-data)
 - [http://zeroturnaround.com/rebellabs/rebel-labs-release-it-ops-devops-productivity-report-2013](http://zeroturnaround.com/rebellabs/rebel-labs-release-it-ops-devops-productivity-report-2013)
 - [http://devrates.com/project/list?query=web+framework](http://devrates.com/project/list?query=web+framework)
 - [http://bit.ly/jvm-frameworks-matrix](http://bit.ly/jvm-frameworks-matrix)

Starke Indizien für die Verbreitung eines Frameworks sind z.B.

 - die Anzahl der Google-Treffer im Vergleich zu anderen Frameworks
 - die Anzahl der Jobgesuche
 - technische Fragen dazu auf Stackoverflow
 
### 3. Frameworks festgelegt
Folgende Frameworks wurden für die Technologieauswahl ins Rennen geschickt.

 - Vaadin
 - JSF
  - Primefaces
 - Tapestry
 - Wicket
 - Grails
 - Play Framework
 - SpringMVC
 
### 4. Evaluation der Frameworks in der möglichen Zielarchitektur
Als Basis für die Demo-Applikation wurde ein gemeinsames Datenmodell mit einer zugehörigen Serviceschicht für die Persistenz und REST-Services (EJB-Serverprojekt) entwickelt.
Die Frameworks wurden in mehreren Iterationsstufen evaluiert:

 - 1.) Prüfen der Demos/Showcases gegen die Anforderungen
 - 2.) Lesen der Tutorials/ erste Gehversuche
 - 3.) Integration des Frameworks in die Zielarchitektur (JBoss 7.1.1 Runtime)
 - 4.) Entwicklung der Demo-Applikation pro Framwork
    - Einfache CRUD-Oberfläche
    - Komplexe Oberfläche mit Unterstrukturen
    - Anbindung REST-Schnittstelle
    
Nicht bei allen Frameworks sind alle Iterationsstufen durchlaufen worden. Manchmal hat sich  z.B. schon relativ bald herauskristallisiert dass Framework nicht geeignet ist, oder es ist an mangelnden Integrationsmöglichkeiten in die Zielumgebung gescheitert.

### 5. Bewertung und Auswahl
Für die Evaluation gab es ein strukturiertes Bewertungsschema welches die Anforderungen berücksichtigt und in das die Ergebnisse eingetragen wurden.

Bewertungs- und Entscheidungskriterien waren unter anderem

 - Popularität/Zukunftssicherheit
 - Toolunterstützung
 - Effektivität/Produktivität
 - Lernkurve
 - Dokumentation
 - Community Support
 
Weiterhin sind eigene Erfahrungen mit den jeweiligen Frameworks aus anderen Projekten mit eingeflossen.

Am Ende gab es eine Teamentscheidung für **Primefaces/JSF**, die Gründe dafür waren

 - Vorhandene Komponenten passen am besten zu den Anforderungen
  - sehr umfangreiche und komfortable Tabellenkomponente
 - damit war eine schnelle Entwicklung der Demoapplikation möglich
 - sehr gute Integration in die Zielumgebung
 - Standard im JEE/ JSF Umfeld
 - Weit verbreitet