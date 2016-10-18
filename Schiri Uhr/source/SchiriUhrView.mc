using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityRecording as Record;

var stringActualTime;
var stringGameTime;
var stringPauseTime;
var m_actualtimeCount = 0;
var m_gametimeCount = 0;
var m_PauseTimeCount = 0;
var m_PauseTimeVibCount = 0;
var gps = 0;

class SchiriUhrView extends Ui.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        onUpdate(dc);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }
	
    // Update the view
    function onUpdate(dc) {
    	
    	// Call the parent onUpdate function to redraw the layout
    	View.onUpdate(dc);
        
        //Format the display of Actual time
        var min = 0;
        var sec = m_actualtimeCount;
        
        // convert secs to mins and secs
        while (sec > 59) {
            min += 1;
            sec -= 60;
        }
    
        // make the secs pretty (heh heh)
        var stringActualTime;
        if (sec > 9) {
            stringActualTime = "" + min + ":" + sec;
        } else if (sec < 0){
        	stringActualTime = "" + min + ":00";
        } else {
            stringActualTime = "" + min + ":0" + sec;
        }
        
        //Format the display of Game time
        var minGameTime = 0;
        var secGameTime = m_gametimeCount;
        
        // convert secs to mins and secs
        while (secGameTime > 59) {
            minGameTime += 1;
            secGameTime -= 60;
        }
    
        // make the secs pretty (heh heh)
        var stringGameTime;
        if (secGameTime > 9) {
            stringGameTime = "" + minGameTime + ":" + secGameTime;
        } else {
            stringGameTime = "" + minGameTime + ":0" + secGameTime;
        }
        
        //Format the display of Pause time
        var pauseTimemin = 0;
        var pauseTimeSec = m_PauseTimeCount;
        
        // convert secs to mins and secs
        while (pauseTimeSec > 59) {
            pauseTimemin += 1;
            pauseTimeSec -= 60;
        }
    
        // make the secs pretty (heh heh)
        var stringPauseTime;
        if (pauseTimeSec > 9) {
            stringPauseTime = "" + pauseTimemin + ":" + pauseTimeSec;
        } else {
            stringPauseTime = "" + pauseTimemin + ":0" + pauseTimeSec;
        }
        //Format the display of Extra time
        var minExtraTime = 0;
        var secExtraTime = m_ExtraTimeCount;
        
        // convert secs to mins and secs
        while (secExtraTime > 59) {
            minExtraTime += 1;
            secExtraTime -= 60;
        }
    
        // make the secs pretty (heh heh)
        var stringExtraTime;
        if (secExtraTime > 9) {
            stringExtraTime = "" + minExtraTime + ":" + secExtraTime;
        } else {
            stringExtraTime = "" + minExtraTime + ":0" + secExtraTime;
        }
		
		//Show distance
        var distStr;
        if (distance > 0) {
            var distanceKmOrMiles = distance / kmOrMileInMeters;
            if (distanceKmOrMiles < 100) {
                distStr = distanceKmOrMiles.format("%.2f");
            } else {
                distStr = distanceKmOrMiles.format("%.1f");
            }
        } else {
            distStr = "0.00";
		}
        
        // Game Time Big in the middle of the Screen (White)
        dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
        if (timersettings.equals("ran")) {
        	dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2), Gfx.FONT_NUMBER_THAI_HOT, stringGameTime, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER );
        } else if (timersettings.equals("left")) {
        	if (!halftime and !extra_half) {
        	dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2), Gfx.FONT_NUMBER_THAI_HOT, stringActualTime, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER );
			}
		}
        
        //Draw "Press Back 3 times"
        if (backPressed) {
        	dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_GREEN );
        	dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2), Gfx.FONT_XTINY, Ui.loadResource( Rez.Strings.back ), Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER );
        }
        // Draw Activity Data
        if (activitydata) {
        	dc.setColor( Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT );
        	if (distanceUnits == Sys.UNIT_METRIC) {
        		dc.drawText( (dc.getWidth() - 2), (dc.getHeight() / 2 - 25), Gfx.FONT_TINY, distStr, Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_RIGHT );
        	} else {
        		dc.drawText( (dc.getWidth() - 2), (dc.getHeight() / 2 - 25), Gfx.FONT_TINY, distStr, Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_RIGHT );
        	}
        	if (hr != 0) {
        		dc.drawText( (dc.getWidth() - 2), (dc.getHeight() / 2 - 5), Gfx.FONT_TINY, hr, Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_RIGHT );
        	}      	
        }
        
        //Show Pause Timer if its not 0 or show clock
        dc.setColor( Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT );
        if (m_PauseTimeCount == 0){
			dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) + 58, Gfx.FONT_MEDIUM, getClockTime(), Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER );
        } else {
        	dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
        	dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) + 58, Gfx.FONT_LARGE, stringPauseTime, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER );
        }
        
        //Display the Remaining Time - small top, Show "Halftime" or "Game Time Over"
        if (halftime) {
        	dc.setColor( Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT );
        	dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) - 58, Gfx.FONT_MEDIUM, Ui.loadResource( Rez.Strings.halftime ), Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER );
        	if (timersettings.equals("left")) {
        		dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
        		dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2), Gfx.FONT_NUMBER_THAI_HOT, stringGameTime, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER );        	
        	}
        } else if (extra_half) {
        	dc.setColor( Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT );
        	dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) - 58, Gfx.FONT_MEDIUM, Ui.loadResource( Rez.Strings.extra_half ), Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER );         
			if (timersettings.equals("left")) {
        		dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
        		dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2), Gfx.FONT_NUMBER_THAI_HOT, stringGameTime, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER );        	
        	}        
        } else if (m_actualtimeCount <= 0 and timersettings.equals("ran")) {
        	dc.setColor( Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT );
        	dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) - 58, Gfx.FONT_MEDIUM, Ui.loadResource( Rez.Strings.game_over ), Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER );
        } else {
        	dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
        	if (timersettings.equals("ran")) {
        			dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) - 58, Gfx.FONT_NUMBER_MILD, stringActualTime , Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER );        	
        	} else if (timersettings.equals("left")) {
        		if (!halftime) {
        			dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) - 58, Gfx.FONT_NUMBER_MILD, stringGameTime , Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER );        	        	
        		}
        	}
        }
        
        //Show Extra Time if its enabled on the bottom of the screen
        if (extratime) {
        	dc.setColor( Gfx.COLOR_DK_GREEN, Gfx.COLOR_TRANSPARENT );
        	dc.drawText( (2), dc.getHeight() /2 + 55, Gfx.FONT_SMALL, Ui.loadResource( Rez.Strings.label_extra ) , Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_LEFT );
        	dc.drawText( (dc.getWidth()-2), dc.getHeight() /2 + 55, Gfx.FONT_SMALL, stringExtraTime , Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_RIGHT );
        }
        
        //GPS Strenght
        if (gps <= 1 or gps == null) {
            dc.setColor( Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT );
        	dc.drawText( (2), 0, Gfx.FONT_SMALL, "GPS" , Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_LEFT );
        } else if (gps <= 2) {
        	dc.setColor( Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT );
        	dc.drawText( (2), 0, Gfx.FONT_SMALL, "GPS" , Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_LEFT );
        } else {
        	dc.setColor( Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT );
        	dc.drawText( (2), 0, Gfx.FONT_SMALL, "GPS" , Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_LEFT );
        }
        
        //Which halftime is (going to) run
        dc.setColor( Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT );
        dc.drawText( ((dc.getWidth()-2)), 0, Gfx.FONT_SMALL, Ui.loadResource( Rez.Strings.ht ) + " " + hz , Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_RIGHT );
	}
    
    //Get actual clock time
    function getClockTime() {
        var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;
        if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        }
        var timeString = Lang.format("$1$:$2$", [hours.format("%02d"), clockTime.min.format("%02d")]);
        return timeString;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
