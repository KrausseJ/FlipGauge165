import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class Renderer {

    private var _design as DesignSystem;
    private var _background;
    private var _clockChassis;
    private var _gaugeChassis;
    private var _digits;

    function initialize() {
        _design = new DesignSystem();

        _background = WatchUi.loadResource(Rez.Drawables.FullUiBackground);
        _clockChassis = WatchUi.loadResource(Rez.Drawables.ClockChassis);
        _gaugeChassis = WatchUi.loadResource(Rez.Drawables.GaugeChassis);

        _digits = [
            WatchUi.loadResource(Rez.Drawables.FullUiDigit0),
            WatchUi.loadResource(Rez.Drawables.FullUiDigit1),
            WatchUi.loadResource(Rez.Drawables.FullUiDigit2),
            WatchUi.loadResource(Rez.Drawables.FullUiDigit3),
            WatchUi.loadResource(Rez.Drawables.FullUiDigit4),
            WatchUi.loadResource(Rez.Drawables.FullUiDigit5),
            WatchUi.loadResource(Rez.Drawables.FullUiDigit6),
            WatchUi.loadResource(Rez.Drawables.FullUiDigit7),
            WatchUi.loadResource(Rez.Drawables.FullUiDigit8),
            WatchUi.loadResource(Rez.Drawables.FullUiDigit9)
        ];
    }

    function draw(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        dc.drawBitmap(0, 0, _background);
        drawClock(dc);
        drawGauge(dc);
        drawStats(dc);
        drawDate(dc);
    }

    private function drawClock(dc as Dc) as Void {
        var clockTime = System.getClockTime();
        var hour = clockTime.hour;
        var minute = clockTime.min;

        dc.drawBitmap(41, 52, _clockChassis);

        drawDigit(dc, 50, 64, hour / 10);
        drawDigit(dc, 104, 64, hour % 10);
        drawDigit(dc, 180, 64, minute / 10);
        drawDigit(dc, 234, 64, minute % 10);

        dc.setColor(0xF6F3EA, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            316,
            91,
            Graphics.FONT_MEDIUM,
            clockTime.sec.format("%02d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    private function drawDigit(dc as Dc, x as Number, y as Number, value as Number) as Void {
        dc.drawBitmap(x, y, _digits[value]);
    }

    private function drawGauge(dc as Dc) as Void {
        dc.drawBitmap(43, 164, _gaugeChassis);

        var battery = System.getSystemStats().battery;
        var activeSegments = (battery * 22 / 100).toNumber();

        dc.setColor(0x207334, Graphics.COLOR_TRANSPARENT);

        for (var i = 0; i < activeSegments; i += 1) {
            dc.fillRectangle(88 + (i * 7), 221, 5, 10);
        }
    }

    private function drawStats(dc as Dc) as Void {
        var steps = 0;
        var calories = 0;
        var heartRate = 0;

        try {
            var activity = ActivityMonitor.getInfo();
            if (activity.steps != null) {
                steps = activity.steps;
            }
            if (activity.calories != null) {
                calories = activity.calories;
            }
            if (activity.currentHeartRate != null) {
                heartRate = activity.currentHeartRate;
            }
        } catch (e) {
            // Keep zero values when the simulator/device has no data.
        }

        dc.setColor(0x1E1E1C, Graphics.COLOR_TRANSPARENT);

        dc.drawText(
            96,
            313,
            Graphics.FONT_MEDIUM,
            steps.format("%d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        dc.drawText(
            195,
            313,
            Graphics.FONT_MEDIUM,
            heartRate.format("%d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        dc.drawText(
            294,
            313,
            Graphics.FONT_MEDIUM,
            calories.format("%d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    private function drawDate(dc as Dc) as Void {
        var dateInfo = Gregorian.info(Time.now(), Time.FORMAT_SHORT);

        var dateText = Lang.format(
            "NO. $1$ $2$ $3$",
            [
                dateInfo.day.format("%02d"),
                dateInfo.month.format("%02d"),
                dateInfo.year.format("%04d")
            ]
        );

        dc.setColor(0x1E1E1C, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            195,
            357,
            Graphics.FONT_SMALL,
            dateText,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}
