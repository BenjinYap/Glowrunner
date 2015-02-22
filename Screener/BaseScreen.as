package Screener {
	import flash.display.*;
	import flash.events.*;
	
	public class BaseScreen extends MovieClip {
		protected var screenMgr:ScreenManager;
		
		//Add all the event listeners here
		//This will only be called right after the screen is added
		public function Initialize (arg:Object = null) {
		
		}
		
		//This will be called when a modal screen on top of this is removed
		//modalScreenMessage is a string passed by the previous modal screen after it is removed
		//Makes all the children able to capture mouse events
		public function Activate (modalScreenMessage:String = null) {
			
		}
		
		//This will be called when a modal screen is added on top of this
		//Makes all the children not capture mouse events
		public function Deactivate () {
			
		}
		
		//This will only be called right before this screen is removed
		public function PrepareToDie () {
		
		}
		
		public function SetScreenManager (ScreenMgr:ScreenManager) {
			screenMgr = ScreenMgr;
		}
	}
}