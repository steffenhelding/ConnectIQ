using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.ActivityRecording as Record;
using Toybox.Timer as Timer;
using Toybox.Application as App;
using Toybox.Attention as Attn;
using Toybox.Activity as Act;

var m_timer;
var m_DefaultCount;
var m_ExtraTimeCount;
var m_TimeRunning = false;
var m_actualtimeReachedZero = false;
var m_showPauseTimer = false;
var m_Paused = true;
var session = null;
var lap = 1;
var hz = 1;
var halftime = false;
var extra_half = false;
var m_clockTimer;
var m_savedClockMins;
var m_backTimer;
var back = 0;
var backPressed = false;
var distanceUnits;
var kmOrMileInMeters;
var info;
var hr = 0;
var distance = 0;


class SchiriUhrDelegate extends Ui.BehaviorDelegate {

    function stopRecording() {
        if( Toybox has :ActivityRecording ) {
            if( session != null && session.isRecording() ) {
                session.stop();
                session.discard();
                session = null;
                Ui.requestUpdate();
            }
        }
    }
    function initialize() {
    	BehaviorDelegate.initialize();	
    	m_timer = new Timer.Timer();
    	m_DefaultCount = App.getApp().getDefaultTimerCount();
    	m_ExtraTimeCount = App.getApp().getDefaultExtraTimerCount();
    	extratime = App.getApp().getDefaultExtraTimerYesNo();
        m_actualtimeCount = m_DefaultCount;
        m_clockTimer = new Timer.Timer();
        m_clockTimer.start( method(:clockTimerCallback), 1000, true );
        m_savedClockMins = Sys.getClockTime().min;
        m_backTimer = new Timer.Timer();
        distanceUnits = System.getDeviceSettings().distanceUnits;
        if (distanceUnits == System.UNIT_METRIC) {
            kmOrMileInMeters = 1000;
        } else {
            kmOrMileInMeters = 1610;
		}
		activitydata = App.getApp().getActivityData();
		timersettings  = App.getApp().getTimerSettings();
		
    }
    function getActivity() {
    	info = Act.getActivityInfo();
    	if (info != null) {
    		hr = info.currentHeartRate != null ? info.currentHeartRate : 0;
        	distance = info.elapsedDistance != null ? info.elapsedDistance : 0;
	    }
	    
    }
    
    var dialog;
    function pushDialog() {
        dialog = new Ui.Confirmation(dialogHeaderString);
        Ui.pushView(dialog, new ConfirmationDialogDelegate(), Ui.SLIDE_IMMEDIATE);
        return true;
    }
    
    function pushExtraDialog() {
        dialog = new Ui.Confirmation(dialogExtraHeaderString);
        Ui.pushView(dialog, new ConfirmationExtraDialogDelegate(), Ui.SLIDE_IMMEDIATE);
        return true;
    }
    
    function onKey(key) {
    	//System.println(key.getKey());
    	
        if (key.getKey() == Ui.KEY_ENTER) {
            startStop();
        } else if (key.getKey() == Ui.KEY_ESC) {			// AW V1.1 prevent the app to close while recording
        	if (session != null) {
        		back += 1;
        		m_backTimer.stop();
        		if (!backPressed) {
        			m_backTimer.start(method(:backTimerCallback), 3000, false);
        		}
        		backPressed = true;
        		Ui.requestUpdate();
        		if (back <= 2) {
        			return true;
        		} else {
        			return false;
        		}
        	} else {
        		return false;
        	}
        } else if (key.getKey() == Ui.KEY_UP) {
        	onMenu();
        }
	}
	
	function backTimerCallback() {
    	backPressed = false;
    	back = 0;
    	Ui.requestUpdate();
    }
	
	function alert() {
        var vibe = [new Attn.VibeProfile(  50, 125 ),
                    new Attn.VibeProfile( 100, 125 ),
                    new Attn.VibeProfile(  50, 125 ),
                    new Attn.VibeProfile( 100, 125 )];
        Attn.vibrate(vibe);
        
     }
     
