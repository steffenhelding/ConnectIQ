using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time.Gregorian as Cal;
using Toybox.Application as App;
using Toybox.Time as Time;

var timersettings;

class SchiriUhrBigCountMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }
    
	function onMenuItem(item) {
        if (item == :item_ran) {
            timersettings = "ran";
        } else if (item == :item_left) {
            timersettings = "left";
        }
        App.getApp().setTimerSettings(timersettings);       
    }  
    
    
    
    
}