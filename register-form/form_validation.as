package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class form_validation extends MovieClip {
		
		var errorMsg:TextField = new TextField();
			
		public function form_validation() {
			citiesCB.addItem({label:"TP Ho Chi Minh"});
			citiesCB.addItem({label:"Hanoi"});
			citiesCB.addItem({label:"Da Nang"});
			citiesCB.addItem({label:"Other"});
			passwordTI.displayAsPassword = true;
			bSubmit.addEventListener(MouseEvent.CLICK, validate);
			stop();
		}
		
		function validate(event:MouseEvent){
			var validity:Boolean = true;
			if (firstNameTI.text.length < 1) validity = false;
			if (lastNameTI.text.length < 1) validity = false;
			if (addressTI.text.length < 1) validity = false;
			if (passwordTI.text.length < 1) validity = false;
			if (emailTI.text.length < 1 || emailTI.text.indexOf("@")==-1) {
				validity = false;
			} 
			if (validity){
				gotoAndStop("Result");
				errorMsg.text = "";
			} else {
				var tf:TextFormat = new TextFormat("Arial",9,0xEE0000,true);
				errorMsg.text = "One of the fields is not valid";
				errorMsg.x = 10;
				errorMsg.y = 485;
				errorMsg.width = 300;
				errorMsg.setTextFormat(tf);
				errorMsg.selectable = false ;
				addChild(errorMsg);
			}
		}//function
		
	}
	
}
