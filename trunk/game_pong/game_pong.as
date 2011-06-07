package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class game_pong extends MovieClip {
		var oGame:PongObj;
		var myTimer:Timer = new Timer(40);
		
		public function game_pong() {
			bStart.addEventListener(MouseEvent.CLICK,startGame);
			myTimer.addEventListener(TimerEvent.TIMER, processTime);
			stop();
		}
		
		function startGame(event:MouseEvent) {
			gotoAndStop("playgame");
			stage.addEventListener(KeyboardEvent.KEY_DOWN, processKey);
			stage.focus = stage;
			oGame = new PongObj();
			stage.addChild(oGame);
			trace(currentLabel);
			myTimer.start();
			//while (PongObj.winner == null);
			//gotoAndStop("gameover");	
		}
		
		function processKey(event:KeyboardEvent) {
			if (oGame != null) oGame.useRightPaddle(event);
		}
		
		function processTime(event:TimerEvent) {
			if (oGame != null) {
				if (oGame.timerFunction(event) == 1) {
					oGame.stop();
					oGame.visible = false;
					myTimer.stop();
					gotoAndStop("gameover");
					var winnerName:TextField = new TextField();
					var tf:TextFormat = new TextFormat("Arial",32,0x00FF00,true);
					winnerName.text = oGame.winner+" wins";
					winnerName.x = 30;
					winnerName.y = 180;
					winnerName.width = 300;
					winnerName.setTextFormat(tf);
					//winnerName.defaultTextFormat = tf;
					winnerName.selectable = false ;
					addChild(winnerName);
				}//if
			}//if
		}//processTime
		
	}
	
}
