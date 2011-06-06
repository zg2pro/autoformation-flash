package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	
	public class game_pong extends MovieClip {
		var oGame:PongObj;
		
		public function game_pong() {
			bStart.addEventListener(MouseEvent.CLICK,startGame);
			stop();
		}
		
		function startGame(event:MouseEvent) {
			gotoAndStop("playgame");
			stage.addEventListener(KeyboardEvent.KEY_DOWN, processKey);
			stage.focus = stage;
			oGame = new PongObj();
			stage.addChild(oGame);
			//while (PongObj.winner == null);
			//gotoAndStop("gameover");	
		}
		
		function processKey(event:KeyboardEvent) {
			if (oGame != null) oGame.useRightPaddle(event);
		}
		
	}
	
}
