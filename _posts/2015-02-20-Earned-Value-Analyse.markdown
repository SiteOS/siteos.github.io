---
layout: post
title: "Earned Value Analyse - oder: Wissen statt glauben im Projektcontrolling"
description: "Teil 1: Ut vales Projekt? - Ermittlung des aktuellen Projektstatus mit Hilfe der Earned Value Analyse"
categories: Web
excerpt_separator: <!--more-->
---
Stellen Sie sich vor, Ihr einjähriges Projekt läuft bereits seit sechs Monaten, 50% der Aufgaben sind erledigt und erst 40% des Budgets sind verbraucht.
Sie freuen sich zunächst über die guten Zahlen - aber drei Monate später ist das Budget fast aufgebraucht und es stehen noch zahlreiche Aufgaben an.

Angenommen es gab in den Folgemonaten keine ungeplanten Abweichungen: Was haben Sie falsch gemacht?
Antwort: Sie haben nicht berücksichtigt, dass in dieser Zeit eine sehr kostenintensive Aufgabe zu bearbeiten war.

Das Kernproblem ist hier, dass die Anzahl der erledigten Aufgaben mit dem Fertigstellungswert (Earned Value) gleichgesetzt wurde. Das ist verlockend - aber trügerisch, wenn der geplante Projektfortschritt nicht linear ist.

Die Earned Value Analyse (EVA) hilft Ihnen dabei, einen objektiven Blick auf den Projektstatus zu erhalten. Der Earned Value ist hierbei nur eine der vier Basiskennzahlen:

 - Budget at Completion (BAC)
  - Das Gesambudget des Projekts
 - Planned Value(PV)
  - Der Planwert/die Plankosten zum aktuellen Zeitpunkt
 - Actual Costs (AC)
  - Die Ist-Kosten zum aktuellen Zeitpunkt
 - Earned Value (EV)
  - Der Fertigstellungswert der geleisteten Arbeit.

Welche Kennzahlen wurden im o.g. Beispiel verwendet? Richtig: BAC und AC.
PV und EV lassen sich aus den Angaben über den Projektfortschritt nicht sicher herleiten - somit ist auch keine seriöse Aussage über den Projektstatus möglich.

Betrachten wir zunächst den Planned Value: Um diesen zu ermitteln, benötigen Sie den geplanten Kostenverlauf über die gesamte Projektlaufzeit. Hierüber können Sie die Plankosten zu einem Stichtag ermitteln.

<img src="{{site.baseurl}}/images/2015-02-20-eva1.png"/>

Die Plankosten nach sechs Monaten Projektlaufzeit sollten demnach 350.000 € betragen, das Gesamtbudget liegt bei 1,2 Mio. €.
Es zeigt sich auch deutlich der geplante Kostenanstieg in den Folgemonaten.
Projezieren wir nun den IST-Kostenverlauf dazu:

<img src="{{site.baseurl}}/images/2015-02-20-eva2.png"/>

Hier zeigt sich eine deutliche Abweichung vom Plan. Die Kosten zum Stichtag betragen bereits 40% des Gesamtbudgets (480.000 €).

Zeigt dies bereits eine negative Projektentwicklung? Was, wenn der Projektfortschritt ebenfalls über dem Plan liegt - z.B. weil mehr Entwickler am Projekt arbeiten als ursprünglich geplant?
Tatsächlich ist das oben gezeigte Diagramm ebenfalls trügerisch: Das Verhältnis zwischen PV und AC ist für die Earned Value Analyse nicht relevant!

Für ein vollständiges Gesamtbild ist also zwingend auch der Earned Value erforderlich. Hierfür benötigen wir den Fertigstellungsgrad (Percent Complete) des Projekts, bzw. der einzelnen Arbeitspakete.

