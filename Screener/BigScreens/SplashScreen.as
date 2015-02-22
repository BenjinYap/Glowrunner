package Screener.BigScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import mx.core.*;
	import Screener.*;
	import Game.*;
	
	public final class SplashScreen extends BaseScreen {
		
		public override function Initialize (arg:Object = null) {
			addEventListener (Event.ENTER_FRAME, onFrame, false, 0, true);
		}

		public override function PrepareToDie () {
			removeEventListener (Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame (e:Event) {
			if (logo.currentFrame == logo.totalFrames) {
				logo.stop ();
				screenMgr.NewBigScreen (ScreenType.Menu);
			}
		}
	}
}