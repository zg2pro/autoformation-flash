﻿package {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.geom.*;
	import flash.utils.getTimer;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public class TopDownDrive extends MovieClip {
		
		// constants
		static const speed:Number = .3;
		static const turnSpeed:Number = .2;
		static const carSize:Number = 50;
		static const mapRect:Rectangle = new Rectangle(-1150,-1150,2300,2300);
		static const numTrashObjects:uint = 100;
		static const maxCarry:uint = 10;
		static const pickupDistance:Number = 30;
		static const dropDistance:Number = 40;
		
		// game objects
		private var blocks:Array;
		private var trashObjects:Array;
		private var trashcans:Array;
	
		// game variables
		private var arrowLeft, arrowRight, arrowUp, arrowDown:Boolean;
		private var lastTime:int;
		private var gameStartTime:int;
		private var onboard:Array;
		private var totalTrashObjects:int;
		private var score:int;
		private var lastObject:Object;
		
		// sounds
		var theHornSound:HornSound = new HornSound();
		var theGotOneSound:GotOneSound = new GotOneSound();
		var theFullSound:FullSound = new FullSound();
		var theDumpSound:DumpSound = new DumpSound();

		public function startTopDownDrive() {
			
			// get blocks
			findBlocks();
			
			// place trash items
			placeTrash();
			
			// set trash cans 
			trashcans = new Array(gamesprite.Trashcan1,gamesprite.Trashcan2,gamesprite.Trashcan3);
			
			// make sure car is on top
			gamesprite.setChildIndex(gamesprite.car,gamesprite.numChildren-1);
			
			// add listeners
			this.addEventListener(Event.ENTER_FRAME,gameLoop);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownFunction);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpFunction);
			
			// set up game variables
			gameStartTime = getTimer();
			onboard = new Array(0,0,0);
			totalTrashObjects = 0;
			score = 0;
			centerMap();
			showScore();
			
			playSound(theHornSound);
		}

		// find all Block objects
		public function findBlocks() {
			blocks = new Array();
			for(var i=0;i<gamesprite.numChildren;i++) {
				var mc = gamesprite.getChildAt(i);
				if (mc is Block) {
					// add to array and make invisible
					blocks.push(mc);
					mc.visible = false;
				}
			}
		}
		
		// create random Trash objects 
		public function placeTrash() {
			trashObjects = new Array();
			for(var i:int=0;i<numTrashObjects;i++) {
				
				// loop forever
				while (true) {
					
					// random location
					var x:Number = Math.floor(Math.random()*mapRect.width)+mapRect.x;
					var y:Number = Math.floor(Math.random()*mapRect.height)+mapRect.y;
					
					// check all blocks to see if it is over any
					var isOnBlock:Boolean = false;
					for(var j:int=0;j<blocks.length;j++) {
						if (blocks[j].hitTestPoint(x+gamesprite.x,y+gamesprite.y)) {
							isOnBlock = true;
							break;
						}
					}
					
					// not over any, so use location
					if (!isOnBlock) {
						var newObject:TrashObject = new TrashObject();
						newObject.x = x;
						newObject.y = y;
						newObject.gotoAndStop(Math.floor(Math.random()*3)+1);
						gamesprite.addChild(newObject);
						trashObjects.push(newObject);
						break;
					}
				}
			}
		}
		
		// note key presses, set properties
		public function keyDownFunction(event:KeyboardEvent) {
			if (event.keyCode == 37) {
				arrowLeft = true;
			} else if (event.keyCode == 39) {
				arrowRight = true;
			} else if (event.keyCode == 38) {
				arrowUp = true;
			} else if (event.keyCode == 40) {
				arrowDown = true;
			}
		}
		
		public function keyUpFunction(event:KeyboardEvent) {
			if (event.keyCode == 37) {
				arrowLeft = false;
			} else if (event.keyCode == 39) {
				arrowRight = false;
			} else if (event.keyCode == 38) {
				arrowUp = false;
			} else if (event.keyCode == 40) {
				arrowDown = false;
			}
		}

		// main game code
		public function gameLoop(event:Event) {
			
			// calculate time passed
			if (lastTime == 0) lastTime = getTimer();
			var timeDiff:int = getTimer()-lastTime;
			lastTime += timeDiff;
			
			// rotate left or right
			if (arrowLeft) {
				rotateCar(timeDiff,"left");
			}
			if (arrowRight) {
				rotateCar(timeDiff,"right");
			}
			
			// move car
			if (arrowUp) {
				moveCar(timeDiff);
				centerMap();
				checkCollisions();
			}
			
			// update time and check for end of game
			showTime();
		}
		
		// make sure car stays at center of screen
		public function centerMap() {
			gamesprite.x = -gamesprite.car.x + 275;
			gamesprite.y = -gamesprite.car.y + 200;
			//gamesprite.x = -gamesprite.car.x + 550;
			//gamesprite.y = -gamesprite.car.y + 400;
		}
		
		public function rotateCar(timeDiff:Number, direction:String) {
			if (direction == "left") {
				gamesprite.car.rotation -= turnSpeed*timeDiff;
			} else if (direction == "right") {
				gamesprite.car.rotation += turnSpeed*timeDiff;
			}
		}
		
		// move car forward
		public function moveCar(timeDiff:Number) {
			// calculate current car area
			var carRect = new Rectangle(gamesprite.car.x-carSize/2, gamesprite.car.y-carSize/2, carSize, carSize);
			
			// calculate new car area
			var newCarRect = carRect.clone();
			var carAngle:Number = (gamesprite.car.rotation/360)*(2.0*Math.PI);
			var dx:Number = Math.cos(carAngle);
			var dy:Number = Math.sin(carAngle);
			newCarRect.x += dx*speed*timeDiff;
			newCarRect.y += dy*speed*timeDiff;
			
			// calculate new location
			var newX:Number = gamesprite.car.x + dx*speed*timeDiff;
			var newY:Number = gamesprite.car.y + dy*speed*timeDiff;
			
			// loop through blocks and check collisions
			for(var i:int=0;i<blocks.length;i++) {
				
				// get block rectangle, see if there is a collision
				var blockRect:Rectangle = blocks[i].getRect(gamesprite);
				if (blockRect.intersects(newCarRect)) {
		
					// horizontal push-back
					if (carRect.right <= blockRect.left) {
						newX += blockRect.left - newCarRect.right;
					} else if (carRect.left >= blockRect.right) {
						newX += blockRect.right - newCarRect.left;
					}
					
					// vertical push-back
					if (carRect.top >= blockRect.bottom) {
						newY += blockRect.bottom-newCarRect.top;
					} else if (carRect.bottom <= blockRect.top) {
						newY += blockRect.top - newCarRect.bottom;
					}
				}
				
			}
			
			// check for collisions with sidees
			if ((newCarRect.right > mapRect.right) && (carRect.right <= mapRect.right)) {
				newX += mapRect.right - newCarRect.right;
			}
			if ((newCarRect.left < mapRect.left) && (carRect.left >= mapRect.left)) {
				newX += mapRect.left - newCarRect.left;
			}
			
			if ((newCarRect.top < mapRect.top) && (carRect.top >= mapRect.top)) {
				newY += mapRect.top-newCarRect.top;
			}
			if ((newCarRect.bottom > mapRect.bottom) && (carRect.bottom <= mapRect.bottom)) {
				newY += mapRect.bottom - newCarRect.bottom;
			}
		
			// set new car location
			gamesprite.car.x = newX;
			gamesprite.car.y = newY;
		}
		
		// turn car left or right
		// check for collisions with trash and trash cans
		public function checkCollisions() {
			
				
			// loop through trash cans
			for(var i:int=trashObjects.length-1;i>=0;i--) {
		
				// see if close enough to get trash objects
				if (Point.distance(new Point(gamesprite.car.x,gamesprite.car.y), new Point(trashObjects[i].x, trashObjects[i].y)) < pickupDistance) {
						
					// see if there is room
					if (totalTrashObjects < maxCarry) {
						// get trash object
						onboard[trashObjects[i].currentFrame-1]++;
						gamesprite.removeChild(trashObjects[i]);
						trashObjects.splice(i,1);
						showScore();
						playSound(theGotOneSound);
					} else if (trashObjects[i] != lastObject) {
						playSound(theFullSound);
						lastObject = trashObjects[i];
					}
				}
			}
			
			// drop off trash if close to trashcan
			for(i=0;i<trashcans.length;i++) {
				
				// see if close enough
				if (Point.distance(new Point(gamesprite.car.x,gamesprite.car.y), new Point(trashcans[i].x, trashcans[i].y)) < dropDistance) {
					
					// see if player has some of that type of trash
					if (onboard[i] > 0) {
						
						// drop off
						score += onboard[i];
						onboard[i] = 0;
						showScore();
						playSound(theDumpSound);
						
						// see if all trash has been dropped off
						if (score >= numTrashObjects) {
							endGame();
							break;
						}
					}
				}
			}
		}
		
		// update the time shown
		public function showTime() {
			var gameTime:int = getTimer()-gameStartTime;
			timeDisplay.text = clockTime(gameTime);
		}
		
		// convert to time format
		public function clockTime(ms:int):String {
			var seconds:int = Math.floor(ms/1000);
			var minutes:int = Math.floor(seconds/60);
			seconds -= minutes*60;
			var timeString:String = minutes+":"+String(seconds+100).substr(1,2);
			return timeString;
		}
		
		// update the score text elements
		public function showScore() {
			
			// set each trash number, add up total
			totalTrashObjects = 0;
			for(var i:int=0;i<3;i++) {
				this["onboard"+(i+1)].text = String(onboard[i]);
				totalTrashObjects += onboard[i];
			}
			
			// set color of all three based on whether full
			for(i=0;i<3;i++) {
				if (totalTrashObjects >= 10) {
					this["onboard"+(i+1)].textColor = 0xFF0000;
				} else {
					this["onboard"+(i+1)].textColor = 0xFFFFFF;
				}
			}
			
			// set number left and score
			numLeft.text = String(trashObjects.length);
			scoreDisplay.text = String(score);
		}
		
		// game over, remove listeners
		public function endGame() {
			blocks = null;
			trashObjects = null;
			trashcans = null;
			this.removeEventListener(Event.ENTER_FRAME,gameLoop);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownFunction);
			stage.removeEventListener(KeyboardEvent.KEY_UP,keyUpFunction);
			gotoAndStop("gameover");
		}
		
		// show time on final screen
		public function showFinalMessage() {
			showTime();
			var finalDisplay:String = "";
			finalDisplay += "Time: "+timeDisplay.text+"\n";
			finalMessage.text = finalDisplay;
		}
		
		public function playSound(soundObject:Object) {
			var channel:SoundChannel = soundObject.play();
		}
	}
		
}