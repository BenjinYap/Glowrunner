package Game {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import Screener.BigScreens.*;
	
	public final class DistortionEngine extends EventDispatcher {
		private var gameScreen:GameScreen;
		private var worldSpeed:int;
		private var worldCont:Sprite;
		private var islandCont:Sprite;
		private var player:Player;
		
		private var distortionEnabled:Boolean = false;
		private var distortionCountdown:int = 0;
		private var distortionPhase:String = DistortionPhase.WaitingForCountdown;
		private var warningFrame:int = 0;
		private var distortionFrame:int = 0;
		private var distortDirectionX:int = 1;
		private var distortDirectionY:int = 1;
		
		private var frame:int = 0;
		
		public function SetGameScreen (screen:GameScreen) {
			gameScreen = screen;
		}
		
		public function SetWorldSpeed (speed:int) {
			worldSpeed = speed;
		}
		
		public function SetWorldCont (cont:Sprite) {
			worldCont = cont;
		}
		
		public function SetIslandCont (cont:Sprite) {
			islandCont = cont;
		}
		
		public function SetPlayer (p:Player) {
			player = p;
		}
		
		public function Update () {
			if (distortionEnabled) {
				if (distortionCountdown > 0) {
					distortionCountdown--;
				} else {
					if (distortionPhase == DistortionPhase.WaitingForCountdown) {
						distortionPhase = DistortionPhase.WaitingForLongIsland;
						dispatchEvent (new GameEvent (GameEvent.MustMakeLongIsland));
					} else if (distortionPhase == DistortionPhase.WaitingForLongIsland) {
						for (var i:int = 0; i < 2; i++) {
							var island:Shape = Shape (islandCont.getChildAt (i));
							
							if (player.x >= island.x && player.x <= island.x + island.width) {
								if (island.width >= worldSpeed * (GameData.distortionFrames + 60)) {
									distortionPhase = DistortionPhase.Distorting;
									distortionFrame = GameData.distortionFrames;
									
									if (Math.random () * 1 < 0.5) {
										distortDirectionX *= -1;
										distortDirectionY = 0;
										
										if (distortDirectionX == 0) {
											distortDirectionX = (worldCont.scaleX < 0) ? 1 : -1;
										}
									} else {
										distortDirectionX = 0;
										distortDirectionY *= -1;
										
										if (distortDirectionY == 0) {
											distortDirectionY = (worldCont.scaleY < 0) ? 1 : -1;
										}
									}
								}
							}
						}
					} else if (distortionPhase == DistortionPhase.Distorting) {
						if (distortionFrame > 0) {
							worldCont.scaleX += distortDirectionX * 2 / GameData.distortionFrames;
							worldCont.scaleY += distortDirectionY * 2 / GameData.distortionFrames;
							
							if (distortionFrame == Math.floor (GameData.distortionFrames / 2)) {
								var ct:ColorTransform = new ColorTransform ();
								ct.color = GameData.worldColors [Math.floor (Math.random () * GameData.worldColors.length)];
								gameScreen.transform.colorTransform = ct;
							}
							
							distortionFrame--;
						} else if (distortionFrame == 0) {
							distortionPhase = DistortionPhase.MustLeaveLongIsland;
						}
					} else if (distortionPhase == DistortionPhase.MustLeaveLongIsland) {
						var betweenIslands:Boolean = true;
						
						for (var i:int = 0; i < 2; i++) {
							var island:Shape = Shape (islandCont.getChildAt (i));
							
							if (player.x >= island.x && player.x <= island.x + island.width) {
								betweenIslands = false;
								break;
							}
						}
						
						if (betweenIslands) {
							distortionPhase = DistortionPhase.WaitingForCountdown;
							distortionCountdown = GameData.distortionCountdown;
						}
					}
				}
			} else {
				if (frame >= GameData.distortionDebut && distortionEnabled == false) {
					distortionEnabled = true;
					distortionCountdown = GameData.distortionCountdown;
				}
			}
			
			frame++;
		}
	}
}