package Game {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	public final class PhysicsEngine extends Shape {
		private var worldSpeed:int;
		
		private var starCont:Sprite;
		private var islandCont:Sprite;
		private var player:Player;
		private var avatarCont:Sprite;
		private var sparkCont:Sprite;
		
		private var gameOver:Boolean = false;
		
		private var starDirX:int = -1;
		private var starDirY:int = 0;
		
		private var sparkDir:int = -1;
		
		public function SetWorldSpeed (speed:int) {
			worldSpeed = speed;
		}
		
		public function SetStarCont (cont:Sprite) {
			starCont = cont;
		}
		
		public function SetIslandCont (cont:Sprite) {
			islandCont = cont;
		}
		
		public function SetPlayer (p:Player) {
			player = p;
		}
		
		public function SetCloneCont (cont:Sprite) {
			avatarCont = cont;
		}
		
		public function SetSparkCont (cont:Sprite) {
			sparkCont = cont;
		}
		
		public function SetGameOver () {
			gameOver = true;
		}
		
		public function ChangeStarDirection () {
			starDirX = Math.floor (Math.random () * 3) - 1;
			starDirY = Math.floor (Math.random () * 3) - 1;
		}
		
		public function ReverseSparkDirection () {
			sparkDir *= -1;
		}
		
		public function Update () {
			for (var i:int = 0; i < starCont.numChildren; i++) {
				var star:Shape = Shape (starCont.getChildAt (i));
				star.x += worldSpeed * starDirX;
				star.y += worldSpeed * starDirY;
				
				if (starDirX == -1) {
					if (star.x < 0) {
						star.x = stage.stageWidth
						star.y = Math.random () * stage.stageHeight;
					}
				} else if (starDirX == 1) {
					if (star.x > stage.stageWidth) {
						star.x = 0;
						star.y = Math.random () * stage.stageHeight;
					}
				}
				
				if (starDirY == -1) {
					if (star.y < 0) {
						star.x = Math.random () * stage.stageWidth;
						star.y = stage.stageHeight;
					}
				} else if (starDirY == 1) {
					if (star.y > stage.stageHeight) {
						star.x = Math.random () * stage.stageWidth;
						star.y = 0;
					}
				}
			}
		
			for (var i:int = 0; i < islandCont.numChildren; i++) {
				var island:Shape = Shape (islandCont.getChildAt (i));
				island.x -= worldSpeed;
				
				if (island.x > stage.stageWidth) {
					island.visible = false;
				} else if (island.x + island.width < 0) {
					dispatchEvent (new GameEvent (GameEvent.MustMakeNewIsland));
				} else {
					island.visible = true;
				}
			}
			
			if (gameOver == false) {
				player.x += player.xSpeed;
				player.y += player.ySpeed;
				player.ySpeed++;
					
				for (var j:int = 0; j < 2; j++) {
					var island:Shape = Shape (islandCont.getChildAt (j));
					
					if (player.x >= island.x && player.x <= island.x + island.width) {
						if (player.y + GameData.avatarSize.y / 2 + player.ySpeed >= island.y) {
							//if (player.x < island.x + worldSpeed) {
							if (player.y + GameData.avatarSize.y / 2 - player.ySpeed * 2 >= island.y) {
								player.x = island.x - worldSpeed;
								dispatchEvent (new GameEvent (GameEvent.MustExplodePlayer));
							} else {
								player.y = island.y - GameData.avatarSize.y / 2;
							}
							
							player.ySpeed = 0;
							player.isAirborne = false;
						}
					}
				}
			}
			
			var clonesOutOfStage:Array = [];
			
			for (var i:int = 1; i < avatarCont.numChildren; i++) {
				var clone:Clone = Clone (avatarCont.getChildAt (i));
				clone.x += clone.xSpeed;
				clone.y += clone.ySpeed;
				
				if (clone.x > stage.stageWidth + 50 || clone.x < -50 || clone.y > stage.stageHeight + 50 || clone.y < -50) {
					clonesOutOfStage.push (clone);
				}
			}
			
			for (var i:int = 0; i < clonesOutOfStage.length; i++) {
				dispatchEvent (new GameEvent (GameEvent.CloneOutOfStage, clonesOutOfStage [i]));
			}
			
			var sparksToRemove:Array = [];
			
			for (var i:int = 0; i < sparkCont.numChildren; i++) {
				var spark:Spark = Spark (sparkCont.getChildAt (i));
				spark.x += (Math.random () * worldSpeed + spark.xSpeed) * sparkDir;
				
				spark.y -= spark.ySpeed;
				spark.ySpeed--;
				
				for (var j:int = 0; j < 2; j++) {
					var island:Shape = Shape (islandCont.getChildAt (j));
					
					if (spark.x >= island.x && spark.x <= island.x + island.width) {
						if (spark.y >= island.y) {
							sparksToRemove.push (spark);
						}
					}
				}
				
				if (spark.x < 0 || spark.y > stage.stageHeight) {
					if (sparksToRemove.indexOf (spark) == -1) {
						sparksToRemove.push (spark);
					}
				}
			}
			
			for (var i:int = 0; i < sparksToRemove.length; i++) {
				dispatchEvent (new GameEvent (GameEvent.MustRemoveSpark, sparksToRemove [i]));
			}
		}
	}
}