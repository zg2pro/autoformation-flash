package  {
	import flash.geom.Point;
	import flash.events.DRMErrorEvent;
	
	public class BallObj {
		
		var position:Point;
		//var destination:Point;
		var vector:SpeedVector;

		public function BallObj(aX:int, aY:int) {
			position = new Point(aX, aY);
			vector = new SpeedVector();
			//destination = position.add(vector.speed);
			//MovieClip(root).graphics.drawCircle(position.x, position.y, 10);
		}
		
		public function moveBall(){
			//if (position.x > 270) strikeRLWall();
			if (position.y > 295 || position.y < 5) strikeUDWall();
			//position = destination;
			position = position.add(vector.speed);
			//MovieClip(root).graphics.drawCircle(position.x, position.y, 10);
		}
		
		public function strikeRLWall(){
			vector.updateVectorHorizontally();
		}
		public function strikeUDWall(){
			vector.updateVectorVertically();
		}

	}
	
}
