---
layout: post
author: Thomas Reischl
authorkey: thomasreischl
title: Erfahrungen mit einer D2D2T Tape Backup Lösung
categories: Operating
---
## Erfahrungen beim Aufsetzen einer Tape Backup Lösung im Rahmen einer D2D2T (Disk-to-Disk-to-Tape) Strategie

In diesem Artikel berichten wir über die Erfahrungen beim Aufsetzen einer Tape Backup Lösung im Rahmen einer D2D2T Strategie. Da fragen sich natürlich einzelne, welche Relevanz das in Zeiten der Cloud hat oder ob Tapes das richtige Mittel für die Speicherung der Daten sind. Daher vorab ein paar einleitende Gedanken zu den Anforderungen und Rahmenbedingungen in diesem Beispiel Projekt.

<p align="center"><img src="{{site.baseurl}}/images/2018/2018-07-24_Artikel_Backup.png"/></p>


## Warum legen wir nicht gleich alles in die Cloud?

Bei größeren Datenmengen fehlen oft die Übertragungskapazitäten in die Cloud, oder aus der Cloud zurück, zudem benötigen nicht alle Daten eine ortsunabhängige Erreichbarkeit. Oft fehlt auch der Mehrwert, falls Sie Ihre Daten in die Cloud übertragen und ihr Cloud Dienstleister führt dann die gleichen Verarbeitungsschritte durch, die Sie Lokal ausführen würden. (Der Facebook Tape Roboter findet schließlich auch das Band mit Ihren Hochzeitsfotos vulgo mit deinem Action Video). Eine vollständige Automatisierung ist auch mit geringem Aufwand on premise zu erreichen.

Und vor allem: Kosten.


## Exkurs Cloud

