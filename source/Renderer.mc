import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;

class Renderer {

    private var _theme as Theme;
    private var _layout as LayoutConfig;

    function initialize() {
        _theme = new Theme();
        _layout = new LayoutConfig();
    }

    function draw(dc as Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.setColor(
            _theme.getPrimaryTextColor(),
            _theme.getBackgroundColor()
        );

        dc.clear();

        var clockTime = System.getClockTime();

        var timeString = Lang.format(
            "$1$:$2$",
            [
                clockTime.hour.format("%02d"),
                clockTime.min.format("%02d")
            ]
        );

        dc.drawText(
            _layout.getCenterX(width),
            _layout.getCenterY(height),
            Graphics.FONT_LARGE,
            timeString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

}