using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time.Gregorian as Cal;
using Toybox.Application as App;
using Toybox.Time as Time;

var activitydata;

class SchiriUhrActivityMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }
    
	function onMenuItem(item) {
        if (item == :item_yes) {
            activitydata = true;
        } else if (item == :item_no) {
			activitydata = false;
        }
        
        App.getApp().setActivityData(activitydata);
    }   
}