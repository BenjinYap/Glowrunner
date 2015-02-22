package Game {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	public class PowerEngine extends Shape {
		private var worldSpeed:int;
		
		private var player:Player;
		private var powerCont:Sprite;
		
		private var gameOver:Boolean = false;
		
		public function SetWorldSpeed (speed:int) {
			worldSpeed = speed;
		}
		
		public function SetPlayer (p:Player) {
			player = p;
		}
		
		public function SetPowerCont (cont:Sprite) {
			powerCont = cont;
		}
		
		public function SetGameOver () {
			gameOver = true;
		}
		
		public function Update () {
			var powersToRemove:Array = [];
				
			for (var i:int = 0; i < powerCont.numChildren; i++) {
				var power:Power = Power (powerCont.getChildAt (i));
				power.x -= worldSpeed;
				
				if (power.x > stage.stageWidth) {
					power.visible = false;
				} else {
					power.visible = true;
				}
				
				if (gameOver == false) {
					if (player.x >= power.x && player.x <= power.x + power.width) {
						if (player.y + GameData.avatarSize.y / 2 >= power.y) {
							dispatchEvent (new GameEvent (GameEvent.GotPower, power));
						}
					}
				}
					
				if (power.x + power.width < 0) {
					powersToRemove.push (power);
				}
			}
				
			for (var i:int = 0; i < powersToRemove.length; i++) {
				dispatchEvent (new GameEvent (GameEvent.MustRemovePower, powersToRemove [i]));
			}
		}
	}
}