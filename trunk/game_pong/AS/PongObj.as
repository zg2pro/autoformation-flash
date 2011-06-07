package  {
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	
	public class PongObj extends MovieClip {

		var leftPaddle:Sprite = new Sprite();
		var rightPaddle:Sprite = new Sprite();
		var ballGraph:Sprite = new Sprite();
		var ball:BallObj;
		
		var winner:String;

		public function PongObj() {
			// constructor code
			leftPaddle.addChild(new Bitmap(new Paddle()));
			rightPaddle.addChild(new Bitmap(new Paddle()));
			ballGraph.addChild(new Bitmap(new Ball()));
			addChild(leftPaddle);
			addChild(rightPaddle);
			addChild(ballGraph);
			leftPaddle.x = 0;
			leftPaddle.y = 130;
			rightPaddle.x = 280;
			rightPaddle.y = 130;
			ball = new BallObj(130, 130);
			ballGraph.x = ball.position.x;
			ballGraph.y = ball.position.y;
			leftPaddle.addEventListener(MouseEvent.MOUSE_OVER, useLeftPaddle);
			//stage.focus.addEventListener(KeyboardEvent.KEY_DOWN, useRightPaddle);
		}
		
		function useLeftPaddle(event:MouseEvent) {
			leftPaddle.y = mouseY - 20;
			leftPaddle.addEventListener(MouseEvent.MOUSE_MOVE, moveLeftPaddle);
		}
		
		function moveLeftPaddle(event:MouseEvent){
			leftPaddle.y = mouseY - 20;
		}
		function useRightPaddle(event:KeyboardEvent) {
			//trace("hit keyboard");
			if (event.keyCode == 38) {
				rightPaddle.y -= 2;
			} else if (event.keyCode == 40) {
				rightPaddle.y += 2;
			}//if
		}//useRightPaddle
		
		function timerFunction(event:TimerEvent): int{
			checkCollisions();
			ball.moveBall();
			ballGraph.x = ball.position.x;
			ballGraph.y = ball.position.y;
			if (ball.position.x > 320) {
				winner = "Left player"; 
				stop();
				return 1 ;
			} else if (ball.position.x < -20){
				stop();
				winner = "Right player";
				return 1 ;
			} // if 
			return 0;
		}
		
		function checkCollisions(){
			if (ballGraph.hitTestObject(rightPaddle) || ballGraph.hitTestObject(leftPaddle))
			ball.strikeRLWall();
		}
		
	}//class
	
}
