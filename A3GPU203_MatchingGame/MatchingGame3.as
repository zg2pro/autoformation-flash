﻿package {
	import flash.display.*;
	
	public class MatchingGame3 extends MovieClip {
		// game constants
		private static const boardWidth:uint = 6;
		private static const boardHeight:uint = 6;
		private static const cardHorizontalSpacing:Number = 52;
		private static const cardVerticalSpacing:Number = 52;
		private static const boardOffsetX:Number = 120;
		private static const boardOffsetY:Number = 45;

		public function MatchingGame3():void {
			// make a list of card numbers
			var cardlist:Array = new Array();
			for(var i:uint=0;i<boardWidth*boardHeight/2;i++) {
				cardlist.push(i);
				cardlist.push(i);
			}
			
			// create all the cards, position them, and assign a randomcard face to each
			for(var x:uint=0;x<boardWidth;x++) { // horizontal
				for(var y:uint=0;y<boardHeight;y++) { // vertical
					var c:Card = new Card(); // copy the movie clip
					c.stop(); // stop on first frame
					c.x = x*cardHorizontalSpacing+boardOffsetX; // set position
					c.y = y*cardVerticalSpacing+boardOffsetY;
					var r:uint = Math.floor(Math.random()*cardlist.length); // get a random face
					c.cardface = cardlist[r]; // assign face to card
					cardlist.splice(r,1); // remove face from list
					c.gotoAndStop(c.cardface+2);
					addChild(c); // show the card
				}
			}
		}
		
	}
}