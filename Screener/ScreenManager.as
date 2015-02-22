package Screener {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import Screener.BigScreens.*;
	import Screener.ModalScreens.*;
	
	public class ScreenManager extends Sprite {
		private var _screens:Array = new Array ();
		
		public function ScreenManager () {
			
		}
		
		public function NewBigScreen (typeIndex:Number, arg:Object = null) {
			while (_screens.length > 0) {
				_screens [_screens.length - 1].PrepareToDie ();
				removeChild (_screens [_screens.length - 1]);
				_screens.splice (_screens.length - 1, 1);
			}
			
			var screen:BaseScreen = new ScreenType.classes [typeIndex] ();
			_screens.push (screen);
			screen.SetScreenManager (this);
			addChild (screen);
			screen.Initialize (arg);
		}
		
		public function AddModalScreen (typeIndex:Number, arg:Object = null) {
			_screens [_screens.length - 1].Deactivate ();
			
			var screen:BaseScreen = new ScreenType.classes [typeIndex] ();
			_screens.push (screen);
			screen.SetScreenManager (this);
			addChild (screen);
			screen.Initialize (arg);
		}
		
		public function RemoveModalScreen (modalScreenMessage:String) {
			_screens [_screens.length - 1].PrepareToDie ();
			removeChild (_screens [_screens.length - 1]);
			_screens.splice (_screens.length - 1, 1);
			
			_screens [_screens.length - 1].Activate (modalScreenMessage);
		}
	}
}