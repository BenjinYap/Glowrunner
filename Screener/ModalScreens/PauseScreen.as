package Screener.ModalScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import Screener.*;
	import Game.*;
	
	public final class PauseScreen extends BaseScreen {
		private var mouseDownTargets:Array;
		
		public override function Initialize (arg:Object = null) {
			mouseDownTargets = [bttHighScores, bttMenu, bttSound, bttMusic, bttLogo];
			
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			}
			
			bttSound.alpha = (GameData.soundOn) ? 1 : 0.2;
			bttMusic.alpha = (GameData.musicOn) ? 1 : 0.2;
			
			Activate ();
		}
		
		public override function Activate (modalScreenMessage:String = null) {
			stage.addEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown, false, 0, true);
		}
		
		public override function Deactivate () {
			stage.removeEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown);
		}
		
		public override function PrepareToDie () {
			Deactivate ();
		
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].removeEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}
		
		public function onMouseDown (e:MouseEvent) {
			if (e.currentTarget == bttMenu) {
				screenMgr.RemoveModalScreen ("quit");
			} else if (e.currentTarget == bttHighScores) {
				screenMgr.AddModalScreen (ScreenType.HighScores);
			} else if (e.currentTarget == bttSound) {
				GameData.soundOn = (GameData.soundOn) ? false : true;
				bttSound.alpha = (GameData.soundOn) ? 1 : 0.2;
			} else if (e.currentTarget == bttMusic) {
				GameData.musicOn = (GameData.musicOn) ? false : true;
				bttMusic.alpha = (GameData.musicOn) ? 1 : 0.2;
			} else if (e.currentTarget == bttLogo) {
			
			}
		}
		
		private function onStageKeyDown (e:KeyboardEvent) {
			if (e.keyCode == Keyboard.ESCAPE) {
				screenMgr.RemoveModalScreen ("pause");
			}
		}
	}
}