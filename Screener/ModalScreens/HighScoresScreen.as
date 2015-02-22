package Screener.ModalScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.net.*;
	import flash.xml.*;
	import mx.core.*;
	import Game.*;
	import Screener.*;
	
	public final class HighScoresScreen extends BaseScreen {
		private const numScoresToShow:int = 9;

		private var scoreBoxes:Array = [];
		
		private var allTimeScores:Array;
		private var todayScores:Array;
		private var phoneScores:Array;
		
		private var mouseDownTargets:Array;
		
		public override function Initialize (arg:Object = null) {
			mouseDownTargets = [bttBack];
			
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			}
			
			for (var i:int = 0; i < numScoresToShow; i++) {
				var scoreBox:MovieClip = new mcScoreBox ();
				scoreBoxes.push (scoreBox);
				scoreBox.x = 145;
				scoreBox.y = 65 + i * 22;
				addChild (scoreBox);
			}
			
			txtPhone.alpha = 0.5;
			
			GetScores (1);
			
			var date:Date = new Date ();
			var hourOffset:int = date.timezoneOffset / 60;
			var hour:int = date.hours - date.hoursUTC;
			hour = (hour < 0) ? hour + 24 : hour;
			var hourString:String;
			
			if (hour == 0) {
				hourString = "12 AM";
			} else if (hour < 12) {
				hourString = hour.toString () + " AM";
			} else if (hour == 12) {
				hourString = "12 PM";
			} else {
				hourString = (hour - 12).toString () + " PM";
			}
			
			txtTimezone.text = "Scores submitted since " + hourString + " local";
			txtTimezone.visible = false;
		}
		
		public override function PrepareToDie () {
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].removeEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}
		
		private function GetScores (gameMode:int) {
			phoneBar.visible = true;
			
			txtPhone.alpha = 0.5;
			
			Main.highScores.addEventListener (HighScoreEvent.PhoneReceived, onPhoneReceived, false, 0, true);
			Main.highScores.Refresh ();
		}

		private function onPhoneReceived (e:HighScoreEvent) {
			Main.highScores.removeEventListener (HighScoreEvent.PhoneReceived, onPhoneReceived);

			phoneBar.visible = false;
			
			phoneScores = e.data;
			
			txtPhone.alpha = 1;
			txtPhone.addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			txtPhone.dispatchEvent (new MouseEvent (MouseEvent.MOUSE_DOWN));
		}

		private function ShowScores (scoreArray:Array) {
				txtPhone.textColor = 0xFFFF00;
				txtTimezone.visible = false;
			
			for (var i:int = 0; i < scoreBoxes.length; i++) {
				if (i < scoreArray.length) {
					scoreBoxes [i].txtName.text = scoreArray [i].name;
					scoreBoxes [i].txtScore.text = scoreArray [i].score;
				} else {
					scoreBoxes [i].txtName.text = "";
					scoreBoxes [i].txtScore.text = "";
				}
			}
			
			if (scoreArray.length == 0) {
				var tf:TextFormat = scoreBoxes [0].txtName.getTextFormat ();
				tf.align = TextFormatAlign.CENTER;
				scoreBoxes [0].txtName.text = "No scores in this category";
				scoreBoxes [0].txtName.setTextFormat (tf);
			} else {
				var tf:TextFormat = scoreBoxes [0].txtName.getTextFormat ();
				tf.align = TextFormatAlign.LEFT;
				scoreBoxes [0].txtName.setTextFormat (tf);
			}
		}
		
		private function onMouseDown (e:MouseEvent) {
			if (e.currentTarget == txtPhone) {
				ShowScores (phoneScores);
			} else if (e.currentTarget == bttBack) {
				screenMgr.RemoveModalScreen ("");
			}
		}
	}
}