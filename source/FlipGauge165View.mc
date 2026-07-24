import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class FlipGauge165View extends WatchUi.WatchFace {

    private var _renderer as Renderer;
    private var _isSleeping as Boolean = false;

    function initialize() {
        WatchFace.initialize();
        _renderer = new Renderer();
    }

    function onLayout(dc as Dc) as Void {
    }

    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        if (_isSleeping) {
            _renderer.drawAod(dc);
        } else {
            _renderer.draw(dc);
        }
    }

    function onHide() as Void {
    }

    function onExitSleep() as Void {
        _isSleeping = false;
        WatchUi.requestUpdate();
    }

    function onEnterSleep() as Void {
        _isSleeping = true;
        WatchUi.requestUpdate();
    }
}