Zur Ermittlung des Percent Complete (PC) gibt es verschiedene Ansätze, die individuell pro Projekt (ggf. sogar pro Arbeitspaket) gewählt werden müssen.
Nachfolgend wird nur eine Teilmenge der etablierten Verfahren aufgelistet, welche i.d.R. bei SW-Pojekten zum Einsatz kommen:

 - Schätzung
  - Die für ein Arbeitspaket verantwortlichen Entwickler schätzen den Fertigstellungsgrad, bzw. den Restaufwand.
  - Problematisch, da z.B. der Restaufwand oft zu niedrig eingeschätzt wird.
 - 0/100-Methode
  - "Alles oder nichts": Ein begonnenes Arbeitspaket hat einen PC von 0%. Erst nach Fertigstellung wird es mit 100% bewertet.
  - Sehr vorsichtigerAnsatz, der bei Arbeitspaketen mit großen Unsicherheiten genutzt wird.
 - 50/50-Methode
  - Ein begonnenes Arbeitspaket hat einen PC von 50%, nach Abschluss kommen die restlichen 50% hinzu.
  - Sinnvoll bei Kleinprojekten mit kleinen Arbeitspaketen.
 - 20/80-Methode
  - Ein begonnenes Arbeitspaket hat einen PC von 20%, nach Abschluss kommen die restlichen 80% hinzu.
  - Dieser Ansatz wird häufig in SW-Projekten genutzt.
  
Die Fertigstellungsgrade der einzelnen Arbeitspakete werden mit ihren Plankosten multipliziert. Die Summe dieser Einzelkosten ergibt den Earned Value.

Erweitern wir nun exemplarisch unsere Auswertung um einen Earned Value-Verlauf:

<img src="{{site.baseurl}}/images/2015-02-20-eva3.png"/>

Der Earned Value in diesem Beispiel liegt bei lediglich 280.000 €. Es zeigt sich also, dass nicht nur die Ist-Kosten den Plan übersteigen, auch der Projektfortschritt hinkt dem Plan hinterher.
Nur aus diesem Gesamtkontext lassen sich nun Schlussfolgerungen für den Projektstatus und den weiteren Projektverlauf ziehen.

Basierend auf diesen Kennzahlen werden die nächsten Werte der EVA ermittelt:

 - Cost Variance (CV) = EV- AC
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
  
Betrachten wir die konkreten Werte des Projekts:

{% highlight text %}
CV = 280.000 € - 480.000 € = -200.000 € (Kostenüberschreitung)
SV = 280.000 € - 350.000 € = -70.000 € (Zeitverzug)
CPI = 280.000 € / 480.000 € = 0.58 (negativer Kostenverlauf)
SPI = 280.000 € / 350.000 € = 0.8 (negativer Terminverlauf)
{% endhighlight %}

Die Werte zeigen, dass die ursprünglich positive Sicht auf das Projekt bei objektiver Betrachtung eine negative Wendung nimmt.

Wie sich mit diesen Werten eine Vorhersage zum weiteren Projektverlauf herleiten lässt, zeige ich im zweiten Teil des Artikels: "Quo vadis Projekt? - Projektprognosen mittels Earned Value Analyse".

Referenzen/Quellennachweise:

 - Peterjohann Consulting: Earned Value Analysis - eine Übersicht (Version 0.50, 01/2013 - [http://www.peterjohann-consulting.de/_pdf/peco-pm-earned-value-analysis.pdf](http://www.peterjohann-consulting.de/_pdf/peco-pm-earned-value-analysis.pdf))
 - Wikipedia:  Earned Value Analysis (02/2015 - [http://de.wikipedia.org/wiki/Earned_Value_Analysis](http://de.wikipedia.org/wiki/Earned_Value_Analysis))
 - PMI: A Guide to the Project Management Body of Knowledge (PMBOK Guide) - Fifth Edition (01/2013, ISBN: 978-1935589679)
 - Rita Mulcahy's PMP Exam Prep - Eighth Edition (06/2013, ISBN: 978-1932735659)