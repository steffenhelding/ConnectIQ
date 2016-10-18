using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time.Gregorian as Cal;
using Toybox.Application as App;
using Toybox.Time as Time;

class SchiriUhrExtraTimeMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

	function onMenuItem(item) {
        if (item == :item_enable) {
            var menu = new Rez.Menus.ExtraTimeYesNo();
        	menu.setTitle(Ui.loadResource( Rez.Strings.extratime_enable ));
            Ui.pushView(menu, new SchiriUhrExtraTimeYesMenuDelegate(), Ui.SLIDE_IMMEDIATE);
        } else if (item == :item_5) {
            setExtraTimer(300);
        } else if (item == :item_10) {
            setextraTimer(600);
        } else if (item == :item_15) {
            setExtraTimer(900);
        } else if (item == :item_same){
        	setExtraTimer(m_DefaultCount);
        }
    }  
    
    
    function setExtraTimer(time) {
        m_ExtraTimeCount = time;
        App.getApp().setExtraTimerCount(m_ExtraTimeCount); // save new default to properties     
        Ui.requestUpdate();
    }
    
}