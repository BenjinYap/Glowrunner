package Game {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import Game.*;
	
	public class Spark extends MovieClip {
		public var type:String;
		public var xSpeed:Number;
		public var ySpeed:Number;
		
		public function Initialize (Type:String, coords:Point = null) {
			type = Type;
			
			if (type == SparkType.Run) {
				x = coords.x;
				y = coords.y + GameData.avatarSize.y / 2 - 1;
				xSpeed = Math.random () * 10;
				ySpeed = Math.random () * 10 + 1;
			} else if (type == SparkType.Explode) {
				x = coords.x;
				y = coords.y;
				xSpeed = Math.random () * 10;
				ySpeed = Math.random () * 20 - 10;
			} else if (type == SparkType.Power) {
				x = coords.x + Math.random () * 105;
				y = coords.y;
				xSpeed = Math.random () * 20 - 10;
				ySpeed = Math.random () * 20;
			}
		}
		
		public function Activate () {
			
		}
		
		public function Deactivate () {
			
		}
		
		public function PrepareToDie () {
			
		}
	}
}