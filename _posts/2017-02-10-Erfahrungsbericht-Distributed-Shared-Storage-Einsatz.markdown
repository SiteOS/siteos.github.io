---
layout: post
author: Andreas Germeroth
authorkey: andreasgermeroth
title: Erfahrungsbericht - Distributed Shared Storage Einsatz
categories: Distributed Shared Storage
---
SiteOS hat im Rahmen des RZ Betriebs den Einsatz von Distributed Shared Storage Lösungen erprobt. Eine der Technologien
könnte nach den Erfahrungen aus der Validierung für einfache Anwendungsszenarien produktiv eingesetzt werden. Allerdings
sind wir auf eine extreme Reduzierung der I/O Operationen gestoßen – vergleichbare Effekte sind auch bei der Verwendung
von SAN Lösungen zu erwarten. Da wir zunehmend Projekte im Fast - und Big Data Umfeld bearbeiten, ist aus unserer Sicht
 der Einsatz von Shared Storages und SAN Lösungen dadurch nur in wenigen Szenarien möglich bzw sinnvoll.

## Distributed Shared Storage Überblick

Distributed Shared Storage Lösungen haben sich als kostengünstige und flexible Alternative zu SAN Lösungen etabliert, ein lokaler Storage (SSDs oder HDDs) wird in den Hosts verwendet und dann per Netzwerk repliziert. Voraussetzung dafür ist ein dediziertes Netzwerk für den Storageabgleich.

SiteOS hat zwei Lösungen im Rahmen eines Vorhabens auf Basis einer ProxMox Infrastruktur Umgebung validiert.

Mit Hilfe eines Shared Storage und Proxmox HA ist es möglich Virtuelle Maschinen (VMs) rein über die Infrastruktur hochverfügbar zu machen. Proxmox HA setzt einen Shared Storage voraus. Dazu kann man verschiedene Alternativen einsetzen.

Man kann dann VMs in Sekunden von einem Node auf den anderen umziehen per Migrate (dasselbe macht auch Proxmox-HA) weil die Daten bereits auf allen Nodes liegen. Leider ist derzeit bei LXC Containern keine Live-Migration möglich, d.h. es wird dann ein stoppen, umziehen und starten gemacht (geht aber auch in ca. 10 Sekunden). Mit echten VMs (KVM) geht auch eine Live-Migration ohne spürbare Betriebsunterbrechnung.

<p align="center"><img src="{{site.baseurl}}/images/2017/2017-02-10-Zeichnung-Artikel-Distributed-Shared-Storage.png"/></p>

