package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class stop_watch extends MovieClip {
		
		var myTimer:Timer = new Timer(1);
		var minutes:int;
		var seconds:int;
		var milliseconds:int;
		var maxMin:int;
		var maxSec:int;
		var maxMs:int;
		var timeInterval:int;
		var secDisplay:String;
		var msDisplay:String;
		var minDisplay:String;
		var counter:TextField = new TextField();
		var timeRunning:Boolean;
			
		
function processTime(event:TimerEvent) {
	updateClock();
	if (seconds == maxSec && milliseconds == maxMs && minutes == maxMin) {
		clockIsOver();
	} else if (milliseconds < maxMs && seconds < maxSec && minutes < maxMin) {
		milliseconds++;
	} else if (milliseconds == maxMs && seconds < maxSec  && minutes < maxMin) {
		seconds++;
		milliseconds = 0;
	} else if (milliseconds == maxMs && seconds == maxSec  && minutes < maxMin){
		seconds = 0;
		milliseconds = 0;
		minutes++;
	}
}
function updateClock() {
	if (seconds >= 10) {
		secDisplay = ""+seconds;
	} else {
		secDisplay = "0" + seconds;
	}
	if (milliseconds >= 10) {
		msDisplay = ""+milliseconds;
	} else {
		msDisplay = "0" + milliseconds;
	}
	if (minutes >= 10) {
		minDisplay = ""+minutes;
	} else {
		minDisplay = "0" + minutes;
	}
	counter.text = minDisplay+":"+secDisplay + ":" + msDisplay;
}
function clockIsOver() {
	stop();
}
		
		public function stop_watch() {
			minutes = 0; seconds = 0; milliseconds = 0;
			maxMin = 99; maxSec = 59, maxMs = 99;
			bPlay.addEventListener(MouseEvent.CLICK,runTime);
			bReset.addEventListener(MouseEvent.CLICK,reset);
			var tf:TextFormat = new TextFormat("Arial",32,0x00FF00,true);
			counter.x = 30;
			counter.y = 50;
			counter.width = 300;
			counter.defaultTextFormat = tf;
			counter.text = "00:00:00";
			counter.selectable = false ;
			addChild(counter);
			//timeInterval = setInterval(increaseMS, 1);
		}
		
		function runTime(event:MouseEvent){
			if (timeRunning){
				timeRunning = false;
				bPlay.label = "PLAY";
				myTimer.stop();
			}
			else {
				timeRunning = true;
				bPlay.label = "PAUSE";
				myTimer.addEventListener(TimerEvent.TIMER, processTime);
				myTimer.start();
			}
		}
		
		function reset(event:MouseEvent){
			timeRunning = false;
			bPlay.label = "PLAY";
			minutes = 0; seconds = 0; milliseconds = 0;
			counter.text = "00:00:00";
		}
		
		
	}
	
}
