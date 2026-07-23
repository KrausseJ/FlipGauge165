using Toybox.Application as Application;
using Toybox.WatchUi as WatchUi;

class FlipGaugeApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        return [ new FlipGaugeView() ];
    }
}
