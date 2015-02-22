package {
	import flash.net.*;
	import flash.xml.*;
	import flash.events.*;
	import Game.*;
	
	public class HighScores extends EventDispatcher {
		public static const apiKey:String = "352681b51e35a6d55057da183e34522724066490";
		public static const gameID:String = "fmpJ15tX7";
		
		private var totalScores:int;

		public function Refresh () {
			GetScoreCount ();
			GetPhoneScores ();
		}
		
		private function GetScoreCount () {
			var vars:URLVariables = new URLVariables ();
			vars.api_key = HighScores.apiKey;
			vars.game_id = HighScores.gameID;
			vars.response = "XML";
			var req:URLRequest = new URLRequest ("https://www.scoreoid.com/api/countScores");
			req.data = vars;
			req.method = URLRequestMethod.POST;
			var loader:URLLoader = new URLLoader ();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener (Event.COMPLETE, onGetScoreCountComplete, false, 0, true);
			loader.load (req);
		}
		
		private function onGetScoreCountComplete (e:Event) {
			e.currentTarget.removeEventListener (Event.COMPLETE, onGetScoreCountComplete);
			totalScores = Number (new XML (e.target.data));
			GetAllTimeScores ();
			GetTodayScores ();
		}
		
		private function GetAllTimeScores () {
			var vars:URLVariables = new URLVariables ();
			vars.api_key = HighScores.apiKey;
			vars.game_id = HighScores.gameID;
			vars.response = "XML";
			vars.order_by = "score";
			vars.order = "desc";
			vars.limit = totalScores;
			var req:URLRequest = new URLRequest ("https://www.scoreoid.com/api/getScores");
			req.data = vars;
			req.method = URLRequestMethod.POST;
			var loader:URLLoader = new URLLoader ();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener (Event.COMPLETE, onGetAllTimeScoresComplete, false, 0, true);
			loader.load (req);
		}
		
		private function onGetAllTimeScoresComplete (e:Event) {
			e.currentTarget.removeEventListener (Event.COMPLETE, onGetAllTimeScoresComplete);
			
			var xml:XML = new XML (e.target.data);
			var list:XMLList = xml.player;
			
			var scores:Array = [];
			
			for (var i:int = 0; i < list.length (); i++) {
				var playerName:String = list [i].attributes ()[0];
				var score:Number = Number (list [i].score [0].attributes ()[0]);
				scores.push ({name:playerName, score:score});
			}
			
			dispatchEvent (new HighScoreEvent (HighScoreEvent.AllTimeReceived, scores));
		}
		
		private function GetTodayScores () {
			var startDate:Date = new Date ();
			var startYear:String = startDate.fullYearUTC.toString ();
			var startMonth:String = (startDate.monthUTC + 1 < 10) ? "0" + (startDate.monthUTC + 1).toString () : (startDate.monthUTC + 1).toString ();
			var startDay:String = (startDate.dateUTC < 10) ? "0" + startDate.dateUTC.toString () : startDate.dateUTC.toString ();
			
			var endDate:Date = new Date (startDate.fullYearUTC, startDate.monthUTC, startDate.dateUTC + 1);
			var endYear:String = endDate.fullYearUTC.toString ();
			var endMonth:String = (endDate.monthUTC + 1 < 10) ? "0" + (endDate.monthUTC + 1).toString () : (endDate.monthUTC + 1).toString ();
			var endDay:String = (endDate.dateUTC < 10) ? "0" + endDate.dateUTC.toString () : endDate.dateUTC.toString ();
			
			var startDateString:String = startYear + "-" + startMonth + "-" + startDay;
			var endDateString:String = endYear + "-" + endMonth + "-" + endDay;
			
			var vars:URLVariables = new URLVariables ();
			vars.api_key = HighScores.apiKey;
			vars.game_id = HighScores.gameID;
			vars.response = "XML";
			vars.order_by = "score";
			vars.order = "desc";
			vars.limit = totalScores;
			vars.start_date = startDateString;
			vars.end_date = endDateString;
			var req:URLRequest = new URLRequest ("https://www.scoreoid.com/api/getScores");
			req.data = vars;
			req.method = URLRequestMethod.POST;
			var loader:URLLoader = new URLLoader ();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener (Event.COMPLETE, onGetTodayScoresComplete, false, 0, true);
			loader.load (req);
		}
		
		private function onGetTodayScoresComplete (e:Event) {
			e.currentTarget.removeEventListener (Event.COMPLETE, onGetTodayScoresComplete);
			
			var xml:XML = new XML (e.target.data);
			var list:XMLList = xml.player;
			
			var scores:Array = [];
			
			for (var i:int = 0; i < list.length (); i++) {
				var playerName:String = list [i].attributes ()[0];
				var score:Number = Number (list [i].score [0].attributes ()[0]);
				scores.push ({name:playerName, score:score});
			}
			
			dispatchEvent (new HighScoreEvent (HighScoreEvent.TodayReceived, scores));
		}
		
		private function GetPhoneScores () {
			var so:SharedObject = SharedObject.getLocal ("lightrunner");
			
			var scores:Array = [];
			
			if (so.size > 0) {
				for (var i:int = 0; i < so.data.scores.length; i++) {
					scores.push ({name:so.data.scores [i].name, score:so.data.scores [i].score});
				}
				
				for (var i:int = 0; i < scores.length; i++) {
					for (var j:int = i + 1; j < scores.length; j++) {
						if (scores [i].score <= scores [j].score) {
							var temp:Object = scores [j];
							scores [j] = scores [i];
							scores [i] = temp;
						}
					}
				}
			}
			
			so.close ();
			dispatchEvent (new HighScoreEvent (HighScoreEvent.PhoneReceived, scores));
		}
	}
}