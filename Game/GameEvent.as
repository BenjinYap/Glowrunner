package Game {
	import flash.events.Event;
	
	public final class GameEvent extends Event {
		public static const MustMakeRunSparks:String = "a";
		public static const CloneOutOfStage:String = "c";
		public static const MustMakeNewIsland:String = "e";
		public static const MustRemoveSpark:String = "f";
		public static const MustExplodePlayer:String = "g";
		public static const PendingDistortion:String = "h";
		public static const WarnDistortion:String = "k";
		public static const DistortionComplete:String = "j";
		public static const MustMakeLongIsland:String = "i";
		public static const MustRemovePower:String = "l";
		public static const GotPower:String = "m";
		
		public var data:* = null;
		
		public function GameEvent (type:String, Data:* = null) {
			data = Data;
			super (type);
		}
	}
}