import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class Renderer {

    private var _background;
    private var _backgroundAod;
    private var _clockChassis;
    private var _gaugeChassis;
    private var _datePlate;
    private var _heartIcon;
    private var _stepIcon;
    private var _calorieIcon;
    private var _digits;
    private var _secondDigits;

    function initialize() {
        _background = WatchUi.loadResource(Rez.Drawables.FullUiBackground);
        _backgroundAod = WatchUi.loadResource(Rez.Drawables.FullUiBackgroundAod);
        _clockChassis = WatchUi.loadResource(Rez.Drawables.ClockChassis);
        _gaugeChassis = WatchUi.loadResource(Rez.Drawables.GaugeChassis);
        _datePlate = WatchUi.loadResource(Rez.Drawables.DatePlate);
        _heartIcon = WatchUi.loadResource(Rez.Drawables.HeartIcon);
        _stepIcon = WatchUi.loadResource(Rez.Drawables.StepIcon);
        _calorieIcon = WatchUi.loadResource(Rez.Drawables.CalorieIcon);

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

        _secondDigits = [
            WatchUi.loadResource(Rez.Drawables.SecondDigit0),
            WatchUi.loadResource(Rez.Drawables.SecondDigit1),
            WatchUi.loadResource(Rez.Drawables.SecondDigit2),
            WatchUi.loadResource(Rez.Drawables.SecondDigit3),
            WatchUi.loadResource(Rez.Drawables.SecondDigit4),
            WatchUi.loadResource(Rez.Drawables.SecondDigit5),
            WatchUi.loadResource(Rez.Drawables.SecondDigit6),
            WatchUi.loadResource(Rez.Drawables.SecondDigit7),
            WatchUi.loadResource(Rez.Drawables.SecondDigit8),
            WatchUi.loadResource(Rez.Drawables.SecondDigit9)
        ];
    }

    function draw(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawBitmap(0, 0, _background);

        drawTitle(dc);
        drawClock(dc, true);
        drawGauge(dc);
        drawStats(dc, true);
        drawDate(dc, true);
    }

    function drawAod(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawBitmap(0, 0, _backgroundAod);

        drawClock(dc, false);
        drawStats(dc, false);
        drawDate(dc, false);
    }

    private function drawTitle(dc as Dc) as Void {
        dc.setColor(0x2A2722, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(82, 42, 141, 42);
        dc.drawLine(249, 42, 308, 42);
        dc.drawText(195, 42, Graphics.FONT_SMALL, "TIME",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    private function drawClock(dc as Dc, showSeconds as Boolean) as Void {
        var clockTime = System.getClockTime();
        var hour = clockTime.hour;
        var minute = clockTime.min;

        dc.drawBitmap(32, 55, _clockChassis);

        drawDigit(dc, 48, 67, (hour / 10).toNumber());
        drawDigit(dc, 106, 67, (hour % 10).toNumber());
        drawDigit(dc, 195, 67, (minute / 10).toNumber());
        drawDigit(dc, 253, 67, (minute % 10).toNumber());

        if (showSeconds) {
            var sec = clockTime.sec;
            dc.drawBitmap(319, 72, _secondDigits[(sec / 10).toNumber()]);
            dc.drawBitmap(330, 72, _secondDigits[(sec % 10).toNumber()]);
        }
    }

    private function drawDigit(dc as Dc, x as Number, y as Number, value as Number) as Void {
        dc.drawBitmap(x, y, _digits[value.toNumber()]);
    }

    private function drawGauge(dc as Dc) as Void {
        dc.setColor(0x2A2722, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(63, 165, 111, 165);
        dc.drawLine(279, 165, 327, 165);
        dc.drawText(195, 165, Graphics.FONT_TINY, "ELECTRIC-QUANTITY",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.drawBitmap(37, 178, _gaugeChassis);

        var battery = System.getSystemStats().battery;
        var activeSegments = (battery * 25 / 100).toNumber();
        var gaugeColor = 0x299735;
        if (battery <= 15) {
            gaugeColor = 0xB02B23;
        } else if (battery <= 30) {
            gaugeColor = 0xD56B1D;
        }

        dc.setColor(gaugeColor, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < activeSegments; i += 1) {
            dc.fillRectangle(66 + (i * 8), 207, 5, 18);
        }

        dc.drawText(195, 244, Graphics.FONT_TINY, battery.format("%d") + "%",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    private function drawStats(dc as Dc, showIcons as Boolean) as Void {
        var steps = 0;
        var calories = 0;
        var heartRate = getLatestHeartRate();

        try {
            var activity = ActivityMonitor.getInfo();
            if (activity.steps != null) {
                steps = activity.steps;
            }
            if (activity.calories != null) {
                calories = activity.calories;
            }
        } catch (e) {
        }

        dc.setColor(0x235487, Graphics.COLOR_TRANSPARENT);
        dc.drawText(79, 272, Graphics.FONT_TINY, "STEP",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(0xA42D24, Graphics.COLOR_TRANSPARENT);
        dc.drawText(195, 272, Graphics.FONT_TINY, "HEART",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(0xCC5D1B, Graphics.COLOR_TRANSPARENT);
        dc.drawText(307, 272, Graphics.FONT_TINY, "CALORIE",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(0x24211D, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(132, 265, 132, 326);
        dc.drawLine(252, 265, 252, 326);

        if (showIcons) {
            dc.drawBitmap(39, 289, _stepIcon);
            dc.drawBitmap(145, 289, _heartIcon);
            dc.drawBitmap(260, 289, _calorieIcon);
        }

        dc.drawText(90, 306, Graphics.FONT_MEDIUM, steps.format("%d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(210, 306, Graphics.FONT_MEDIUM, heartRate.format("%d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(323, 306, Graphics.FONT_MEDIUM, calories.format("%d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    private function getLatestHeartRate() as Number {
        var heartRate = 0;
        try {
            var iterator = ActivityMonitor.getHeartRateHistory(1, true);
            var sample = iterator.next();
            if (sample != null && sample.heartRate != null &&
                sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
                heartRate = sample.heartRate;
            }
        } catch (e) {
        }
        return heartRate;
    }

    private function drawDate(dc as Dc, showPlate as Boolean) as Void {
        var dateInfo = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateText = Lang.format("NO. $1$ $2$ $3$", [
            dateInfo.day.format("%02d"),
            dateInfo.month.format("%02d"),
            dateInfo.year.format("%04d")
        ]);

        if (showPlate) {
            dc.drawBitmap(93, 340, _datePlate);
        }

        dc.setColor(showPlate ? 0x24211D : 0xD9D1C3, Graphics.COLOR_TRANSPARENT);
        dc.drawText(195, 356, Graphics.FONT_TINY, dateText,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}
