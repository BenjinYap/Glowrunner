package Screener.BigScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.filters.*;
	import flash.utils.*;
	import Screener.*;
	import Game.*;
	
	public final class GameScreen extends BaseScreen {
		private var worldSpeed:int = 20//GameData.minWorldSpeed;
		private var worldSpeedNoticeFrame:int = 0;
		
		private var worldCont:Sprite = new Sprite ();
		private var sparkCont:Sprite = new Sprite ();
		
		private var mouseDown:Boolean = false;
		
		private var islandGap:int;
		
		private var distortionEnabled:Boolean = false;
		private var distortionCountdown:int = 0;
		private var pendingDistortion:Boolean = false//true;
		private var madeDistortionIsland:Boolean = false;
		private var distorting:Boolean = false;
		private var distortionFrame:int = 0;
		private var leftDistortionIsland:Boolean = false;
		private var distortDirectionX:int = 1;
		private var distortDirectionY:int = 1;
		
		private var aiEnabled:Boolean = false;
		private var numAI:int = 0;
		private var maxAI:int = 0;
		private var aiIncreaseCountdown:int = 0;
		
		private var player:Avatar = new Avatar ();
		private var avatarCont:Sprite = new Sprite ();
		
		private var gameOver:Boolean = false;
		private var gameOverFrame:int = 0;
		
		private var frame:int = 0;
		
		public override function Initialize (arg:Object = null) {
			GameData.Reset ();
			
			unpauseThing.visible = false;
			
			txtWorldSpeed.visible = false;
			
			islandGap = worldSpeed * 15;
			
			for (var i:int = 0; i < GameData.numIslands; i++) {
				var island:Shape = new Shape ();
				var g:Graphics = island.graphics;
				g.lineStyle (2, 0xFFFFFF);
				g.drawRect (0, 0, GameData.maxIslandWidth + 5000, stage.stageHeight / 2);
				island.x = -stage.stageWidth / 2 + i * (island.width + islandGap);
				island.y = stage.stageHeight / 2 - island.height;
				var glow:GlowFilter = new GlowFilter ();
				glow.color = 0xFFFFFF;
				island.filters = [glow];
				worldCont.addChild (island);
			}
			
			avatarCont.addChild (player);
			worldCont.addChild (avatarCont);
			
			var glow:GlowFilter = new GlowFilter ();
			glow.color = 0xFFFFFF;
			sparkCont.filters = [glow];
			worldCont.addChild (sparkCont);
			
			worldCont.x = stage.stageWidth / 2;
			worldCont.y = stage.stageHeight / 2;
			addChild (worldCont);
			
			player.addEventListener (GameEvent.MakeSparks, onAvatarMakeSparks, false, 0, true);
			player.Initialize (false);
			
			Activate ();
		}
		
		public override function Activate (modalScreenMessage:String = null) {
			addEventListener (Event.ENTER_FRAME, onFrame, false, 0, true);
			stage.addEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown, false, 0, true);
			
			for (var i:int = 0; i < avatarCont.numChildren; i++) {
				Avatar (avatarCont.getChildAt (i)).Activate ();
			}
			
			for (var i:int = 0; i < sparkCont.numChildren; i++) {
				Spark (sparkCont.getChildAt (i)).Activate ();
			}
		}
		
		public override function Deactivate () {
			removeEventListener (Event.ENTER_FRAME, onFrame);
			stage.removeEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown);
			
			for (var i:int = 0; i < avatarCont.numChildren; i++) {
				Avatar (avatarCont.getChildAt (i)).Deactivate ();
			}
			
			for (var i:int = 0; i < sparkCont.numChildren; i++) {
				Spark (sparkCont.getChildAt (i)).Deactivate ();
			}
		}
		
		public override function PrepareToDie () {
			Deactivate ();
			
			for (var i:int = 0; i < avatarCont.numChildren; i++) {
				Avatar (avatarCont.getChildAt (i)).PrepareToDie ();
			}
			
			for (var i:int = 0; i < sparkCont.numChildren; i++) {
				Spark (sparkCont.getChildAt (i)).PrepareToDie ();
			}
		}
		
		private function onFrame (e:Event) {
			var firstIsland:Shape = Shape (worldCont.getChildAt (0));
			
			if (firstIsland.x + firstIsland.width < -stage.stageWidth / 2) {
				MakeNewIsland ();
			}
			
			for (var i:int = 0; i < GameData.numIslands; i++) {
				var island:Shape = Shape (worldCont.getChildAt (i));
				island.x -= worldSpeed;
				
				if (island.x > stage.stageWidth / 2) {
					island.visible = false;
				} else {
					island.visible = true;
				}
			}
			
			var avatarsToRemove:Array = [];
			
			for (var i:int = 0; i < avatarCont.numChildren; i++) {
				var avatar:Avatar = Avatar (avatarCont.getChildAt (i));
				avatar.ySpeed++;
				
				for (var j:int = 0; j < 2; j++) {
					var island:Shape = Shape (worldCont.getChildAt (j));
					if (avatar.x >= island.x && avatar.x <= island.x + island.width) {
						if (avatar.y + GameData.avatarSize.y / 2 + avatar.ySpeed >= island.y) {
							if (avatar.x < island.x + worldSpeed * 2) {
								//avatar.x = island.x - worldSpeed;
						//		AvatarExploded (avatar);
					//			avatarsToRemove.push (avatar);
							} else {
								avatar.y = island.y - GameData.avatarSize.y / 2;
							}
							
							avatar.ySpeed = 0;
							avatar.isAirborne = false;
						}
						
						if (avatar == player && island.width >= GameData.distortionIslandWidth && distorting == false && leftDistortionIsland == true) {
							madeDistortionIsland = false;
							pendingDistortion = false;
							distorting = true;
							distortionFrame = GameData.distortionFrames;
							leftDistortionIsland = false;
							
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
						} else if (island.width < GameData.distortionIslandWidth) {
							leftDistortionIsland = true;
						}
					}
				}
			}
			
			for (var i:int = 0; i < avatarsToRemove.length; i++) {
				RemoveAvatar (avatarsToRemove [i]);
			}
			
			for (var i:int = 0; i < sparkCont.numChildren; i++) {
				var spark:Spark = Spark (sparkCont.getChildAt (i));
				
				for (var j:int = 0; j < 2; j++) {
					var island:Shape = Shape (worldCont.getChildAt (j));
					
					if (spark.x >= island.x && spark.x <= island.x + island.width) {
						if (spark.y >= island.y) {
							spark.dispatchEvent (new GameEvent (GameEvent.SparkOutOfStage));
						}
					}
				}
			}

			if (frame > 0) {
				if (frame % GameData.worldSpeedInterval == 0 && worldSpeed < GameData.maxWorldSpeed) {
					worldSpeed++;
					worldSpeedNoticeFrame = GameData.worldSpeedNoticeFrames;
					txtWorldSpeed.visible = true;
					txtWorldSpeed.scaleY = 0;
				}
			}
			
			if (worldSpeedNoticeFrame > 0) {
				if (worldSpeedNoticeFrame > GameData.worldSpeedNoticeFrames / 3 * 2) {
					txtWorldSpeed.scaleY += 1 / (GameData.worldSpeedNoticeFrames / 3);
				} else if (worldSpeedNoticeFrame < GameData.worldSpeedNoticeFrames / 3) {
					txtWorldSpeed.scaleY -= 1 / (GameData.worldSpeedNoticeFrames / 3);
				}
				
				worldSpeedNoticeFrame--;
			} else {
				txtWorldSpeed.visible = false;
			}
			
			if (distortionEnabled) {
				distortionCountdown = (distortionCountdown > 0) ? distortionCountdown - 1 : 0;
				pendingDistortion = (distortionCountdown == 0) ? true : false;
			}
			
			if (distorting) {
				if (distortionFrame > 0) {
					worldCont.scaleX += distortDirectionX * 2 / GameData.distortionFrames;
					worldCont.scaleY += distortDirectionY * 2 / GameData.distortionFrames;
					
					if (distortionFrame == Math.floor (GameData.distortionFrames / 2)) {
						var ct:ColorTransform = new ColorTransform ();
						ct.color = GameData.worldColors [Math.floor (Math.random () * GameData.worldColors.length)];
						worldCont.transform.colorTransform = ct;
					}
					
					distortionFrame--;
				} else if (distortionFrame == 0) {
					distorting = false;
					distortionCountdown = GameData.distortionCountdown;
				}
			}
			
			if (frame >= GameData.distortionDebut && distortionEnabled == false) {
				distortionEnabled = true;
				distortionCountdown = GameData.distortionCountdown;
			}
			
			if (aiEnabled) {
				if (numAI < maxAI) {
					CreateAI ();
				}
				
				if (maxAI < GameData.maxAI) {
					if (aiIncreaseCountdown == 0) {
						maxAI++;
						aiIncreaseCountdown = GameData.aiIncreaseInterval;
					}
					
					aiIncreaseCountdown--;
				}
			}
			
			if (frame >= GameData.aiDebut && aiEnabled == false) {
				aiEnabled = true;
				aiIncreaseCountdown = GameData.aiIncreaseInterval;
			}
			
			if (gameOver) {
				if (gameOverFrame == 0) {
					screenMgr.NewBigScreen (ScreenType.GameOver);
				}
			
				gameOverFrame--;
			}
			
			GameData.distance += worldSpeed;
			txtDistance.text = GameData.distance.toString ();
			
			frame++;
		}
		
		private function onStageMouseDown (e:MouseEvent) {
			mouseDown = true;
		}
		
		private function onStageMouseUp (e:MouseEvent) {
			mouseDown = false;
		}
		
		private function onStageKeyDown (e:KeyboardEvent) {
			if (e.keyCode == Keyboard.ESCAPE) {
				screenMgr.AddModalScreen (ScreenType.Pause);
			}
		}
		
		private function MakeNewIsland () {
			for (var i:int = 0; i < GameData.numIslands - 1; i++) {
				var island1:Shape = Shape (worldCont.getChildAt (i));
				var island2:Shape = Shape (worldCont.getChildAt (i + 1));
				var g:Graphics = island1.graphics;
				g.clear ();
				g.lineStyle (2, 0xFFFFFF);
				g.drawRect (0, 0, island2.width, island2.height);
				island1.x = island2.x;
				island1.y = island2.y;
			}
			
			var lastIsland:Shape = Shape (worldCont.getChildAt (GameData.numIslands - 1));
			var secondLastIsland:Shape = Shape (worldCont.getChildAt (GameData.numIslands - 2));
			
			var h:int = secondLastIsland.height;
			
			if (h + GameData.maxIslandHeightDifference >= GameData.maxIslandHeight) {
				h += Math.random () * (GameData.maxIslandHeight - h + GameData.maxIslandHeightDifference) - GameData.maxIslandHeightDifference;
			} else if (h - GameData.maxIslandHeightDifference <= GameData.minIslandHeight) {
				h += Math.random () * (h - GameData.minIslandHeight + GameData.maxIslandHeightDifference) - (h - GameData.minIslandHeight);
			} else {
				h += Math.random () * (GameData.maxIslandHeightDifference * 2) - GameData.maxIslandHeightDifference;
			}
			
			var g:Graphics = lastIsland.graphics;
			g.clear ();
			g.lineStyle (2, 0xFFFFFF);
			
			if (pendingDistortion && madeDistortionIsland == false) {
				g.drawRect (0, 0, GameData.distortionIslandWidth, Math.floor (h));
				madeDistortionIsland = true;
			} else {
				g.drawRect (0, 0, Math.floor (Math.random () * (GameData.maxIslandWidth - GameData.minIslandWidth)) + GameData.minIslandWidth, Math.floor (h));
			}
			
			lastIsland.x = secondLastIsland.x + secondLastIsland.width + islandGap;
			lastIsland.y = stage.stageHeight / 2 - lastIsland.height;
		}
		
		
		
		private function onAvatarMakeSparks (e:GameEvent) {
			var avatar:Avatar = Avatar (e.currentTarget);
			
			for (var i:int = 0; i < (worldSpeed - GameData.minWorldSpeed + 1) * 2; i++) {
				CreateSpark (false, new Point (avatar.x, avatar.y));
			}
		}
		
		private function onAIOutOfStage (e:GameEvent) {
			RemoveAvatar (Avatar (e.currentTarget));
		}
		
		private function AvatarExploded (avatar:Avatar) {
			for (var i:int = 0; i < 300; i++) {
				CreateSpark (true, new Point (avatar.x, avatar.y));
			}
			
			if (avatar == player) {
				gameOver = true;
				gameOverFrame = GameData.gameOverFrames;
			}
		}
		
		private function CreateSpark (avatarExploded:Boolean, coords:Point) {
			var spark:Spark = new Spark ();
			spark.addEventListener (GameEvent.SparkOutOfStage, onSparkOutOfStage, false, 0, true);
			sparkCont.addChild (spark);
			spark.Initialize (avatarExploded, coords, worldSpeed);
		}
		
		private function onSparkOutOfStage (e:GameEvent) {
			var spark:Spark = Spark (e.currentTarget);
			spark.removeEventListener (GameEvent.SparkOutOfStage, onSparkOutOfStage);
			spark.Deactivate ();
			sparkCont.removeChild (spark);
		}
		
		private function CreateAI () {
			numAI++;
			
			var ai:Avatar = new Avatar ();
			ai.addEventListener (GameEvent.MakeSparks, onAvatarMakeSparks, false, 0, true);
			ai.addEventListener (GameEvent.AIOutOfStage, onAIOutOfStage, false, 0, true);
			avatarCont.addChild (ai);
			ai.Initialize (true);
		}
		
		private function RemoveAvatar (avatar:Avatar) {
			avatar.Deactivate ();
			avatar.removeEventListener (GameEvent.MakeSparks, onAvatarMakeSparks);
			avatar.removeEventListener (GameEvent.MakeSparks, onAIOutOfStage);
			avatarCont.removeChild (avatar);
			
			if (avatar == player) {
				
			} else {
				numAI--;
			}
		}
	}
}