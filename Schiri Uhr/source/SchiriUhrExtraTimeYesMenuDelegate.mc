using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time.Gregorian as Cal;
using Toybox.Application as App;
using Toybox.Time as Time;

var extratime;

class SchiriUhrExtraTimeYesMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }
    
	function onMenuItem(item) {
        if (item == :item_yes) {
            extratime = true;
            App.getApp().setExtraTimeYesNo(extratime);
        } else if (item == :item_no) {
            extratime = false;
            App.getApp().setExtraTimeYesNo(extratime);
        }        
    }  
    
    
    
    
}