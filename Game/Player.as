package Game {
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import Game.*;
	
	public class Player extends MovieClip {
		public var xSpeed:int = 0;
		public var ySpeed:int = 0;
		public var isAirborne:Boolean = true;
		private var mouseDown:Boolean = false;
		
		public function Initialize () {
			x = GameData.playerX;
			y = stage.stageHeight - GameData.minIslandHeight - GameData.avatarSize.y / 2 - 10;
			
			scaleX = 0.13;
			scaleY = scaleX;
			
			Activate ();
		}
		
		public function Activate () {
			addEventListener (Event.ENTER_FRAME, onFrame, false, 0, true);
			stage.addEventListener (MouseEvent.MOUSE_DOWN, onStageMouseDown, false, 0, true);
			stage.addEventListener (MouseEvent.MOUSE_UP, onStageMouseUp, false, 0, true);
			stage.addEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown, false, 0, true);
			play ();
		}
		
		public function Deactivate () {
			removeEventListener (Event.ENTER_FRAME, onFrame);
			
			if (stage != null) {
				stage.removeEventListener (MouseEvent.MOUSE_DOWN, onStageMouseDown);
				stage.removeEventListener (MouseEvent.MOUSE_UP, onStageMouseUp);
				stage.removeEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown);
			}
			
			stop ();
		}
		
		public function PrepareToDie () {
			Deactivate ();
		}
		
		private function onFrame (e:Event) {
			if (ySpeed > 0) {
				isAirborne = true;
			}
			
			if (isAirborne == false) {
				dispatchEvent (new GameEvent (GameEvent.MustMakeRunSparks));
			}
		}
		
		private function onStageMouseDown (e:MouseEvent) {
			mouseDown = true;
			TryJump ();
		}
		
		private function onStageMouseUp (e:MouseEvent) {
			mouseDown = false;
		}
		
		private function onStageKeyDown (e:KeyboardEvent) {
			if (e.keyCode == Keyboard.SPACE){
				stage.dispatchEvent (new MouseEvent (MouseEvent.MOUSE_DOWN));
			}
		}
		
		private function TryJump () {
			if (isAirborne == false) {
				ySpeed = -GameData.jumpSpeed;
				y += ySpeed;
				isAirborne = true;
				mouseDown = false;
			}
		}
	}
}