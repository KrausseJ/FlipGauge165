# FlipGauge165 – Sprint 3C

Enthalten:

- vergroesserte und ueberarbeitete Flip-Panels
- schmalere Premium-Ziffern V2
- optimierter Doppelpunkt
- buendig ausgerichtetes Sekundenmodul
- dynamische Batterieanzeige im Stil der freigegebenen Vorlage
- aktualisierter Renderer

## Installation

1. `source/Renderer.mc` ersetzen.
2. `resources/assets/flip/` ersetzen.
3. `resources/assets/gauge/` neu kopieren.
4. `resources/drawables/flip_assets.xml` ersetzen.
5. Projekt kompilieren und im Simulator starten.

Die Batterieanzeige verwendet `System.getSystemStats().battery` und skaliert die Segmentanzeige dynamisch.
