import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class Renderer {

    private var _design as DesignSystem;

    private var _panel;
    private var _separator;
    private var _secondPanel;

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
        drawGaugePlaceholder(dc, layout, theme);
        drawBottomWidgetsPlaceholder(dc, layout, theme);
        drawDatePlaceholder(dc, layout, theme);
    }

    private function drawTitle(dc as Dc, layout as LayoutConfig, theme as Theme) as Void {
        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            layout.getCenterX(),
            layout.getTitleY(),
            Graphics.FONT_SMALL,
            "TIME",
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    private function drawBitmapClock(dc as Dc, layout as LayoutConfig, theme as Theme) as Void {
        var clockTime = System.getClockTime();

        var hourTens = clockTime.hour / 10;
        var hourOnes = clockTime.hour % 10;
        var minuteTens = clockTime.min / 10;
        var minuteOnes = clockTime.min % 10;

        var panelWidth = 70;
        var panelHeight = 88;
        var digitWidth = 52;
        var digitHeight = 80;
        var separatorWidth = 18;
        var secondsWidth = 54;
        var gap = 2;

        var totalWidth = (panelWidth * 4) + separatorWidth + secondsWidth + (gap * 5);
        var startX = (layout.getScreenSize() - totalWidth) / 2;
        var y = layout.getClockY();

        var x1 = startX;
        var x2 = x1 + panelWidth + gap;
        var separatorX = x2 + panelWidth + gap;
        var x3 = separatorX + separatorWidth + gap;
        var x4 = x3 + panelWidth + gap;
        var secondsX = x4 + panelWidth + gap;

        drawFlipDigit(dc, x1, y, hourTens, digitWidth, digitHeight);
        drawFlipDigit(dc, x2, y, hourOnes, digitWidth, digitHeight);

        dc.drawBitmap(separatorX, y + 4, _separator);

        drawFlipDigit(dc, x3, y, minuteTens, digitWidth, digitHeight);
        drawFlipDigit(dc, x4, y, minuteOnes, digitWidth, digitHeight);

        dc.drawBitmap(secondsX, y, _secondPanel);

        dc.setColor(theme.getPrimaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            secondsX + (secondsWidth / 2),
            y + 32,
            Graphics.FONT_SMALL,
            clockTime.sec.format("%02d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    private function drawFlipDigit(
        dc as Dc,
        x as Number,
        y as Number,
        value as Number,
        digitWidth as Number,
        digitHeight as Number
    ) as Void {
        dc.drawBitmap(x, y, _panel);
        dc.drawBitmap(
            x + ((70 - digitWidth) / 2),
            y + ((88 - digitHeight) / 2),
            getDigitBitmap(value)
        );
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

    private function drawGaugePlaceholder(dc as Dc, layout as LayoutConfig, theme as Theme) as Void {
        var x = layout.getSideMargin();
        var y = layout.getGaugeY();
        var width = layout.getScreenSize() - (layout.getSideMargin() * 2);
        var height = layout.getGaugeHeight();

        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            layout.getCenterX(),
            y - 22,
            Graphics.FONT_XTINY,
            "ELECTRIC QUANTITY",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.setColor(theme.getPanelColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(x, y, width, height, 8);

        dc.setColor(theme.getGaugeColor(), Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(x + 8, y + 8, (width - 16) * 70 / 100, height - 16);
    }

    private function drawBottomWidgetsPlaceholder(dc as Dc, layout as LayoutConfig, theme as Theme) as Void {
        var y = layout.getWidgetY();

        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(110, y, Graphics.FONT_XTINY, "STEP", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(280, y, Graphics.FONT_XTINY, "HEART", Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(theme.getAccentColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(110, y + 20, Graphics.FONT_SMALL, "10342", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(280, y + 20, Graphics.FONT_SMALL, "74", Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawDatePlaceholder(dc as Dc, layout as LayoutConfig, theme as Theme) as Void {
        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            layout.getCenterX(),
            layout.getDateY(),
            Graphics.FONT_XTINY,
            "NO. 23 07 2026",
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }
}