	function startStop() {   
	    alert();
	    if (m_TimeRunning) { 							//Count Down Time running
	    	if (m_actualtimeReachedZero) {				//and reached zero
				if (lap == 1) {							//Start halftime if the first Half (lap)
					session.addLap();
					lap += 1;
					halftime = true;
					m_actualtimeCount = m_DefaultCount;
					m_gametimeCount = 0;
					m_PauseTimeCount = 0;
					m_TimeRunning = false;
					//m_timer.stop();
					Ui.requestUpdate();
				} else if (lap == 3 or lap == 5) {		//At the end of the second half decide if an extra time is needed or not
					if (!extratime) {					//If extra time is not needed, reset the app
						session.stop();
						pushDialog();
						m_timer.stop();
						m_actualtimeCount = m_DefaultCount;
						m_gametimeCount = 0;
						m_PauseTimeCount = 0;
						//System.println("bin ich hier?");
						lap = 1;
						hz = 1;
						m_TimeRunning = false;
						Ui.requestUpdate();
						m_clockTimer.start( method(:clockTimerCallback), 1000, true );
					} else {							//If extra time is needed, show halftime sign and edit the times
						session.addLap();
						halftime = false;
						extra_half = true;
						m_actualtimeCount = m_ExtraTimeCount;
						m_gametimeCount = 0;
						m_PauseTimeCount = 0;
						m_TimeRunning = false;
						lap += 1;
					}
				} else if (lap == 7) {					//At the end of the extra time reset the app
					session.stop();
					pushDialog();
					m_timer.stop();
					m_actualtimeCount = m_DefaultCount;
					m_gametimeCount = 0;
					m_PauseTimeCount = 0;
					//System.println("bin ich hier?");
					lap = 1;
					m_TimeRunning = false;
					hz = 1;
					Ui.requestUpdate();
					m_clockTimer.start( method(:clockTimerCallback), 1000, true );
					
				}
	    	} else {									//Count Down Time not reached zero
	    		m_Paused = true;
	    		m_TimeRunning = false;
	    	}
	    } else if (!m_TimeRunning) {					//Count Down Time not running
	    	//m_showClock = true;
	    	m_Paused = false;
	    	m_TimeRunning = true;
	    	if (lap == 2) {								//Begin the second half
					session.addLap();
					m_gametimeCount = m_DefaultCount;
					m_actualtimeReachedZero = false;
					m_Paused = false;
	    			m_TimeRunning = true;
	    			halftime = false;
	    			hz += 1;
	    			m_timer.stop();
	    			m_timer.start( method(:timerCallback), 1000, true );
	    			lap += 1;
			}
			if (lap == 4) {								//Begin the first half of extra time
					session.addLap();
					m_gametimeCount = m_DefaultCount*2;
					m_actualtimeReachedZero = false;
					m_Paused = false;
	    			m_TimeRunning = true;
	    			halftime = false;
	    			extra_half = false;
	    			hz += 1;
	    			m_timer.stop();
	    			m_timer.start( method(:timerCallback), 1000, true );
	    			lap += 1;
			}
			if (lap == 6) {								//Begin the second half of extra time
					session.addLap();
					m_gametimeCount = m_DefaultCount*2 + m_ExtraTimeCount;
					m_actualtimeReachedZero = false;
					m_Paused = false;
	    			m_TimeRunning = true;
	    			halftime = false;
	    			extra_half = false;
	    			hz += 1;
	    			m_timer.stop();
	    			m_timer.start( method(:timerCallback), 1000, true );
	    			lap += 1;
			}
			
	    	if( Toybox has :ActivityRecording ) {			//Beginn first half
	            if( ( session == null ) || ( session.isRecording() == false ) ) {
	                session = Record.createSession({:name=>"Run", :sport=>Record.SPORT_RUNNING});
	                session.start();
	                
	                m_showPauseTimer = true;
	                m_timer.start( method(:timerCallback), 1000, true );
	                m_clockTimer.stop();
	                //System.println("Start");
	                
	        	}
	    	}		
   		}
   	}
    
    //Refresh the screen if the minutes of the clock were changed
    function clockTimerCallback() {
    	if (m_savedClockMins != Sys.getClockTime().min) {
            m_savedClockMins = Sys.getClockTime().min;
            Ui.requestUpdate();
        }    	
    }
    
    function timerCallback() {
    	if (halftime or extra_half) {
    		m_gametimeCount += 1;
	    } else{
	    	if (!m_Paused) {
	    		m_actualtimeCount -= 1;
	    		m_gametimeCount += 1;
	    	}
	    	if (m_Paused) {
	    		m_gametimeCount += 1;
	    		m_PauseTimeCount += 1;
	    		m_PauseTimeVibCount += 1;
	    	}
	    	if (m_actualtimeCount == 0){
	    		m_actualtimeReachedZero = true;
	    		alert();
	    		//System.println("wahr");
	    	} else if (m_actualtimeCount < 0){
	    	
	    	} else {
	    		m_actualtimeReachedZero = false;
	    	}
	    	if (m_gametimeCount == m_DefaultCount and !m_actualtimeReachedZero) { // AW: V1.2 Alert when default time reached
	    		alert();
	    	} else if (m_gametimeCount == 2*m_DefaultCount and !m_actualtimeReachedZero){
	    		alert();
	    	}
	    	if (m_PauseTimeVibCount == 10) {   
	    		alert();
	    		m_PauseTimeVibCount = 0;
	    	}
    	}
    	getActivity();
    	//System.println(m_actualtimeCount);
    	Ui.requestUpdate();
    
    }
	
    function onMenu() {
    	if (session != null) {
    		return true;					//AW V1.2 Dont access Menu when in session
    	} else {
	        var menu = new Rez.Menus.MainMenu();
	        menu.setTitle(Ui.loadResource( Rez.Strings.setup ));
	        Ui.pushView(menu, new SchiriUhrMenuDelegate(), Ui.SLIDE_IMMEDIATE);
	        return true;
        }
    }
	
}