package Screener {
	import Screener.BigScreens.*;
	import Screener.ModalScreens.*;

	public final class ScreenType {
		public static const Menu:Number = 0;
		public static const Game:Number = 1;
		public static const GameOver:Number = 2;
		public static const Confirm:Number = 3;
		public static const Pause:Number = 4;
		public static const Credits:Number = 5;
		public static const HighScores:Number = 6;
		public static const Splash:Number = 7;
		
		public static const classes:Array = [MenuScreen, GameScreen, GameOverScreen, ConfirmScreen, PauseScreen, CreditsScreen, HighScoresScreen, SplashScreen];
	}
}