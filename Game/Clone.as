package Game {
	import flash.display.*;
	import Game.*;
	
	public class Clone extends MovieClip {
		public var xSpeed:int = 0;
		public var ySpeed:int = 0;
		
		public function Initialize (Y:int) {
			var speed:Number = Math.random () * (GameData.cloneMaxSpeed - GameData.cloneMinSpeed) + GameData.cloneMinSpeed;
			
			rotation = Math.random () * 360;
			xSpeed = Math.cos (rotation * Math.PI / 180) * speed;
			ySpeed = Math.sin (rotation * Math.PI / 180) * speed;
			
			x = GameData.playerX;
			y = Y;
			
			scaleX = 0.13;
			scaleY = scaleX;
			
			Activate ();
		}
		
		public function Activate () {
			play ();
		}
		
		public function Deactivate () {
			stop ();
		}
		
		public function PrepareToDie () {
			Deactivate ();
		}
	}
}