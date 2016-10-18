using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time.Gregorian as Cal;
using Toybox.Application as App;
using Toybox.Time as Time;


class SchiriUhrMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

	function onMenuItem(item) {
        if (item == :item_45) {
            setTimer(2700);
        } else if (item == :item_40) {
            setTimer(2400);
        } else if (item == :item_35) {
            setTimer(2100);
        } else if (item == :item_30) {
            setTimer(1800);
        } else if (item == :item_custom) {
            var customDuration = Cal.duration( {:minutes=>1} );
            var customTimePicker = new Ui.NumberPicker(Ui.NUMBER_PICKER_TIME_MIN_SEC, customDuration);
            Ui.pushView(customTimePicker, new CustomTimePickerDelegate(), Ui.SLIDE_IMMEDIATE);
       	}  else if (item == :item_extratime) {
            var menu = new Rez.Menus.ExtraTimeTime();
        	menu.setTitle(Ui.loadResource( Rez.Strings.menuExtraTime ));
            Ui.pushView(menu, new SchiriUhrExtraTimeMenuDelegate(), Ui.SLIDE_IMMEDIATE);
        	return true;
        } else if (item == :item_screen) {
            var menu = new Rez.Menus.ScreenSettingsMenu();
        	menu.setTitle(Ui.loadResource( Rez.Strings.screen ));
            Ui.pushView(menu, new SchiriUhrScreenMenuDelegate(), Ui.SLIDE_IMMEDIATE);
        	return true;
        }
       
    }  
    
    
    function setTimer(time) {
        m_actualtimeReachedZero = false;
        m_TimeRunning = false;
		if( Toybox has :ActivityRecording ) {
            if( session != null && session.isRecording() ) {
                session.stop();
				session.discard();
				session = null;
            }
        }
		m_timer.stop();
        m_DefaultCount = time;
        App.getApp().setDefaultTimerCount(m_DefaultCount); // save new default to properties     
        m_actualtimeCount = m_DefaultCount;
        m_gametimeCount=0;
        lap = 1;
        hz = 1;
        Ui.requestUpdate();
    }
    
}

class CustomTimePickerDelegate extends Ui.NumberPickerDelegate {
	
	function initialize() {
		NumberPickerDelegate.initialize();
	}
	
    function onNumberPicked(value) {
        setCustomTimer(value.value());
    }
    
    function setCustomTimer(time) {
        m_actualtimeReachedZero = false;
        m_TimeRunning = false;
		if( Toybox has :ActivityRecording ) {
            if( session != null && session.isRecording() ) {
                session.stop();
				session.discard();
				session = null;
            }
        }
		m_timer.stop();
        m_DefaultCount = time;
        App.getApp().setDefaultTimerCount(m_DefaultCount); // save new default to properties     
        m_actualtimeCount = m_DefaultCount;
        m_gametimeCount=0;
        lap = 1;
        hz = 1;
        Ui.requestUpdate();
    }
}

class ConfirmationDialogDelegate extends Ui.ConfirmationDelegate {
    function initialize(){
    	ConfirmationDelegate.initialize();
    }
    
    function onResponse(value) {
       
        if (value == 0) {
            //session.stop();
			session.discard();
			session = null;
        }
        else {
            //session.stop();
			session.save();
			session = null;
        }
    }
}