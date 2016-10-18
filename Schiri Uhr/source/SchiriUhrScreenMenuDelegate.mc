using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time.Gregorian as Cal;
using Toybox.Application as App;
using Toybox.Time as Time;



class SchiriUhrScreenMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }
    
	function onMenuItem(item) {
        if (item == :item_activityData) {
            var menu = new Rez.Menus.ExtraTimeYesNo();
        	menu.setTitle(Ui.loadResource( Rez.Strings.activityData ));
            Ui.pushView(menu, new SchiriUhrActivityMenuDelegate(), Ui.SLIDE_IMMEDIATE);
        } else if (item == :item_timer) {
			var menu = new Rez.Menus.BigCountMenu();
        	menu.setTitle(Ui.loadResource( Rez.Strings.timer ));
            Ui.pushView(menu, new SchiriUhrBigCountMenuDelegate(), Ui.SLIDE_IMMEDIATE);
        }
    }   
}