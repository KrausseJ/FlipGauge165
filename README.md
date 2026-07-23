# FlipGauge165 – Master Implementation

This package implements the approved `design/layout/layout_coordinates.json` for the 390 × 390 Forerunner 165 display.

## Replace/copy

1. Replace `source/Renderer.mc`.
2. Replace `resources/drawables/flip_assets.xml`.
3. Replace the complete folders:
   - `resources/assets/flip/`
   - `resources/assets/gauge/`
4. Build and run the simulator.

## Fixed master coordinates

- Title baseline: y = 34
- Four flip panels: (54,62), (106,62), (183,62), (235,62), each 49 × 72
- Separator: (160,74), 18 × 48
- Seconds: (292,62), 44 × 72
- Battery title: y = 165
- Battery track: (72,214), 246 × 29
- Widgets: y = 266–329
- Date baseline: y = 352

The clock and battery are dynamic. Step, heart, calorie and date values remain controlled placeholders for this layout-validation build.