Wir haben diese Woche im Rahmen eines Projekts zu Cloud Migration eines internationalen Konzerns die zukünftige Cloud Infrastruktur des Konzerns abgestimmt. Selbst das Unternehmen mit dem meisten laufenden AWS Projekten und Ingenieuren weltweit, das diese Cloud Migration betreut und hier nicht zitiert werden möchte, hat freimütig zugegeben: Bestehende lokale Lösungen sollten besser lokal bleiben, falls aus technischer Sicht keine Aktivitäten notwendig sind – die Cloud bedeutet immer zusätzliche Kosten. (Unsere Empfehlung: Hybride Clouds – decken Sie ihre Basislast mit eigenen Kapazitäten ab, bauen Sie Ihre Infastrukur so, dass Sie ein Provider unabhängiges Management Ihrer IT Infrastruktur leisten können. Oder decken Sie auch Ihre Spitzenlast ab und vermieten Sie freie Kapazitäten. Die Software zum Aufbau und der Verwaltung eigener Clouds wird immer mächtiger. So machen es auch die richtig erfolgreichen Unternehmen. z. B.

 - [https://www.heise.de/meldung/Bloomberg-Jeff-Bezos-ist-reichster-Mensch-der-Welt-4112740.html](https://www.heise.de/meldung/Bloomberg-Jeff-Bezos-ist-reichster-Mensch-der-Welt-4112740.html)
 - [https://www.heise.de/newsticker/meldung/Microsoft-Cloud-Boom-laesst-Umsatz-und-Gewinn-wachsen-4116718.html](https://www.heise.de/newsticker/meldung/Microsoft-Cloud-Boom-laesst-Umsatz-und-Gewinn-wachsen-4116718.html)
 - [https://www.heise.de/meldung/Cloud-Boom-bei-Oracle-4086481.html](https://www.heise.de/meldung/Cloud-Boom-bei-Oracle-4086481.html)

Und das liegt nicht (nur) an den tollen Einkaufskonditionen der Unternehmen, der Unterwasserkühlung der Server im Meer und der Masse der Installationen, sondern an dem, was Sie für die Leistungen zahlen.

Der Aufbau einer Cloud ist nicht Ihre Kernkompetenz? Nehmen Sie zum diesem Thema Kontakt mit Jeff Bezos auf …J. Oder beauftragen sie uns als Ihren Dienstleister.

Zur Sicherheit in der Cloud: In der Cloud wird immer Infrastruktur, Rechenleistung und Speicher durch immer weniger Mitarbeiter betreut. Immer weniger Personen überblicken, was dort eigentlich konfiguriert wird und welche Mechanismen im Hintergrund arbeiten –Geschäftsgeheimnisse. Die Angriffsziele werden attraktiver – für alle Interessenten.

siehe dazu auch z. B.

 - [https://www.heise.de/newsticker/meldung/Datenleck-47-000-sensible-Dokumente-von-Autobauern-im-Internet-oeffentlich-4117617.html](https://www.heise.de/newsticker/meldung/Datenleck-47-000-sensible-Dokumente-von-Autobauern-im-Internet-oeffentlich-4117617.html)

Sie können vermutlich über die Nutzung spezialisierter Dienstleister auf Augenhöhe ein besseres Sicherheitsniveau erreichen als in der Public Cloud.


## Warum Tape Laufwerke im Backup Bereich ?

Tape Bänder

 - haben die geringsten Kosten pro GB,
 - eine sehr gute Haltbarkeit (meist sind 10 Jahre und 500 Schreibvorgänge, z. B. einmal wöchentlich problemlos zu bewältigen, da wird es bei Festplatten ggf. schon kritisch, vor allem durch die Zeit, bei meist fünf Jahren Garantie),
 - sind standardisiert – im Gegensatz zu speziellen Harddisk Langzeitspeichern,
 - das Speichervolumen ist einfach und kostengünstig erweiterbar,
 - gut transportierbar, weil leicht und wenig störanfällig (falls nötig – und im Gegensatz zu großen Festplatten)
 - gut lagerbar, weil sie wenig Platz benötigen.

 
## Aber durch die Datendeduplizierung und inkrementelle Backups klappen doch nur 50% aller Restores, zudem sind sie generell aufwendig?

Ja, das ist ein Argument. Allerdings nicht im Rahmen unseres Setups, in dem die Restores in den meisten Fällen über die Disks bereitgestellt werden. Zudem sichern wir hier Daten, bei denen man über die Deduplizierung wenig erreichen würde bzw. diese bereits vorab erfolgte oder der Einfachheit halber Komplettsicherungen erfolgen – ja, in diesem Fall geht es eben. Die Bänder werden somit als Mischung aus Backup und Archiv eingesetzt, so dass Restore Aufwände nicht groß ins Gewicht fallen. Und diese funktionieren dann auch.


## Für unser kleines Beispiel Setup haben wir folgende Hardware eingesetzt:

Zur Sammlung der Daten ein RAID bestehend aus SAS Platten:

8000GB Hitachi Ultrastar bzw. Western Digital He10 0F27406 7.200U/min 256MB 3.5" (8.9cm) SAS 12Gb/s

Bewertung:

- Enterprise Grade, d. h. für 24/7 Betrieb geeignet.
- relativ niedriger Verbrauch mit 5,8 Watt im Idle und 9,5 Watt bei Schreibvorgängen, typische Betriebskosten damit 16,94 Euro pro Platte im 24/7 Betrieb (nicht ganz so relevant, da im Rahmen des Projekts die Platten bei Bedarf hoch- bzw. runtergefahren werden)
- Großserie mit niedrigen Fehlerraten
- Guter Interface Durchsatz, guter Dauerdurchsatz für Festplatten

## RAID Controller
LSI Broadcom Megaraid SAS 9341-8i

Bewertung

- RAID Optionen 0, 1, 5, 10, 50
- geringer Verbrauch, ca. 13-19 Watt
- gute Erweiterbarkeit auf bis zu 32 Devices im RAID Modus oder 64 im JBOD Modus
- kann in 1HE Servern genutzt werden
- guter Durchsatz
- gut auch mit SSDs einsetzbar
- gute, robuste Sicherheitsfunktionen, z. B. zur Datenwiederherstellung
- weit verbreitet, gute Treiber Unterstützung, Langzeit Support
- größere Unabhängigkeit, Aktualität, Funktionsumfang als bei Mainboard RAID Controllern
- Nutzbar als Datenverteiler zwischen den angeschlossenen Devices, unabhängig von Prozessor und Mainboard
- PCIe3 x8, SAS 12Gb/s Anbindung
- preislich im Rahmen
- ohne aktiven Kühler, daher trotz geringem Verbrauch ziemlich warm, auch im Idle
- gelistet seit mindestens 2014, daher nicht mehr High Tech

Ein mögliches Upgrade wäre z. B. noch ein

LSI Broadcom Megaraid SAS3 9361-8i Controller

- höherer Durchsatz durch integrierten 1GB DDRIII Cache
- zusätzliche RAID Optionen 0, 1, 5, 6, 10, 50, 60
- erweiterte Features
- FastPath, CacheVault
- variable Strip Size, 64-1024KB

Siehe auch

- [https://www.thomas-krenn.com/de/wiki/MegaRAID_12Gbs_RAID_Controller](https://www.thomas-krenn.com/de/wiki/MegaRAID_12Gbs_RAID_Controller)

- [https://www.storagereview.com/lsi_megaraid_sas3_93618i_review](https://www.storagereview.com/lsi_megaraid_sas3_93618i_review)


## Tape Laufwerke

LTO Ultrium 6,7,8

Bewertung

- Standardisiert
- Guter Durchsatz
- große Datenspeichermenge
- unkompliziert
- mehrere Laufwerke gleichzeitig verwendbar, auch als Wechsler bzw. Tape Roboter
- diverse Sicherheitsfeatures
- Preislich ok, je neuer die Version, desto mehr Daten, Durchsatz und Kosten in Euro


## Backup Hardware

- Standard Hardware 19‘‘ bzw. Tower Server, keine besonderen Anforderungen, geringer Verbrauch
- Virtualisierter Betrieb möglich, so dass die Mehrfachverwendung der Hardware gegeben ist, alternativ automatisierter Start und Stopp der Hardware
- Trennung von Systembetrieb und Datensicherung über dedizierten RAID Controller


## Backup Software

Die Backups werden in diesem Beispiel Setup von der Opensource Software Bareos (Backup Archiving REcovery Open Sourced) ausgeführt. Es ist ein Fork vom weit verbreiteten Bacula, das selbst jedoch nur eine Read-Only Webconsole bietet. Kriterien bei der Auswahl waren unter anderem eine einfache Bedienung per Webkonsole, geringe Betriebsaufwände sowie die Unterstützung der Verschlüsselung der Bänder.

- Bareos (Backup Archiving REcovery Open Sourced)
- Betriebssystem Debian
- Unterstützung von
 - Hard- und Software Verschlüsselung
 - Hard- und Software Komprimierung
- MySQL/MariaDB als Katalog-Storage
- Gute Webkonsole für den Anwender
 - Ausreichend für "Sicherungen ausführen (auch Ad-Hoc)", "Restore ausführen", "Zeitpläne deaktivieren" 
 - Erweiterte Bedienung über die Kommandozeilen- Konsole (bconsole) ebenfalls über die WebConsole erreichbar
- Konfiguration erfolgt über diverse Konfigurationsdateien
 - Erhöhter Know-How Bedarf bei der initialen Konfiguration
- Tägliches Full-Backup der Backup-Disk (Platte) in einen Tape-Pool
 - Tägliches Wechseln der Bänder
 - Regelmäßiges Auslagern der Bänder
 - Nutzung des Bareos “Automatic Volume Recycling“
 - Bänder werden im Append-Modus beschrieben (es wird auch gesichert wenn mal zu wechseln vergessen wurde)
 - Dabei Remote Sicherung des Bareos Kataloges und den Bootstrap-Files in ein entferntes RZ
- Monitoring
 - aller Bareos Komponenten
 - Plattenplatz usw.

[https://www.bareos.org/en/](https://www.bareos.org/en/)  

 
## Exkurs Kosten
Wir haben uns die Mühe gemacht, die Kosten „on premise“ bzw. im RZ mit den Kosten des Weltmarktführers für die Public Cloud mit der günstigsten Preisoption (Zugriffe/Verfügbarkeit/Absicherung, ohne Restore Transfervolumen, das zusätzlich berechnet wird, Preisabfrage 7/2018) zu vergleichen. Unter Berücksichtigung der Administrationsaufwände, die wir "on premise" sowohl für das Setup als auch für den Betrieb mehr als großzügig einkalkuliert haben, kommen wir bei unserem Beispiel mit einem Datenvolumen, das mit einer Small and Medium Business SMB Workload vergleichbar ist, bereits zu Mehrkosten von 74% für die Public Cloud Lösung, bezogen auf das reine Datenvolumen zu Mehrkosten von 273%. Die on premise Lösung kann auch ohne nennenswerte Mehrkosten in jedem RZ lokal oder RZ übergreifend betrieben werden. Somit können wir die Angaben des TCO Kalkulators des Providers nicht nachvollziehen. Bei einem Datenvolumen des Mittelstands oder dem Enterprise Bereich werden es dann auch nicht mehr deren Cloud Vorzugskonditionen richten. Interessenten stellen wir gerne unsere Kalkulation zur Verfügung. siehe dazu auch

[https://www.heise.de/ix/meldung/Umfrage-Cloud-kannt-teuer-werden-4072912.html](https://www.heise.de/ix/meldung/Umfrage-Cloud-kannt-teuer-werden-4072912.html)


## Hardware Tipps & Tricks

### Installation des Controllers:

Nach Installation des RAID Controllers wird dieser vom Bios und vom Betriebssystem erkannt. Das Betriebssystem erkennt keine angeschlossenen Devices.

Setzen Sie im Bios die Option: UEFI Firmware from PCI-E devices, das hat in unserer Konfiguration geholfen.

Falls es immer noch nicht klappt. Wechseln Sie ggf. den Steckplatz, gelegentlich kommt es zu Inkompatibilitäten.

### Kühlung / Cooling

Achtung: Bei Einsatz des LSI Broadcom Megaraid SAS 9341-8i in einem Tower Server, befindet sich der Kühler des Kontrollers an der Unterseite – sunny side down. Damit ist er typischerweise unterhalb des Prozessors und damit abgeschnitten vom Hauptluftstrom des Prozessorkühlers bei Side oder Top Blower Kühlern und des rückwertigen Gehäuselüfters. Man kann sich mit dem Einbau eines zusätzlichen Lüfter im Gehäuseboden behelfen.

### Kabel / Anschlüsse – Cable/Connectors

Bevor Sie sich die Data Sheet, Specifications, Solutions Briefs, Approval Letters und vieles andere noch komplett durchlesen und feststellen, dass der Anschluss der 8000GB Hitachi Ultrastar bzw. Western Digital He10 0F27406 7.200U/min 256MB 3.5" (8.9cm) SAS 12Gb/s schwer oder nicht zu finden ist, geben wir ihnen des Rätsels Lösung: Sie benötigen entweder eine standardisierte Backplane oder ein Kabel mit einem SFF-8482 Stecker + 5,25" Molex Strom Stecker (der Stromstecker vor SATA Zeiten)

[https://www.pc-pitstop.com/sas_cables_adapters/sff-8482/](https://www.pc-pitstop.com/sas_cables_adapters/sff-8482/)

Danke dabei auch an die Kollegen von [http://www.ico.de](http://www.ico.de).

Um den Kontroller mit den zwei vierkanaligen SFF-8643 Anschlüssen mit den Platten und dem Tape Laufwerk miteinander zu verbinden, kann man somit folgendes Kabel verwenden

SAS 6Gb/s Anschlusskabel SFF-8643 Stecker auf SFF-8482 Stecker + 5,25" Molex Strom Stecker Schwarz, z. B. von InLine mit 1.00m. Dies ist etwas lang und etwas starr. ;)


## Schlagwörter

Backup, Archive, Tape Drive, Storage, Enterprise, Cloud, Raid, LSI Broadcom Megaraid, SAS 9341-8i, SFF 8643, SFF 8482, Molex, Backplane, Cooling, WD HE10, LTO, Ultrium, Setup, TCO, IT Operations


## Anmerkungen

Wir haben im Rahmen dieses Artikels keine umfassende Tests, Produktrecherchen, Vergleiche, Benchmarks, Best in Class Auswahl, RFIs, RFPs, Preisverhandlungen oder ähnliches durchgeführt. Die Auswahl der Lösungsstrategien, Komponenten oder Vorgehensweisen ist stark abhängig von den gegebenen Rahmenbedingungen des Projekts, daher sind in anderen Projekten eigene und vermutlich andere Entscheidungen zu treffen und eigene Setups auszuwählen. Der Artikel erhebt keinen Anspruch auf Vollständigkeit oder die Richtigkeit der getroffen Entscheidungen oder der Angaben. Er gibt lediglich die Erfahrungen im Rahmen des Projektes wieder. Eine eigene Bewertung durch den Leser ist erwünscht, wir freuen uns über Rückmeldungen dazu.

 