import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class RendererPremium {
    private const CX = 195;
    private const FACE_RADIUS = 174;

    private const CLOCK_X = 60;
    private const CLOCK_Y = 50;
    private const DIGIT_Y = 65;
    private const SEC_Y = 68;

    private const GAUGE_TITLE_Y = 149;
    private const GAUGE_X = 60;
    private const GAUGE_Y = 161;
    private const GAUGE_SEGMENT_Y = 193;

    private const BATTERY_VALUE_Y = 239;
    private const STATS_LABEL_Y = 265;
    private const STATS_ICON_Y = 288;
    private const STATS_VALUE_Y = 297;

    private const DATE_X = 110;
    private const DATE_Y = 326;

    private var _clockBase = null;
    private var _gaugeBase = null;
    private var _dateBase = null;
    private var _labelTime = null;
    private var _labelElectric = null;
    private var _labelStep = null;
    private var _labelHeart = null;
    private var _stepIcon = null;
    private var _heartIcon = null;

    private var _mainDigits;
    private var _mainDigitValues;
    private var _secDigits;
    private var _secDigitValues;

    function initialize() {
        _mainDigits = [null, null, null, null];
        _mainDigitValues = [-1, -1, -1, -1];
        _secDigits = [null, null];
        _secDigitValues = [-1, -1];
    }

    function draw(dc as Dc) as Void {
        ensureStaticAssets();
        drawBackground(dc);
        drawHeader(dc);
        drawClock(dc);
        drawGauge(dc);
        drawStatistics(dc);
        drawDate(dc, true);
    }

    function drawAod(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        var now = System.getClockTime();
        dc.setColor(0xD8D0C2, Graphics.COLOR_TRANSPARENT);
        dc.drawText(CX, 178, Graphics.FONT_LARGE,
            now.hour.format("%02d") + ":" + now.min.format("%02d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        drawDate(dc, false);
    }

    private function ensureStaticAssets() as Void {
        if (_clockBase == null) {
            _clockBase = WatchUi.loadResource(Rez.Drawables.AssetClockBase);
            _gaugeBase = WatchUi.loadResource(Rez.Drawables.AssetGaugeBase);
            _dateBase = WatchUi.loadResource(Rez.Drawables.AssetDateBase);
            _labelTime = WatchUi.loadResource(Rez.Drawables.AssetLabelTime);
            _labelElectric = WatchUi.loadResource(Rez.Drawables.AssetLabelElectric);
            _labelStep = WatchUi.loadResource(Rez.Drawables.AssetLabelStep);
            _labelHeart = WatchUi.loadResource(Rez.Drawables.AssetLabelHeart);
            _stepIcon = WatchUi.loadResource(Rez.Drawables.AssetStepIcon);
            _heartIcon = WatchUi.loadResource(Rez.Drawables.AssetHeartIcon);
        }
    }

    private function drawBackground(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(0xF5EFE4, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(CX, CX, FACE_RADIUS);
        dc.setColor(0xD8CFC1, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < 24; i += 1) {
            var x = 55 + ((i * 61) % 280);
            var y = 45 + ((i * 83) % 300);
            var dx = x - CX;
            var dy = y - CX;
            if ((dx * dx) + (dy * dy) < 28500) { dc.fillCircle(x, y, 1); }
        }
    }

    private function drawHeader(dc as Dc) as Void {
        dc.setColor(0x3B352F, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(100, 38, 132, 38);
        dc.drawLine(258, 38, 290, 38);
        dc.drawBitmap(135, 26, _labelTime);
    }

    private function drawClock(dc as Dc) as Void {
        dc.drawBitmap(CLOCK_X, CLOCK_Y, _clockBase);
        var now = System.getClockTime();
        var h = now.hour.format("%02d");
        var m = now.min.format("%02d");
        var values = [h.substring(0,1).toNumber(), h.substring(1,2).toNumber(),
                      m.substring(0,1).toNumber(), m.substring(1,2).toNumber()];
        var xs = [80, 128, 196, 244];
        for (var i = 0; i < 4; i += 1) {
            dc.drawBitmap(xs[i], DIGIT_Y, getMainDigit(i, values[i]));
        }
        drawSeconds(dc, now.sec);
    }

    private function drawSeconds(dc as Dc, seconds) as Void {
        var t = seconds.format("%02d");
        dc.drawBitmap(294, SEC_Y, getSecDigit(0, t.substring(0,1).toNumber()));
        dc.drawBitmap(306, SEC_Y, getSecDigit(1, t.substring(1,2).toNumber()));
    }

    private function drawGauge(dc as Dc) as Void {
        dc.setColor(0x3B352F, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(61, GAUGE_TITLE_Y, 82, GAUGE_TITLE_Y);
        dc.drawLine(308, GAUGE_TITLE_Y, 329, GAUGE_TITLE_Y);
        dc.drawBitmap(85, GAUGE_TITLE_Y - 10, _labelElectric);
        dc.drawBitmap(GAUGE_X, GAUGE_Y, _gaugeBase);

        var battery = System.getSystemStats().battery;
        var count = 16;
        var active = (((battery * count) + 99) / 100).toNumber();
        var fill = 0x2EAA42;
        if (battery <= 15) { fill = 0xB52E24; }
        else if (battery <= 30) { fill = 0xD8751C; }
        for (var i = 0; i < count; i += 1) {
            var sx = 88 + (i * 13);
            dc.setColor((i < active) ? fill : 0x242524, Graphics.COLOR_TRANSPARENT);
            dc.fillRoundedRectangle(sx, GAUGE_SEGMENT_Y, 9, 14, 3);
            if (i < active) {
                dc.setColor(0x66D46B, Graphics.COLOR_TRANSPARENT);
                dc.fillRoundedRectangle(sx + 2, GAUGE_SEGMENT_Y + 1, 2, 11, 1);
            }
        }
    }

    private function drawStatistics(dc as Dc) as Void {
        var steps = 0;
        try { var info = ActivityMonitor.getInfo(); if (info.steps != null) { steps = info.steps; } } catch (e) {}
        var heart = getLatestHeartRate();
        var battery = System.getSystemStats().battery;

        dc.setColor(0x2A7E37, Graphics.COLOR_TRANSPARENT);
        dc.drawText(CX, BATTERY_VALUE_Y, Graphics.FONT_SMALL, battery.format("%d") + "%",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(0xA59A8D, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(CX, 266, CX, 313);
        dc.drawBitmap(99, STATS_LABEL_Y, _labelStep);
        dc.drawBitmap(222, STATS_LABEL_Y, _labelHeart);
        dc.drawBitmap(99, STATS_ICON_Y, _stepIcon);
        dc.drawBitmap(225, STATS_ICON_Y, _heartIcon);
        dc.setColor(0x24211D, Graphics.COLOR_TRANSPARENT);
        dc.drawText(151, STATS_VALUE_Y, Graphics.FONT_SMALL, steps.format("%05d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(280, STATS_VALUE_Y, Graphics.FONT_SMALL, heart.format("%03d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    private function drawDate(dc as Dc, showPlate) as Void {
        var dateInfo = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var text = Lang.format("$1$ / $2$ / $3$", [dateInfo.day.format("%02d"),
            dateInfo.month.format("%02d"), dateInfo.year.format("%04d")]);
        if (showPlate) { dc.drawBitmap(DATE_X, DATE_Y, _dateBase); }
        dc.setColor(showPlate ? 0x24211D : 0xD9D1C3, Graphics.COLOR_TRANSPARENT);
        dc.drawText(CX, showPlate ? DATE_Y + 14 : 220, Graphics.FONT_XTINY, text,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    private function getMainDigit(slot, value) {
        if (_mainDigits[slot] == null || _mainDigitValues[slot] != value) {
            _mainDigits[slot] = loadMainDigit(value); _mainDigitValues[slot] = value;
        }
        return _mainDigits[slot];
    }
    private function getSecDigit(slot, value) {
        if (_secDigits[slot] == null || _secDigitValues[slot] != value) {
            _secDigits[slot] = loadSecDigit(value); _secDigitValues[slot] = value;
        }
        return _secDigits[slot];
    }
    private function loadMainDigit(value) {
        switch (value) {
            case 0: return WatchUi.loadResource(Rez.Drawables.AssetMainDigit0);
            case 1: return WatchUi.loadResource(Rez.Drawables.AssetMainDigit1);
            case 2: return WatchUi.loadResource(Rez.Drawables.AssetMainDigit2);
            case 3: return WatchUi.loadResource(Rez.Drawables.AssetMainDigit3);
            case 4: return WatchUi.loadResource(Rez.Drawables.AssetMainDigit4);
            case 5: return WatchUi.loadResource(Rez.Drawables.AssetMainDigit5);
            case 6: return WatchUi.loadResource(Rez.Drawables.AssetMainDigit6);
            case 7: return WatchUi.loadResource(Rez.Drawables.AssetMainDigit7);
            case 8: return WatchUi.loadResource(Rez.Drawables.AssetMainDigit8);
            default: return WatchUi.loadResource(Rez.Drawables.AssetMainDigit9);
        }
    }
    private function loadSecDigit(value) {
        switch (value) {
            case 0: return WatchUi.loadResource(Rez.Drawables.AssetSecDigit0);
            case 1: return WatchUi.loadResource(Rez.Drawables.AssetSecDigit1);
            case 2: return WatchUi.loadResource(Rez.Drawables.AssetSecDigit2);
            case 3: return WatchUi.loadResource(Rez.Drawables.AssetSecDigit3);
            case 4: return WatchUi.loadResource(Rez.Drawables.AssetSecDigit4);
            case 5: return WatchUi.loadResource(Rez.Drawables.AssetSecDigit5);
            case 6: return WatchUi.loadResource(Rez.Drawables.AssetSecDigit6);
            case 7: return WatchUi.loadResource(Rez.Drawables.AssetSecDigit7);
            case 8: return WatchUi.loadResource(Rez.Drawables.AssetSecDigit8);
            default: return WatchUi.loadResource(Rez.Drawables.AssetSecDigit9);
        }
    }
    private function getLatestHeartRate() {
        var hr = 0;
        try {
            var iterator = ActivityMonitor.getHeartRateHistory(1, true);
            var sample = iterator.next();
            if (sample != null && sample.heartRate != null && sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) { hr = sample.heartRate; }
        } catch (e) {}
        return hr;
    }
}
