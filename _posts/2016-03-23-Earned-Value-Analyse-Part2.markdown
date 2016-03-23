---
layout: post
author: Philip Verweyen
authorkey: philipverweyen
title: "Earned Value Analyse - oder: Wissen statt glauben im Projektcontrolling"
description: "Teil 2: Quo vadis Projekt? - Projektprognosen mittels Earned Value Analyse"
categories: Web Projektcontrolling
---
In [Teil 1](http://blog.siteos.de/web/projektcontrolling/2015/02/20/Earned-Value-Analyse.html) dieses Artikels wurde gezeigt, wie mit der Earned Value Analyse der aktuelle IST-Stand hinsichtlich Kosten- und Terminplanung eines Projekts ermittelt werden kann.
In einem nächsten Schritt zeige ich nun, wie sich, basierend auf den Kennzahlen des Projekts, mit Hilfe der EVA Prognosen über den weiteren Projektverlauf stellen lassen.

Betrachten wir zunächst noch einmal die in [Teil 1](http://blog.siteos.de/web/projektcontrolling/2015/02/20/Earned-Value-Analyse.html) erläuterten EVA-Kennzahlen:

 - Budget at Completion (BAC)
   - Das Gesambudget des Projekts
 - Planned Value(PV)
   - Der Planwert/die Plankosten zum aktuellen Zeitpunkt
 - Actual Costs (AC)
   - Die Ist-Kosten zum aktuellen Zeitpunkt
 - Earned Value (EV)
   - Der Fertigstellungswert der geleisteten Arbeit.

Basierend auf diesen Kennzahlen werden die nächsten Werte der EVA ermittelt:

 - Cost Variance (CV) = EV - AC
   - Kostenabweichung
   - Positiv = unter Budget, Negativ = über Budget
 - Schedule Variance (SV) = EV - PV
   - Planabweichung/Terminabweichung
   - Positiv = Zeitvorsprung, Negativ = Zeitverzug
 - Cost Performance Index (CPI) = EV / AC
   - Kosteneffizienz
   - Kleiner 1 = negativ, größer 1 = positiv
 - Schedule Performance Index (SPI) = EV / PV
   - Zeiteffizienz
   - Kleiner 1 = negativ, größer 1 = positiv
  
Mit Hilfe dieser Kennzahlen kann nun der wohl wichtigste Wert der EVA ermittelt werden:

 - Estimate at Completion (EAC)
   - Prognostizierte Gesamtkosten zum Projektende

und hieraus abgeleitet:

 - Estimate to Complete (ETC) = EAC - AC
   - Prognostizierte Restkosten bis zum Projektende
 - Variance at Completion (VAC) = BAC - EAC
   - Prognostizierte Kostenabweichung zum Projektende
 
<u>Zu beachten</u>: Bei diesen Werten handelt es sich, wie auch bei den Basiskennzahlen, stets um Momentaufnahmen.

### Ermittlung des EAC

Für die Ermittlung des EAC bedarf es einer differenzierten Betrachtung der beobachteten Planabweichungen.

 - Die Kostenabweichung wird sich für den restlichen Projektverlauf weiter fortsetzen
   - EAC = BAC / CPI
 - Die Kostenabweichung war einmalig und wirkt sich nicht auf den restlichen Projektverlauf aus
   - EAC = AC + (BAC - EV)
   - Ein typisches Szenario hierfür sind nicht vorhergesehene Einmalkosten.
 - Wenn nicht nur die Kosten, sondern auch der Zeitplan kritisch sind
   - EAC = AC + (BAC - EV) / (CPI * SPI)
   - Dieses Verfahren sollte verwendet werden, wenn sowohl eine Kosten- als auch eine Terminabweichung vorliegen und der geplante Endtermin zwingend zu halten ist
 - Die Kostenabweichung hat keine Auswirkung auf die geplanten Gesamtkosten
   - EAC = BAC
   - Dieses Verfahren macht nur Sinn, wenn sichergestellt werden kann, dass die Kostenabweichung bis zum Projektende wieder ausgeglichen wird.
 - Neubewertung der Restkosten. Die Restaufwände werden komplett neu geschätzt
  - EAC = AC + ETC_geschätzt
  
Betrachten wir nun konkret das in Teil 1 vorgestellte Beispiel. Der Verlauf von PV, AC und EV zeigte sich wie folgt:

<img src="{{site.baseurl}}/images/2015/2015-02-20-eva3.png"/>

Mit folgenden Werten zum Stichtag (Monat 6):
{% highlight text %}
CV = 360.000 € - 480.000 € = -120.000 € (Kostenüberschreitung)
SV = 360.000 € - 350.000 € = 10.000 € (Zeitvorsprung)
CPI = 360.000 € / 480.000 € = 0,75 (negativer Kostenverlauf)
SPI = 360.000 € / 350.000 € = 1,03 (leicht positiver Terminverlauf)
{% endhighlight %}

Welches Verfahren zur Ermittlung des EAC erscheint für dieses Projekt sinnvoll?
Hierfür benötigen wir eine Interpretation der Kostenabweichungen. Der Verlauf zeigt, dass sich die Kosten parallel oberhalb des Plans bewegen, wobei es in Monat 3 und Monat 6 jeweils einen deutlichen Anstieg gibt.
Aus der Perspektive des Projektleiters sollten hier die Gründe für die Anstiege bekannt und eine Interpretation der Kostenabweichung ohne Probleme möglich sein.
Wir betrachten das Projekt nun aber als Außenstehende und versuchen eine Erklärung für den Verlauf zu finden.

Der Wert AC steigt zwei mal an und verläuft sonst parallel zum Plan. Das alleine könnte ein Hinweis auf ungeplante Einmalkosten sein. 
Berechnen wir also den EAC gemäß der entsprechenden Formel:

{% highlight text %}
EAC = AC + (BAC - EV) 
         = 480.000 € + (1.200.000 € - 360.000 €)
         = 1.320.000 €
{% endhighlight %}

Es werden bis zum Projektende also voraussichtlich noch 840.000 € benötigt (ETC) und wir erwarten eine finale Budgetabweichung von 120.000 € (VAC).

Nun haben wir allerdings für die Interpretation der Kostenabweichung lediglich den Verlauf von AC und PV betrachtet. Und nachdem wir nach dem letzten Anstieg (Monat 6) den weiteren Verlauf der Kosten noch nicht kennen, sollten weitere Szenarien geprüft werden.  
Betrachten wir zum Beispiel auch den Verlauf für den EV, so zeigt sich im Zusammenhang mit der letzten Abweichung, dass dieser ebenfalls deutlich ansteigt und letztlich sogar den Planwert überschreitet.
Ein Erklärung hierfür könnte sein, dass der Projektleiter die dauerhaften Terminabweichungen (EV- PV) der Vormonate durch die Hinzunahme eines weiteren Teammitglieds kompensieren will. Hierdurch steigen entsprechend die Kosten, aber (hoffentlich) auch der EV.   
Angesichts der bereits deutlichen Kostenabweichung erscheint eine solche Entscheidung z.B. dann sinnvoll, wenn der Endtermin des Projekts zwingend gehalten werden muss und hierfür eine weitere Kostenüberschreitung in Kauf genommen wird.   
In diesem Szenario sollte sich zeigen, dass der AC in den Folgemonaten nicht mehr parallel zu PV verläuft - schießlich haben sich die monatlichen Kosten durch das zusätzliche Teammitglied dauerhaft erhöht.
Es handelt sich nun also um eine Kostenabweichung, die sich auch auf den weiteren Projektverlauf auswirken wird.

Berechnen wir den EAC gemäß der entsprechenden Formel:

{% highlight text %}
EAC = BAC / CPI
         = 1.200.000 € / 0,75
         = 1.600.000 €
{% endhighlight %}

Es werden bis zum Projektende also voraussichtlich noch 1.120.000 € benötigt (ETC) und wir erwarten eine finale Budgetabweichung von 400.000 € (VAC).

Wir haben nun also einen signifikanten Unterschied in der Projektprognose. Die Korrekte Interpretation der Abweichungen (und somit die Auswahl des passenden Berechnungsverfahrens) ist für die Vorhersage des weiteren Projektfortschritts von großer Bedeutung.

Referenzen/Quellennachweise:

 - *Peterjohann Consulting: Earned Value Analysis - eine Übersicht (Version 0.50, 01/2013 - [http://www.peterjohann-consulting.de/_pdf/peco-pm-earned-value-analysis.pdf](http://www.peterjohann-consulting.de/_pdf/peco-pm-earned-value-analysis.pdf))*
 - *PM Study Circle: Estimate at Completion (EAC) - A Project Forecasting Tool (05/2012 - [http://pmstudycircle.com/2012/05/estimate-at-completion-eac-a-project-forecasting-tool](http://pmstudycircle.com/2012/05/estimate-at-completion-eac-a-project-forecasting-tool))*
 - *Wikipedia:  Earned Value Analysis (02/2015 - [http://de.wikipedia.org/wiki/Earned_Value_Analysis](http://de.wikipedia.org/wiki/Earned_Value_Analysis))*
 - *PMI: A Guide to the Project Management Body of Knowledge (PMBOK Guide) - Fifth Edition (01/2013, ISBN: 978-1935589679)*
 - *Rita Mulcahy's PMP Exam Prep - Eighth Edition (06/2013, ISBN: 978-1932735659)*
 
 