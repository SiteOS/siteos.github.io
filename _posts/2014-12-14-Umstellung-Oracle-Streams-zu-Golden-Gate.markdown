---
layout: post
title: "Umstellung Orcale Streams zu Golden Gate"
categories: Oracle, Oracle Streams, Golden Gate
---
Höherer Durchsatz bei größeren Datenmengen
Im Rahmen einer größeren Softwareumstellung bei einem Kunden wurde auch der von der verteilten Datenbank verwendete Replikationsmechanismus erfolgreich von Oracle Streams Replication auf Oracle GoldenGate umgestellt. Dabei handelt es sich um eine sternförmige, unidirektionale Verteilung, d.h. die Änderungen werden in einer zentralen Datenbank eingesteuert und von da an die anderen Datenbanken übertragen.

GoldenGate ist nach Oracle Streams Replication (OSR) die aktuellste Replikationslösung von Oracle. Oracle Streams wird zwar in der aktuellen Version 12c der Datenbank noch unterstützt, ist aber für folgende Versionen bereits abgekündigt, d.h. wird nicht mehr weiterentwickelt und unterstützt werden.

GoldenGate ist modular aufgebaut und weitestgehend unabhängig von der Software der beteiligten Datenbanken. Wie bei Oracle Streams gibt es einen Prozess zum Auslesen der Änderungen (Extract), einen Transport-Mechanismus, sowie einen Prozess, um die Änderungen in der Ziel-Datenbank anzuwenden (Replicat). Während der Extract- und Replicat-Prozess ähnlich funktionieren wie  Capture und Apply bei Oracle-Streams, ist der Transport der Change-Records komplett anders realisiert. Die Änderungen werden vom Extract in sogenannte Trail-Files geschrieben und auf den Host der Ziel-Datenbank übertragen. Dort werden die Informationen vom Replicat ausgelesen und in der Datenbank angewendet. Bei Oracle Streams erfolgte die Übertragung mittels Advanced Queues, also mit Datenbank-Mitteln.

Auch wenn bei Oracle vom Extract- und Replicat-Prozess Datenbank-Komponenten wie z.B. der Logminer verwendet werden, existieren diese Prozesse doch außerhalb der Datenbank und sind von ihr relativ unabhängig.

GoldenGate wird separat installiert und kann unter einem eigenem, vom Datenbank-User verschiedenen, User ausgeführt werden. Je nach eingesetztem Betriebssystem (z.B. Linux, Windows, Unix …) und genutzter Datenbank-Software (Oracle, MySQL, Microsoft SQL-Server …) werden verschiedene Oracle GoldenGate Installationspakete angeboten. Dadurch ist GoldenGate in heterogenen Datenbank-Umgebungen einsetzbar.

Wie auch bei Oracle Streams Replication sind alle denkbaren Replikations-Topologien darstellbar, wie On2-to-One (uni- oder bidirektional), Peer-to-Peer, Broadcast usw..

Die Konfiguration erfolgt mittels Parameter-Dateien für die einzelnen Prozesse. Diese können sowohl mit dem GoldenGate-Kommandozeilenwerkzeug ggsci als auch mit einem beliebigen Text-Editor bearbeitet werden. Das ist deutlich einfacher und weniger fehleranfällig als die Konfiguration über spezielle Package-Methoden bei Oracle Streams. Dabei können sowohl Filter auf Objekte (Schemata, Tabellen, …), Inhalte (z.B. abhängig vom Wert einer Spalte) und anderes als auch Transformationen an abweichende Tabellenstrukturen zwischen den beteiligten Datenbanken eingerichtet werden. Auch ob und wie Replikationsfehler behandelt werden sollen wird in den Parameterdateien festgelegt. Generell ist die Einrichtung einer Replikation mit GoldenGate somit deutlich einfacher geworden.

Das Monitoring ist auf verschiedenen Wegen möglich. So können über die Kommandozeile  auch Statusinformationen (Status der Prozesse, Durchsatz, Latenzen) zu einzelnen Prozessen oder der Replikation generell abgerufen werden. Für die Nutzung der CloudControl (ab Version 12) von Oracle gibt es eigene Plugins, die die Überwachung darin integrieren. Außerdem bietet Oracle eine eigenständige Java-basierte Client-Server-Anwendung namens Oracle GoldenGate Monitor für die Administration an. Sowohl das CloudControl-Plugin als auch der GoldenGate Monitor müssen separat lizensiert werden.

Die ohnehin gute Performance von Oracle Streams ist mit GoldenGate nochmals verbessert worden. Vor allem die Verlagerung des Transports der Change-Records aus der Datenbank dürfte die höheren Durchsatzraten erklären. Insbesondere bei größeren Datenmengen (ab ca. 100MB) erfolgt die Übertragung etwa doppelt so schnell.

Die Latenzzeiten von Oracle Streams und GoldenGate sind ähnlich, wobei hier der Zugriff des Extract-Prozesses auf die Änderungs-Informationen eine Rolle spielt. Je nach Datenbank variiert diese Zugriffsmethode. Bei einer Oracle-Datenbank kann auf die Redo-Logs (online und archiviert) zugegriffen werden oder direkt der in der Datenbank integrierte Logminer-Service verwendet werden. Letztere Methode bedeutet eine geringere Last und erlaubt die geringsten Latenzzeiten, da die Redo-Informationen bereits verfügbar sind, bevor sie in die Redo-Logs geschrieben worden.

Oracle GoldenGate vereint die sehr gute Integration der Datenbank-Zugriffe (Extract und Replicat) mit einer übersichtlichen Konfiguration sowie der flexiblen Verarbeitung und Übertragung außerhalb der Datenbank. Im Ergebnis kann eine Replikation einfacher und schneller eingerichtet werden und die Datenübertragung ist deutlich performanter, was besonders bei Massen-Änderungen deutlich wird. 