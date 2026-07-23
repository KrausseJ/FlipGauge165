using Toybox.Graphics as Graphics;
using Toybox.WatchUi as WatchUi;

class FlipGaugeView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
    }

    function onShow() {
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_LARGE,
            "FlipGauge",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    function onHide() {
    }

    function onEnterSleep() {
    }

    function onExitSleep() {
        WatchUi.requestUpdate();
    }
}
