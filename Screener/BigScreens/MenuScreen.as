package Screener.BigScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import mx.core.*;
	import Screener.*;
	import Game.*;
	
	public final class MenuScreen extends BaseScreen {
		private var mouseDownTargets:Array;
		
		public override function Initialize (arg:Object = null) {
			mouseDownTargets = [bttPlay, bttHighScores, bttLogo, bttCredits];
			
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			}
		}

		public override function PrepareToDie () {
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].removeEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}
		
		private function onMouseDown (e:MouseEvent) {
			if (e.currentTarget == bttPlay) {
				screenMgr.NewBigScreen (ScreenType.Game);
			} else if (e.currentTarget == bttLogo) {
				navigateToURL (new URLRequest ("http://www.addictinggames.com"));
			} else if (e.currentTarget == bttHighScores) {
				screenMgr.AddModalScreen (ScreenType.HighScores);
			} else if (e.currentTarget == bttCredits) {
				screenMgr.AddModalScreen (ScreenType.Credits);
			}
		}
	}
}