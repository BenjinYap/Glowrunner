package Game {
	import flash.display.*;
	import flash.geom.*;
	
	public class Power extends Shape {
		
		public function Initialize (islandRect:Rectangle, worldSpeed:int) {
			var g:Graphics = graphics;
			g.lineStyle (2, 0xFFFF00);
			g.drawRect (0, 0, worldSpeed * 5, 5);
			
			x = islandRect.x + Math.random () * (islandRect.width - width);
			y = islandRect.y - height;
		}
	}
}