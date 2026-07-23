import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;

class Renderer {

    private var _design as DesignSystem;

    function initialize() {
        _design = new DesignSystem();
    }

    function draw(dc as Dc) as Void {
        var theme = _design.getTheme();
        var layout = _design.getLayout();

        dc.setColor(
            theme.getSecondaryTextColor(),
            theme.getCanvasColor()
        );

        dc.clear();

        drawTitle(dc, layout, theme);
        drawClockPlaceholder(dc, layout, theme);
        drawGaugePlaceholder(dc, layout, theme);
        drawBottomWidgetsPlaceholder(dc, layout, theme);
        drawDatePlaceholder(dc, layout, theme);
    }

    private function drawTitle(
        dc as Dc,
        layout as LayoutConfig,
        theme as Theme
    ) as Void {
        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);

        dc.drawText(
            layout.getCenterX(),
            layout.getTitleY(),
            Graphics.FONT_SMALL,
            "TIME",
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    private function drawClockPlaceholder(
        dc as Dc,
        layout as LayoutConfig,
        theme as Theme
    ) as Void {
        var clockTime = System.getClockTime();

        var timeString = Lang.format(
            "$1$:$2$",
            [
                clockTime.hour.format("%02d"),
                clockTime.min.format("%02d")
            ]
        );

        var x = layout.getSideMargin();
        var y = layout.getClockY();
        var width = layout.getScreenSize() - (layout.getSideMargin() * 2);
        var height = layout.getClockHeight();

        dc.setColor(theme.getPanelColor(), Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(x, y, width, height, 12);

        dc.setColor(theme.getPrimaryTextColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            layout.getCenterX(),
            y + (height / 2),
            Graphics.FONT_NUMBER_THAI_HOT,
            timeString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        dc.setColor(theme.getPanelHighlightColor(), Graphics.COLOR_TRANSPARENT);
        dc.drawLine(x + 8, y + (height / 2), x + width - 8, y + (height / 2));
    }

    private function drawGaugePlaceholder(
        dc as Dc,
        layout as LayoutConfig,
        theme as Theme
    ) as Void {
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

    private function drawBottomWidgetsPlaceholder(
        dc as Dc,
        layout as LayoutConfig,
        theme as Theme
    ) as Void {
        var y = layout.getWidgetY();

        dc.setColor(theme.getSecondaryTextColor(), Graphics.COLOR_TRANSPARENT);

        dc.drawText(
            110,
            y,
            Graphics.FONT_XTINY,
            "STEP",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            280,
            y,
            Graphics.FONT_XTINY,
            "HEART",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.setColor(theme.getAccentColor(), Graphics.COLOR_TRANSPARENT);

        dc.drawText(
            110,
            y + 20,
            Graphics.FONT_SMALL,
            "10342",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            280,
            y + 20,
            Graphics.FONT_SMALL,
            "74",
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    private function drawDatePlaceholder(
        dc as Dc,
        layout as LayoutConfig,
        theme as Theme
    ) as Void {
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