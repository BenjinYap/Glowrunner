package Screener.BigScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.filters.*;
	import flash.utils.*;
	import flash.net.*;
	import Screener.*;
	import Game.*;
	
	public final class GameScreen extends BaseScreen {
		private var worldSpeed:int = 21;
		
		private var worldCont:Sprite = new Sprite ();
		private var starCont:Sprite = new Sprite ();
		private var islandCont:Sprite = new Sprite ();
		private var sparkCont:Sprite = new Sprite ();
		private var powerCont:Sprite = new Sprite ();
		private var player:Player = new Player ();
		private var avatarCont:Sprite = new Sprite ();
		
		private var islandGap:int;

		private var gameOver:Boolean = false;
		private var gameOverFrame:int = 0;
		
		private var clonesToMake:int = 0;
		
		private var spinPlayerFrame:int = 0;
		private var spinPlayerSpeed:int;
		
		private var worldWobbleFrame:int = 0;
		private var scoreJumpFrame:int = 0;
		
		private var physics:PhysicsEngine = new PhysicsEngine ();
		private var distortion:DistortionEngine = new DistortionEngine ();
		private var power:PowerEngine = new PowerEngine ();
		
		private var mult:Number = 1;
		
		private var frame:int = 0;
		
		public override function Initialize (arg:Object = null) {
			GameData.Reset ();
			
			for (var i:int = 0; i < 25; i++) {
				var star:Shape = new Shape ();
				var g:Graphics = star.graphics;
				g.beginFill (0xFF0000);
				g.drawCircle (0, 0, 1);
				g.endFill ();
				star.x = Math.random () * stage.stageWidth;
				star.y = Math.random () * stage.stageHeight;
				starCont.addChild (star);
			}
			
			starCont.x = -stage.stageWidth / 2;
			starCont.y = -stage.stageHeight / 2;
			worldCont.addChild (starCont);
			
			islandGap = worldSpeed * 10;
			
			for (var i:int = 0; i < GameData.numIslands; i++) {
				var island:Shape = new Shape ();
				var g:Graphics = island.graphics;
				g.lineStyle (2, 0xFFFFFF);
				g.drawRect (0, 0, worldSpeed * GameData.maxFramesOnIsland, GameData.minIslandHeight);
				island.x = i * (island.width + islandGap);
				island.y = stage.stageHeight - island.height;
				islandCont.addChild (island);
			}
			
			var glow:GlowFilter = new GlowFilter ();
			glow.color = 0xFFFFFF;
			islandCont.filters = [glow];
			islandCont.x = -stage.stageWidth / 2;
			islandCont.y = -stage.stageHeight / 2;
			worldCont.addChild (islandCont);
			
			avatarCont.addChild (player);
			avatarCont.x = -stage.stageWidth / 2;
			avatarCont.y = -stage.stageHeight / 2;
			worldCont.addChild (avatarCont);
			
			sparkCont.filters = [glow];
			sparkCont.x = -stage.stageWidth / 2;
			sparkCont.y = -stage.stageHeight / 2;
			worldCont.addChild (sparkCont);
			
			powerCont.x = -stage.stageWidth / 2;
			powerCont.y = -stage.stageHeight / 2;
			powerCont.filters = [glow];
			worldCont.addChild (powerCont);
			
			worldCont.x = stage.stageWidth / 2;
			worldCont.y = stage.stageHeight / 2;
			addChild (worldCont);
			
			worldFade.gotoAndStop (1);
			stage.addChild (worldFade);
			addChild (txtScore);
			
			bttLogo.addEventListener (MouseEvent.MOUSE_DOWN, onLogoMouseDown, false, 0, true);
			stage.addChild (bttLogo);
			
			player.addEventListener (GameEvent.MustMakeRunSparks, onMustMakeRunSparks, false, 0, true);
			player.Initialize ();
			
			physics.SetWorldSpeed (worldSpeed);
			physics.SetStarCont (starCont);
			physics.SetIslandCont (islandCont);
			physics.SetPlayer (player);
			physics.SetCloneCont (avatarCont);
			physics.SetSparkCont (sparkCont);
			physics.addEventListener (GameEvent.MustMakeNewIsland, onMustMakeNewIsland, false, 0, true);
			physics.addEventListener (GameEvent.MustExplodePlayer, onMustExplodePlayer, false, 0, true);
			physics.addEventListener (GameEvent.MustRemoveSpark, onMustRemoveSpark, false, 0, true);
			physics.addEventListener (GameEvent.CloneOutOfStage, onCloneOutOfStage, false, 0, true);
			addChild (physics); 
			
			distortion.SetGameScreen (this);
			distortion.SetWorldSpeed (worldSpeed);
			distortion.SetWorldCont (worldCont);
			distortion.SetIslandCont (islandCont);
			distortion.SetPlayer (player);
			distortion.addEventListener (GameEvent.MustMakeLongIsland, onMustMakeLongIsland, false, 0, true);
			
			power.SetWorldSpeed (worldSpeed);
			power.SetPlayer (player);
			power.SetPowerCont (powerCont);
			power.addEventListener (GameEvent.GotPower, onGotPower, false, 0, true);
			power.addEventListener (GameEvent.MustRemovePower, onMustRemovePower, false, 0, true);
			addChild (power);
			
			var ct:ColorTransform = new ColorTransform ();
			ct.color = 0xFFFF00;
			transform.colorTransform = ct;

			Activate ();
		}
		
		public override function Activate (modalScreenMessage:String = null) {
			if (modalScreenMessage == "quit") {
				screenMgr.NewBigScreen (ScreenType.Menu);
			} else {
				addEventListener (Event.ENTER_FRAME, onFrame, false, 0, true);
				stage.addEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown, false, 0, true);
				
				player.Activate ();
				
				for (var i:int = 1; i < avatarCont.numChildren; i++) {
					Clone (avatarCont.getChildAt (i)).Activate ();
				}

				if (SoundManager.isMusicPlaying) {
					SoundManager.UnmuteMusic ();
				} else {
					SoundManager.PlayMusic ();
				}
				
				if (GameData.musicOn == false) {
					SoundManager.MuteMusic ();
				}
				
				if (worldFade.currentFrame > 1) {
					worldFade.play ();
				}
				
				stage.addChild (worldFade);
				stage.addChild (bttLogo);
				
				stage.focus = stage;
			}
		}
		
		public override function Deactivate () {
			removeEventListener (Event.ENTER_FRAME, onFrame);
			stage.removeEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown);
			
			player.Deactivate ();
			
			for (var i:int = 1; i < avatarCont.numChildren; i++) {
				Clone (avatarCont.getChildAt (i)).Deactivate ();
			}
			
			worldFade.stop ();
			
			if (worldFade.parent != null) {
				stage.removeChild (worldFade);
			}
			
			if (bttLogo.parent != null) {
				stage.removeChild (bttLogo);
			}
			
			SoundManager.MuteMusic ();
		}
		
		public override function PrepareToDie () {
			Deactivate ();
			
			bttLogo.removeEventListener (MouseEvent.MOUSE_DOWN, onLogoMouseDown);
			
			player.removeEventListener (GameEvent.MustMakeRunSparks, onMustMakeRunSparks);
			player.PrepareToDie ();
			
			for (var i:int = 1; i < avatarCont.numChildren; i++) {
				Clone (avatarCont.getChildAt (i)).PrepareToDie ();
			}
			
			SoundManager.StopMusic ();
		}
		
		private function onLogoMouseDown (e:MouseEvent) {
			if (gameOver == false) {
				navigateToURL (new URLRequest ("http://www.addictinggames.com"));
				screenMgr.AddModalScreen (ScreenType.Pause);
			}
		}
		
		private function onFrame (e:Event) {
			physics.Update ();
			distortion.Update ();
			power.Update ();

			if (clonesToMake > 0) {
				CreateClone ();
				clonesToMake--;
			}
			
			if (spinPlayerFrame > 0) {
				player.rotation += spinPlayerSpeed;
				spinPlayerFrame--;
			}
			
			if (worldWobbleFrame > 0) {
				worldCont.rotation = Math.random () * (GameData.worldWobbleMax * 2) - GameData.worldWobbleMax;
				worldWobbleFrame--;
			} else {
				worldCont.rotation = 0;
			}
			
			if (scoreJumpFrame > 0) {
				txtScore.x = Math.random () * (stage.stageWidth - txtScore.width);
				txtScore.y = Math.random () * (stage.stageHeight - txtScore.height);
				scoreJumpFrame--;
			} else {
				txtScore.x = 0;
				txtScore.y = 0;
			}
			
			if (gameOver) {
				if (gameOverFrame == 0) {
					screenMgr.NewBigScreen (ScreenType.GameOver);
				}
				
				SoundManager.FadeOutMusic ();
				gameOverFrame--;
			} else {
				GameData.score += worldSpeed * mult;
				txtScore.text = "x" + mult.toFixed (2) + "    " + GameData.score.toString ();
			}
			
			frame++;
		}

		private function onStageKeyDown (e:KeyboardEvent) {
			if (e.keyCode == Keyboard.ESCAPE) {
				screenMgr.AddModalScreen (ScreenType.Pause);
			}
		}
		
		private function onMustMakeNewIsland (e:GameEvent) {
			MakeNewIsland ();
		}
		
		private function onMustExplodePlayer (e:GameEvent) {
			for (var i:int = 0; i < 300; i++) {
				CreateSpark (SparkType.Explode, new Point (player.x, player.y));
			}
			
			GameOver ();
		}
		
		private function onMustRemoveSpark (e:GameEvent) {
			var spark:Spark = Spark (e.data);
			spark.Deactivate ();
			sparkCont.removeChild (spark);
		}
		
		private function onCloneOutOfStage (e:GameEvent) {
			if (e.data == player) {
				GameOver ();
			} else {
				RemoveClone (Clone (e.data));
			}
		}
		
		private function onMustMakeRunSparks (e:GameEvent) {
			for (var i:int = 0; i < worldSpeed / 3; i++) {
				CreateSpark (SparkType.Run, new Point (player.x, player.y));
			}
		}

		private function onMustMakeLongIsland (e:GameEvent) {
			var island:Shape = Shape (islandCont.getChildAt (islandCont.numChildren - 1));
			var h:int = island.height;
			var g:Graphics = island.graphics;
			g.clear ();
			g.lineStyle (2, 0xFFFFFF);
			g.drawRect (0, 0, worldSpeed * (GameData.distortionFrames + 60), h);
		}

		private function onMustRemovePower (e:GameEvent) {
			RemovePower (Power (e.data));
		}
		
		private function onGotPower (e:GameEvent) {
			var power:Power = Power (e.data);
			mult += GameData.powerMult;
			
			RemovePower (power);
			
			var type:String = PowerType.types [Math.floor (Math.random () * PowerType.types.length)];
			
			if (type == PowerType.Clones) {
				clonesToMake = GameData.numClones;
			} else if (type == PowerType.StarReverse) {
				physics.ChangeStarDirection ();
			} else if (type == PowerType.SparkReverse) {
				physics.ReverseSparkDirection ();
			} else if (type == PowerType.SpinPlayer) {
				spinPlayerFrame = GameData.spinPlayerFrames;
				spinPlayerSpeed = Math.floor (Math.random () * 40) - 20;
			} else if (type == PowerType.WorldFade) {
				worldFade.play ();
			} else if (type == PowerType.WorldWobble) {
				worldWobbleFrame = GameData.worldWobbleFrames;
			} else if (type == PowerType.ScoreJump) {
				scoreJumpFrame = GameData.scoreJumpFrames;
			}
		}
		
		private function RemovePower (power:Power) {
			powerCont.removeChild (power);
		}
		
		private function MakeNewIsland () {
			UpdateIslands ();
			
			var lastIsland:Shape = Shape (islandCont.getChildAt (GameData.numIslands - 1));
			var secondLastIsland:Shape = Shape (islandCont.getChildAt (GameData.numIslands - 2));
			
			var w:int = worldSpeed * (Math.floor (Math.random () * (GameData.maxFramesOnIsland - GameData.minFramesOnIsland)) + GameData.minFramesOnIsland);
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
			g.drawRect (0, 0, w, Math.floor (h));
			
			lastIsland.x = secondLastIsland.x + secondLastIsland.width + islandGap;
			lastIsland.y = stage.stageHeight - lastIsland.height;
			
			MakePower (new Rectangle (lastIsland.x, lastIsland.y, lastIsland.width, lastIsland.height));
		}
		
		private function UpdateIslands () {
			for (var i:int = 0; i < GameData.numIslands - 1; i++) {
				var island1:Shape = Shape (islandCont.getChildAt (i));
				var island2:Shape = Shape (islandCont.getChildAt (i + 1));
				var g:Graphics = island1.graphics;
				g.clear ();
				g.lineStyle (2, 0xFFFFFF);
				g.drawRect (0, 0, island2.width, island2.height);
				island1.x = island2.x;
				island1.y = island2.y;
			}
		}
		
		private function MakePower (islandRect:Rectangle) {
			var powerr:Power = new Power ();
			powerCont.addChild (powerr);
			powerr.Initialize (islandRect, worldSpeed);
		}
		
		private function CreateSpark (type:String, coords:Point) {
			var spark:Spark = new Spark ();
			sparkCont.addChild (spark);
			spark.Initialize (type, coords);
		}

		private function CreateClone () {
			var clone:Clone = new Clone ();
			avatarCont.addChild (clone);
			clone.Initialize (player.y);
		}
		
		private function RemoveClone (clone:Clone) {
			clone.PrepareToDie ();
			avatarCont.removeChild (clone);
		}

		private function GameOver () {
			gameOver = true;
			gameOverFrame = GameData.gameOverFrames;
			
			physics.SetGameOver ();
			power.SetGameOver ();
			
			player.PrepareToDie ();
			player.removeEventListener (GameEvent.MustMakeRunSparks, onMustMakeRunSparks);
			avatarCont.removeChild (player);
		}
	}
}