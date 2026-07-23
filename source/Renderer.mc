import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

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
        var layout = _design.getLayout();

        dc.setColor(theme.getSecondaryTextColor(), theme.getCanvasColor());
        dc.clear();

        drawTitle(dc, layout, theme);
        drawBitmapClock(dc, layout, theme);
        drawBatteryGauge(dc, layout, theme);
        drawBottomWidgets(dc, layout, theme);
        drawDate(dc, layout, theme);
    }

    private function drawTitle(dc as Dc, layout as LayoutConfig, theme as Theme) as Void {
        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawLine(105, 44, 155, 44);
        dc.drawLine(235, 44, 285, 44);
        dc.drawText(195, 31, Graphics.FONT_SMALL, "TIME", Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawBitmapClock(dc as Dc, layout as LayoutConfig, theme as Theme) as Void {
        var clockTime = System.getClockTime();
        var hourTens = clockTime.hour / 10;
        var hourOnes = clockTime.hour % 10;
        var minuteTens = clockTime.min / 10;
        var minuteOnes = clockTime.min % 10;

        // Fixed 390 x 390 layout grid
        var panelWidth = 62;
        var panelHeight = 82;
        var digitWidth = 40;
        var digitHeight = 70;
        var separatorWidth = 14;
        var secondsWidth = 43;
        var gap = 2;
        var totalWidth = (panelWidth * 4) + separatorWidth + secondsWidth + (gap * 5);
        var startX = (390 - totalWidth) / 2;
        var y = 58;

        var x1 = startX;
        var x2 = x1 + panelWidth + gap;
        var separatorX = x2 + panelWidth + gap;
        var x3 = separatorX + separatorWidth + gap;
        var x4 = x3 + panelWidth + gap;
        var secondsX = x4 + panelWidth + gap;

        drawFlipDigit(dc, x1, y, hourTens, panelWidth, panelHeight, digitWidth, digitHeight);
        drawFlipDigit(dc, x2, y, hourOnes, panelWidth, panelHeight, digitWidth, digitHeight);
        dc.drawBitmap(separatorX, y, _separator);
        drawFlipDigit(dc, x3, y, minuteTens, panelWidth, panelHeight, digitWidth, digitHeight);
        drawFlipDigit(dc, x4, y, minuteOnes, panelWidth, panelHeight, digitWidth, digitHeight);
        dc.drawBitmap(secondsX, y, _secondPanel);

        dc.setColor(theme.getPrimaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(secondsX + (secondsWidth / 2), y + 31, Graphics.FONT_XTINY,
            clockTime.sec.format("%02d"), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(theme.getPrimaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(x1 + panelWidth, 142, Graphics.FONT_TINY, "HOUR", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(x3 + panelWidth, 142, Graphics.FONT_TINY, "MINUTE", Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawFlipDigit(dc as Dc, x as Number, y as Number, value as Number,
        panelWidth as Number, panelHeight as Number, digitWidth as Number, digitHeight as Number) as Void {
        dc.drawBitmap(x, y, _panel);
        dc.drawBitmap(x + ((panelWidth - digitWidth) / 2), y + ((panelHeight - digitHeight) / 2), getDigitBitmap(value));
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

    private function drawBatteryGauge(dc as Dc, layout as LayoutConfig, theme as Theme) as Void {
        var stats = System.getSystemStats();
        var battery = stats.battery.toNumber();
        if (battery < 0) { battery = 0; }
        if (battery > 100) { battery = 100; }

        var gaugeX = 48;
        var gaugeY = 179;

        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(195, 159, Graphics.FONT_XTINY, "ELECTRIC QUANTITY", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawBitmap(gaugeX, gaugeY, _gaugeFrame);
        dc.drawBitmap(17, gaugeY + 30, _gaugeArrowLeft);
        dc.drawBitmap(345, gaugeY + 30, _gaugeArrowRight);

        // Compact gauge geometry after asset resampling
        var fillX = gaugeX + 38;
        var fillY = gaugeY + 40;
        var fillWidth = 216 * battery / 100;
        if (fillWidth > 0) {
            dc.setClip(fillX, fillY, fillWidth, 10);
            dc.drawBitmap(fillX, fillY, _gaugeFill);
            dc.clearClip();
        }
    }

    private function drawBottomWidgets(dc as Dc, layout as LayoutConfig, theme as Theme) as Void {
        var labelY = 270;
        var valueY = 292;

        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(78, labelY, Graphics.FONT_XTINY, "STEP", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(195, labelY, Graphics.FONT_XTINY, "HEART", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(312, labelY, Graphics.FONT_XTINY, "CALORIE", Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawLine(132, 272, 132, 326);
        dc.drawLine(258, 272, 258, 326);

        dc.setColor(theme.getAccentColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(78, valueY, Graphics.FONT_SMALL, "10342", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(195, valueY, Graphics.FONT_SMALL, "74", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(312, valueY, Graphics.FONT_SMALL, "2356", Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawDate(dc as Dc, layout as LayoutConfig, theme as Theme) as Void {
        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawLine(82, 351, 137, 351);
        dc.drawLine(253, 351, 308, 351);
        dc.drawText(195, 338, Graphics.FONT_XTINY, "NO. 23 07 2026", Graphics.TEXT_JUSTIFY_CENTER);
    }
}
