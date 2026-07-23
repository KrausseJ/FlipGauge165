import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

// Pixel-accurate implementation of design/layout/layout_coordinates.json.
// Target device: Garmin Forerunner 165, 390 x 390 px.
class Renderer {

    private var _design as DesignSystem;
    private var _panel;
    private var _separator;
    private var _secondPanel;
    private var _gaugeFrame;
    private var _gaugeFill;
    private var _gaugeArrowLeft;
    private var _gaugeArrowRight;
    private var _digit0;
    private var _digit1;
    private var _digit2;
    private var _digit3;
    private var _digit4;
    private var _digit5;
    private var _digit6;
    private var _digit7;
    private var _digit8;
    private var _digit9;

    function initialize() {
        _design = new DesignSystem();
        _panel = WatchUi.loadResource(Rez.Drawables.FlipPanel);
        _separator = WatchUi.loadResource(Rez.Drawables.FlipSeparator);
        _secondPanel = WatchUi.loadResource(Rez.Drawables.SecondPanel);
        _gaugeFrame = WatchUi.loadResource(Rez.Drawables.GaugeFrame);
        _gaugeFill = WatchUi.loadResource(Rez.Drawables.GaugeFill);
        _gaugeArrowLeft = WatchUi.loadResource(Rez.Drawables.GaugeArrowLeft);
        _gaugeArrowRight = WatchUi.loadResource(Rez.Drawables.GaugeArrowRight);
        _digit0 = WatchUi.loadResource(Rez.Drawables.FlipDigit0);
        _digit1 = WatchUi.loadResource(Rez.Drawables.FlipDigit1);
        _digit2 = WatchUi.loadResource(Rez.Drawables.FlipDigit2);
        _digit3 = WatchUi.loadResource(Rez.Drawables.FlipDigit3);
        _digit4 = WatchUi.loadResource(Rez.Drawables.FlipDigit4);
        _digit5 = WatchUi.loadResource(Rez.Drawables.FlipDigit5);
        _digit6 = WatchUi.loadResource(Rez.Drawables.FlipDigit6);
        _digit7 = WatchUi.loadResource(Rez.Drawables.FlipDigit7);
        _digit8 = WatchUi.loadResource(Rez.Drawables.FlipDigit8);
        _digit9 = WatchUi.loadResource(Rez.Drawables.FlipDigit9);
    }

    function draw(dc as Dc) as Void {
        var theme = _design.getTheme();
        dc.setColor(theme.getSecondaryTextColor(), theme.getCanvasColor());
        dc.clear();

        drawTitle(dc, theme);
        drawClock(dc, theme);
        drawBatteryGauge(dc, theme);
        drawBottomWidgets(dc, theme);
        drawDate(dc, theme);
    }

    private function drawTitle(dc as Dc, theme as Theme) as Void {
        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawLine(78, 34, 136, 34);
        dc.drawLine(254, 34, 312, 34);
        dc.drawText(195, 21, Graphics.FONT_SMALL, "TIME", Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawClock(dc as Dc, theme as Theme) as Void {
        var clockTime = System.getClockTime();
        var hourTens = clockTime.hour / 10;
        var hourOnes = clockTime.hour % 10;
        var minuteTens = clockTime.min / 10;
        var minuteOnes = clockTime.min % 10;

        // Master blueprint: panels at x 54,106,183,235; y 62; 49 x 72.
        drawFlipDigit(dc, 54, 62, hourTens);
        drawFlipDigit(dc, 106, 62, hourOnes);
        dc.drawBitmap(160, 74, _separator);
        drawFlipDigit(dc, 183, 62, minuteTens);
        drawFlipDigit(dc, 235, 62, minuteOnes);

        dc.drawBitmap(292, 62, _secondPanel);
        dc.setColor(theme.getPrimaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(314, 82, Graphics.FONT_SMALL, clockTime.sec.format("%02d"),
            Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(theme.getPrimaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(104, 135, Graphics.FONT_TINY, "- HOUR -", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(234, 135, Graphics.FONT_TINY, "- MINUTE -", Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawFlipDigit(dc as Dc, x as Number, y as Number, value as Number) as Void {
        dc.drawBitmap(x, y, _panel);
        dc.drawBitmap(x + 4, y + 3, getDigitBitmap(value));
    }

    private function getDigitBitmap(value as Number) {
        switch (value) {
            case 0: return _digit0;
            case 1: return _digit1;
            case 2: return _digit2;
            case 3: return _digit3;
            case 4: return _digit4;
            case 5: return _digit5;
            case 6: return _digit6;
            case 7: return _digit7;
            case 8: return _digit8;
            default: return _digit9;
        }
    }

    private function drawBatteryGauge(dc as Dc, theme as Theme) as Void {
        var stats = System.getSystemStats();
        var battery = stats.battery.toNumber();
        if (battery < 0) { battery = 0; }
        if (battery > 100) { battery = 100; }

        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(195, 153, Graphics.FONT_XTINY, "ELECTRIC-QUANTITY", Graphics.TEXT_JUSTIFY_CENTER);

        // Gauge frame at x 55, y 185. Inner track is x 72, y 214, 246 x 29.
        dc.drawBitmap(55, 185, _gaugeFrame);
        dc.drawBitmap(42, 214, _gaugeArrowLeft);
        dc.drawBitmap(323, 214, _gaugeArrowRight);

        // Segmented fill starts at x 86, y 225 and grows to 218 px.
        var fillWidth = 218 * battery / 100;
        if (fillWidth > 0) {
            dc.setClip(86, 225, fillWidth, 7);
            dc.drawBitmap(86, 225, _gaugeFill);
            dc.clearClip();
        }
    }

    private function drawBottomWidgets(dc as Dc, theme as Theme) as Void {
        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawLine(145, 272, 145, 329);
        dc.drawLine(245, 272, 245, 329);

        dc.setColor(0x14488D, Graphics.COLOR_TRANSPARENT);
        dc.drawText(96, 267, Graphics.FONT_XTINY, "STEP", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(0xB92D26, Graphics.COLOR_TRANSPARENT);
        dc.drawText(195, 267, Graphics.FONT_XTINY, "HEART", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(0xE0691E, Graphics.COLOR_TRANSPARENT);
        dc.drawText(294, 267, Graphics.FONT_XTINY, "CALORIE", Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(96, 296, Graphics.FONT_SMALL, "10342", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(195, 296, Graphics.FONT_SMALL, "74", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(294, 296, Graphics.FONT_SMALL, "2356", Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(0xB92D26, Graphics.COLOR_TRANSPARENT);
        dc.drawText(195, 323, Graphics.FONT_SMALL, "♥", Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawDate(dc as Dc, theme as Theme) as Void {
        var now = System.getClockTime();
        // Keep the established industrial NO. prefix; date can be made dynamic in the next data sprint.
        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawLine(72, 352, 127, 352);
        dc.drawLine(263, 352, 318, 352);
        dc.drawText(195, 338, Graphics.FONT_XTINY, "NO. 23 07 2026", Graphics.TEXT_JUSTIFY_CENTER);
    }
}
