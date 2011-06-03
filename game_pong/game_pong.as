package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	
	public class game_pong extends MovieClip {
		var oGame:PongObj = new PongObj();
		
		public function game_pong() {
			// constructor code
			bStart.addEventListener(MouseEvent.CLICK,startGame);
			stop();
			
		}
		
		

		function startGame(event:MouseEvent) {
			gotoAndStop("playgame");
			stage.addEventListener(KeyboardEvent.KEY_DOWN, processKey);
			stage.focus = stage;
			stage.addChild(oGame);
			
		}
		
		function processKey(event:KeyboardEvent) {
			//trace("Key down");
			oGame.useRightPaddle(event);
		}
		
	}
	
}
