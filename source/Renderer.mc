import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class Renderer {

    private var _layout;
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
        _layout = new LayoutConfig();

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
        var y = _layout.titleY();
        dc.setColor(0x2A2722, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(74, y, 137, y);
        dc.drawLine(253, y, 316, y);
        dc.drawText(_layout.centerX(), y, Graphics.FONT_SMALL, "TIME",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    private function drawClock(dc as Dc, showSeconds) as Void {
        var clockTime = System.getClockTime();
        var hour = clockTime.hour;
        var minute = clockTime.min;

        dc.drawScaledBitmap(
            _layout.clockX(), _layout.clockY(),
            _layout.clockWidth(), _layout.clockHeight(),
            _clockChassis
        );

        drawDigit(dc, _layout.hourDigit1X(), (hour / 10).toNumber());
        drawDigit(dc, _layout.hourDigit2X(), (hour % 10).toNumber());
        drawDigit(dc, _layout.minuteDigit1X(), (minute / 10).toNumber());
        drawDigit(dc, _layout.minuteDigit2X(), (minute % 10).toNumber());

        if (showSeconds) {
            var sec = clockTime.sec;
            drawSecondDigit(dc, _layout.secondDigit1X(), (sec / 10).toNumber());
            drawSecondDigit(dc, _layout.secondDigit2X(), (sec % 10).toNumber());
        }
    }

    private function drawDigit(dc as Dc, x, value) as Void {
        dc.drawScaledBitmap(
            x, _layout.digitY(),
            _layout.digitWidth(), _layout.digitHeight(),
            _digits[value.toNumber()]
        );
    }

    private function drawSecondDigit(dc as Dc, x, value) as Void {
        dc.drawScaledBitmap(
            x, _layout.secondDigitY(),
            _layout.secondDigitWidth(), _layout.secondDigitHeight(),
            _secondDigits[value.toNumber()]
        );
    }

    private function drawGauge(dc as Dc) as Void {
        var titleY = _layout.gaugeTitleY();
        dc.setColor(0x2A2722, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(50, titleY, 86, titleY);
        dc.drawLine(304, titleY, 340, titleY);
        dc.drawText(_layout.centerX(), titleY, Graphics.FONT_XTINY, "ELECTRIC QUANTITY",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.drawScaledBitmap(
            _layout.gaugeX(), _layout.gaugeY(),
            _layout.gaugeWidth(), _layout.gaugeHeight(),
            _gaugeChassis
        );

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
            dc.fillRectangle(_layout.gaugeSegmentX() + (i * 9),
                _layout.gaugeSegmentY(), 6, 17);
        }

        dc.setColor(0x26863A, Graphics.COLOR_TRANSPARENT);
        dc.drawText(_layout.centerX(), _layout.gaugePercentY(), Graphics.FONT_XTINY,
            battery.format("%d") + "%",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    private function drawStats(dc as Dc, showIcons) as Void {
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

        var titleY = _layout.statsTitleY();
        var valueY = _layout.statsValueY();

        dc.setColor(0x235487, Graphics.COLOR_TRANSPARENT);
        dc.drawText(76, titleY, Graphics.FONT_XTINY, "STEP",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(0xA42D24, Graphics.COLOR_TRANSPARENT);
        dc.drawText(195, titleY, Graphics.FONT_XTINY, "HEART",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(0xCC5D1B, Graphics.COLOR_TRANSPARENT);
        dc.drawText(310, titleY, Graphics.FONT_XTINY, "CALORIE",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(0x24211D, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(132, _layout.statsDividerTop(), 132, _layout.statsDividerBottom());
        dc.drawLine(254, _layout.statsDividerTop(), 254, _layout.statsDividerBottom());

        if (showIcons) {
            dc.drawBitmap(46, _layout.statsIconY(), _stepIcon);
            dc.drawBitmap(157, _layout.statsIconY(), _heartIcon);
            dc.drawBitmap(270, _layout.statsIconY(), _calorieIcon);
        }

        dc.drawText(91, valueY, Graphics.FONT_SMALL, steps.format("%d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(210, valueY, Graphics.FONT_SMALL, heartRate.format("%d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(323, valueY, Graphics.FONT_SMALL, calories.format("%d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    private function getLatestHeartRate() {
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

    private function drawDate(dc as Dc, showPlate) as Void {
        var dateInfo = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateText = Lang.format("NO. $1$ $2$ $3$", [
            dateInfo.day.format("%02d"),
            dateInfo.month.format("%02d"),
            dateInfo.year.format("%04d")
        ]);

        if (showPlate) {
            dc.drawScaledBitmap(
                _layout.datePlateX(), _layout.datePlateY(),
                _layout.datePlateWidth(), _layout.datePlateHeight(),
                _datePlate
            );
        }

        dc.setColor(showPlate ? 0x24211D : 0xD9D1C3, Graphics.COLOR_TRANSPARENT);
        dc.drawText(_layout.centerX(), _layout.dateTextY(), Graphics.FONT_XTINY, dateText,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}
