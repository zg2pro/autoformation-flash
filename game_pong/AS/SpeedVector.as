package  {
	import flash.geom.Point;
	
	public class SpeedVector {

		var speed:Point;
		
		public function SpeedVector(){
			var v = new Array(); 
			v[0] =  new Point(-2, 1);
			v[1] =  new Point(-2, -1);
			v[2] =  new Point(2, 1);
			v[3] =  new Point(2, -1);
			var randomIndex:int = Math.round (Math.random () * (v.length - 1));
			speed = v[randomIndex];
		}
		
		public function updateVectorHorizontally(){
			speed.x = 0 - speed.x;
		}
		public function updateVectorVertically(){
			speed.y = 0 - speed.y;
		}
		
	}
	
}
