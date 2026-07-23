# FlipGauge165 – Premium Art Pass 1

This package upgrades the visual assets using 4× master artwork and high-quality downsampling to 390×390.

## Replace/copy

1. Replace `source/Renderer.mc`
2. Replace `resources/drawables/fullui_assets.xml`
3. Replace `resources/assets/fullui/`
4. Copy `design/fullui_4x/` into the repository

## Improvements

- more realistic ivory paper texture and vignette
- brushed-metal clock chassis
- refined flip panels and hinges
- refined red seconds module
- premium battery instrument
- 4× master assets for future revisions
- low-battery warning colors
- battery percentage
- dedicated AOD background asset
- heart icon integrated into the statistics area

## Important

The `drawAod()` method is included, but the watch-face view must call it during low-power rendering before AOD is fully active.
