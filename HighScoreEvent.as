package {
	import flash.events.Event;
	
	public final class HighScoreEvent extends Event {
		public static const AllTimeReceived:String = "a";
		public static const TodayReceived:String = "b";
		public static const PhoneReceived:String = "c";
		public static const ReceiveFailed:String = "d";
		
		public var data:* = null;
		
		public function HighScoreEvent (type:String, Data:* = null) {
			data = Data;
			super (type);
		}
	}
}