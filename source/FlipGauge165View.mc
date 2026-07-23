import Toybox.Graphics;
import Toybox.WatchUi;

class FlipGauge165View extends WatchUi.WatchFace {

    private var _renderer as Renderer;

    function initialize() {
        WatchFace.initialize();

        _renderer = new Renderer();
    }

    function onLayout(dc as Dc) as Void {
    }

    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        _renderer.draw(dc);
    }

    function onHide() as Void {
    }

    function onExitSleep() as Void {
    }

    function onEnterSleep() as Void {
    }

}