Links

 - [https://pve.proxmox.com/wiki/High_Availability_Cluster_4.x](https://pve.proxmox.com/wiki/High_Availability_Cluster_4.x)
 - [https://www.storitback.de/service/san.html](https://www.storitback.de/service/san.html)
 - [https://pve.proxmox.com/wiki/Main_Page](https://pve.proxmox.com/wiki/Main_Page)


## DRBD Version 9

DRBD9 (Distributed Replicated Block Device) in der Version 9 ist in ProxMox 4.X derzeit noch als Technologie-Preview zu sehen und wird nicht für den Produktiveinsatz empfohlen.

Seit DRBD9 ist es möglich mehr als zwei Nodes zu verwenden. DRBD ist kurz gesagt ein über ein dediziertes Netzwerk repliziertes Mirroring von lokalen Festplatten. Seit DRBD9 ist es möglich mehr als zwei Nodes zu verwenden. Bei einem der Nodes im Cluster ist der Storage auf dem Host, auf die VM gerade läuft der Primary, die der restlichen laufen im Secondary Modus. Dies soll ein gleichzeitiges Beschreiben auf unterschiedlichen Nodes verhindern um Splitbrain Situationen vorzubeugen.

Es wurde ein drei Node Cluster nach dieser Anleitung auf lokale Partitionen der Nodes aufgesetzt.

[https://pve.proxmox.com/wiki/DRBD9](https://pve.proxmox.com/wiki/DRBD9)


## Eindrücke und Erfahrungen beim Betrieb

DRBD9 ist zurecht noch ein Technologiepreview. Solange an den Hosts nichts verändert wurde lief es in unserer Infrastruktur stabil. Es gab jedoch diverse Probleme nach Reboots, dass die Devices nicht mehr automatisch gesycnt wurden, bis hin zu komplett Datenverlusten nach Paketupdates/-patches oder Reboots. Es half dann nur noch die DRBD Umgebung komplett neu zu initialisieren. Die GUI-Integration in Proxmox 4.X ist praktisch nicht vorhanden, somit muß man alle Arbeiten auf der Kommandozeile ausführen. Weiterhin werden die Konfigdateien aus DRBD8 nicht verwendet, so dass alle Einstellungen beim Bootvorgang per drbdmanage manuell gesetzt werden müssen.

Links

 - [https://de.wikipedia.org/wiki/DRBD](https://de.wikipedia.org/wiki/DRBD)
 - [https://www.drbd.org/en/doc/users-guide-90](https://www.drbd.org/en/doc/users-guide-90)
 - [https://forum.proxmox.com/threads/proxmox-4-2-drbd-node-does-not-reconnect-after-reboot-connection-loss.29564/](https://forum.proxmox.com/threads/proxmox-4-2-drbd-node-does-not-reconnect-after-reboot-connection-loss.29564/)
 - [https://forum.proxmox.com/threads/drbd-online-verifiy-all-does-not-work.29639/#post-150904](https://forum.proxmox.com/threads/drbd-online-verifiy-all-does-not-work.29639/#post-150904)


## Ceph Version Jewel

Als Alternative zu DRBD gibt es Ceph als Distributed Storage Lösung, damit ist es ebenfalls möglich zusammen mit Proxmox HA VMs rein über die Infrastruktur hochverfügbar zu machen. Ceph ist mehr als ein Mirroring der Platten, es bietet weiterreichende Konfigurationsmöglichkeiten zur Verteilung der Daten.

Es wurde ein drei Node Cluster mit der Version Jewel nach dieser Anleitung auf lokale Partitionen der Nodes aufgesetzt:

[https://pve.proxmox.com/wiki/Ceph_Server](https://pve.proxmox.com/wiki/Ceph_Server)

Sobald keine komplette Disk sondern nur eine Partition zur Verfügung steht, muss zum Erzeugen der OSDs manuell eingegriffen werden. Weiterhin musste bei der Konfiguration des Keyrings manuell eingegriffen werden. Ansonsten lief die Installation relativ problemlos.

### Eindrücke und Erfahrungen beim Betrieb

Ceph lief nach Reboots und Paketupdates stabil. Das Setzen von speziellen Tunables hat die Performance wesentlich beeinflusst. Zudem ist die GUI Integration in ProxMox mittlerweile sehr gut gelungen. Man kann den Storage über die Oberfläche hinzufügen, OSDs verwalten, Pools verwalten und den Storage überwachen.

Links

 - [http://ceph.com/](http://ceph.com/)
 - [https://www.thomas-krenn.com/de/wiki/Ceph](https://www.thomas-krenn.com/de/wiki/Ceph)
 - [https://de.wikipedia.org/wiki/Ceph](https://de.wikipedia.org/wiki/Ceph)
 - [http://docs.ceph.com/docs/jewel/start/intro/](http://docs.ceph.com/docs/jewel/start/intro/)
 - [http://ceph.com/planet/creating-a-ceph-osd-from-a-designated-disk-partition/](http://ceph.com/planet/creating-a-ceph-osd-from-a-designated-disk-partition/)
 - [https://forum.proxmox.com/threads/ceph-rbd-error-rbd-couldnt-connect-to-cluster-500.18319/](https://forum.proxmox.com/threads/ceph-rbd-error-rbd-couldnt-connect-to-cluster-500.18319/)


## Vergleich der I/O Performance

Wir haben für die beiden Technologien in einem typischen Anwendungsszenario I/O Faktoren ermittelt und diese mit Referenzmessungen ohne Shared Storage verglichen. Die I/O Faktoren beruhen jeweils auf Messreihen, um die Auswirkungen von Messungenauigkeiten zu reduzieren.

| VM Konfiguration/Umgebung      |  Faktor |
|----------|:-------------:|
| Baremetal HDD als Referenz | 4,08 |
| Virtualisierung über KVM (SSD)   |   17,81 |
| Virtualisierung über LXC Container SSD |    19,39 |
| Verteilter Storage DRBD HDD KVM (writethrough) |    1,82 |
| Verteilter Storage CEPH HDD KVM(writethrough) |    1,37 |


### Interpretation der Messergebnisse
Für Anwendungen mit hohen I/O Anforderungen sind lokale Storages aus SSD-Speichern um Größenordnungen schneller als replizierte Storages. In typischen Workloads kann die Replikation von Daten durch die Applikationen erfolgen, da diese von einem mindestens doppelt so hohem I/O für die eigentlichen Lese- und vor allem Schreiboperationen profitierten – vorausgesetzt, die Anforderungen für die Datenkonsistenz sind nicht auf Transaktionslevel (CAP Theorem). . Analog gilt dies für dedizierte SAN Lösungen. Über optimierte Soft- (Datendeduplikation, …) und Hardware (Fiber, RAID, …) Konfigurationen können diese Unterschiede sicher reduziert werden – der lokale Zugriff erfolgt jedoch immer am schnellsten. SSD vs. HDD? Wir bevorzugen die derzeit noch etwas teurere Variante – die Kennzahlen sprechen Bände…

## Fazit

Im Vergleich zu SAN oder NAS Systemen hat man bei diesen beiden Technologien den Vorteil, dass der Zugriff auf die Daten immer lokal erfolgt und nicht über Netzwerk. Nichts desto trotz gibt es auch bei DRBD und Ceph erhebliche Einschränkungen/Verzögerungen beim Schreibzugriff um die Konsistenz zu gewährleisten.

Ceph macht insgesamt den stabileren Eindruck und es ist bereits gut in die Proxmox GUI integriert. Von der Performance ist es scheinbar nicht so hardwareabhängig wie DRBD. Im Schnitt ist die Ceph Performance besser, die maximale Performance war wiederum auf einer speziellen Hardware bei DRBD besser.

Für Performance relevante Applikationen wie z.B. Datenbanken oder NoSQL kommen bei SiteOS weiterhin LXC Container mit lokalen SSD Platten zum Einsatz. Das Clustering wird dann mit den jeweiligen „Bordmitteln“ der Komponente erledigt, d.h. es kommen mehrere VMs auf verschiedenen Nodes zum Einsatz. Der Setupaufwand ist ggfs. höher und komplexer, die Performance von lokalen SSD-Platten ist jedoch fast unschlagbar. Und das bei wesentlich geringeren Investitionskosten im Vergleich zu dedizierten SANs Lösungen.

Der Artikel erhebt keinen Anspruch auf Vollständigkeit oder Richtigkeit und gibt lediglich die Erfahrungen in der SiteOS Infrastruktur wieder. Eine eigene Bewertung durch den Leser ist erwünscht.