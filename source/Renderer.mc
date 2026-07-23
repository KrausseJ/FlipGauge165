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
        drawBottomWidgetsPlaceholder(dc, layout, theme);
        drawDatePlaceholder(dc, layout, theme);
    }

    private function drawTitle(dc as Dc, layout as LayoutConfig, theme as Theme) as Void {
        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawLine(96, 64, 150, 64);
        dc.drawLine(240, 64, 294, 64);
        dc.drawText(layout.getCenterX(), 51, Graphics.FONT_SMALL, "TIME", Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawBitmapClock(dc as Dc, layout as LayoutConfig, theme as Theme) as Void {
        var clockTime = System.getClockTime();
        var hourTens = clockTime.hour / 10;
        var hourOnes = clockTime.hour % 10;
        var minuteTens = clockTime.min / 10;
        var minuteOnes = clockTime.min % 10;

        var panelWidth = 72;
        var panelHeight = 92;
        var digitWidth = 49;
        var digitHeight = 82;
        var separatorWidth = 18;
        var secondsWidth = 50;
        var gap = 1;
        var totalWidth = (panelWidth * 4) + separatorWidth + secondsWidth + (gap * 5);
        var startX = (layout.getScreenSize() - totalWidth) / 2;
        var y = 82;

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
        dc.drawText(secondsX + (secondsWidth / 2), y + 36, Graphics.FONT_SMALL,
            clockTime.sec.format("%02d"), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
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
        var systemStats = System.getSystemStats();
        var battery = systemStats.battery.toNumber();
        if (battery < 0) { battery = 0; }
        if (battery > 100) { battery = 100; }

        var gaugeX = 36;
        var gaugeY = 204;
        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(layout.getCenterX(), 183, Graphics.FONT_XTINY, "ELECTRIC QUANTITY", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawBitmap(gaugeX, gaugeY, _gaugeFrame);
        dc.drawBitmap(8, gaugeY + 40, _gaugeArrowLeft);
        dc.drawBitmap(346, gaugeY + 40, _gaugeArrowRight);

        var fillX = gaugeX + 41;
        var fillY = gaugeY + 48;
        var fillWidth = 236 * battery / 100;
        if (fillWidth > 0) {
            dc.setClip(fillX, fillY, fillWidth, 12);
            dc.drawBitmap(fillX, fillY, _gaugeFill);
            dc.clearClip();
        }
    }

    private function drawBottomWidgetsPlaceholder(dc as Dc, layout as LayoutConfig, theme as Theme) as Void {
        var y = 300;
        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(110, y, Graphics.FONT_XTINY, "STEP", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(280, y, Graphics.FONT_XTINY, "HEART", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(theme.getAccentColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(110, y + 22, Graphics.FONT_SMALL, "10342", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(280, y + 22, Graphics.FONT_SMALL, "74", Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawDatePlaceholder(dc as Dc, layout as LayoutConfig, theme as Theme) as Void {
        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(layout.getCenterX(), 356, Graphics.FONT_XTINY, "NO. 23 07 2026", Graphics.TEXT_JUSTIFY_CENTER);
    }
}
