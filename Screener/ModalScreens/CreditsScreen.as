package Screener.ModalScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import Screener.*;
	
	public final class CreditsScreen extends BaseScreen {
		private var mouseDownTargets:Array;
		
		public override function Initialize (arg:Object = null) {
			mouseDownTargets = [bttLogo, bttBack];
			
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			}
		}
		
		public override function PrepareToDie () {
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].removeEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}
		
		public function onMouseDown (e:MouseEvent) {
			if (e.currentTarget == bttLogo) {
				navigateToURL (new URLRequest ("http://www.benjyap.99k.org"));
			} else if (e.currentTarget == bttBack) {
				screenMgr.RemoveModalScreen ("");
			}
		}
	}
}