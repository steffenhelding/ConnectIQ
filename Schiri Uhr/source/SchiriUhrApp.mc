using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Position as Position;

var dialogHeaderString;
//var dialogExtraHeaderString;

class SchiriUhrApp extends App.AppBase {
	var schiriUhrDelegate;
	
	//get Property Extra Time On or Off
	function getDefaultExtraTimerYesNo() {
		var extraTime = getProperty("extraTime");
		if (extraTime != null) {
			return extraTime;
		} else {
			return false; // Extra Time off
		}
	}
	//get Property Activity Data shown or not
	function getActivityData() {
		var activityData = getProperty("activitySettings");
		if (activityData != null) {
			return activityData;
		} else {
			return false; // Activity Data not shown
		}
	}
	//get Property which timer is big in the middle
	function getTimerSettings() {
		var timerSettings = getProperty("timerSettings");
		if (timerSettings != null) {
			return timerSettings;
		} else {
			return "ran";	//counting up timer big
		}
	}
	//get Property Extra Time Timer
	function getDefaultExtraTimerCount() {
		var time = getProperty("extraTimeCount");
		if (time != null) {
			return time;
		} else {
			return 900; // 15 min default extra timer count
		}
	}
 	//get Property Game Timer
    function getDefaultTimerCount() {
        var time = getProperty("time");
        if (time != null) {
            return time;
        } else {
            return 2400; // 40 min default timer count
        }
    }
    
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    	Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
	    dialogHeaderString = Ui.loadResource( Rez.Strings.DialogHeader );
//	    dialogExtraHeaderString = Ui.loadResource( Rez.Strings.ExtraDialogHeader );
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    	schiriUhrDelegate.stopRecording();
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }
    
    function onPosition(info) {
    	gps = info.accuracy;
    	Ui.requestUpdate();
    }

    // Return the initial view of your application here
    function getInitialView() {
    	schiriUhrDelegate = new SchiriUhrDelegate();
        return [ new SchiriUhrView(), schiriUhrDelegate ];
    }
    
    //Set Properties
    function setDefaultTimerCount(time) {
        setProperty("time", time);
    }
    function setExtraTimerCount(time) {
    	setProperty("extraTimeCount", time);
    }
    function setExtraTimeYesNo(extraTime) {
    	setProperty("extraTime", extraTime);
    }
	function setActivityData(activitySettings) {
    	setProperty("activitySettings", activitySettings);
    }
    function setTimerSettings(timerSettings) {
    	setProperty("timerSettings", timerSettings);
    }
}
