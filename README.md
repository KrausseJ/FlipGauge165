# FlipGauge165 – Full UI Implementation

This package changes the rendering strategy:

- one static 390×390 background asset
- one complete flip-clock chassis
- one complete battery-instrument chassis
- only digits, seconds, battery segments and live values are drawn dynamically

## Replace/copy

1. Replace `source/Renderer.mc`.
2. Copy `resources/assets/fullui/`.
3. Copy `resources/drawables/fullui_assets.xml`.

The previous `flip_assets.xml`, `resources/assets/flip/` and `resources/assets/gauge/`
may remain temporarily, but are no longer used by this renderer.

## Dynamic values

- time and seconds
- battery percentage
- steps
- current heart rate
- calories
- date

The simulator can show zero for activity values until test data is configured.
