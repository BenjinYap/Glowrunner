package Game {
	import flash.geom.*;
	import Screener.*;
	
	public final class GameData {
		public static var soundOn:Boolean = true;
		public static var musicOn:Boolean = true;
		
		public static const numIslands:int = 3;
		public static const minFramesOnIsland:int = 30;
		public static const maxFramesOnIsland:int = 60;
		public static const minIslandHeight:int = 40;
		public static const maxIslandHeight:int = 200;
		public static const maxIslandHeightDifference:int = 40;
		
		public static const distortionDebut:int = 0;
		public static const distortionCountdown:int = 450;
		public static const distortionFrames:int = 50;
		
		public static const worldColors:Array = [0xFF0000, 0x00FF00, 0xFFFF00, 0x00FFFF, 0xFF00FF, 0x00FF00, 0xFFFFFF, 0xFF4500, 0x9400D3, 0x00FF99, 0xCC66CC, 0xFFCCCC, 0xFFCC00, 0x66FFCC];
		
		public static const playerX:int = 150;
		public static const jumpSpeed:int = 10;
		public static const avatarSize:Point = new Point (18, 40);
		
		public static const numClones:int = 15;
		public static const cloneMinSpeed:int = 2;
		public static const cloneMaxSpeed:int = 6;
		
		public static const gameOverFrames:int = 60;
		public static const musicFadeOutFrames:int = 45;
		
		public static const powerMult:Number = 0.1;
		
		public static const spinPlayerFrames:int = 120;
		public static const worldWobbleFrames:int = 60;
		public static const worldWobbleMax:int = 5;
		public static const scoreJumpFrames:int = 90;
		
		public static var score:int = 0;
		
		public static function Reset () {
			score = 0;
		}
	}
}