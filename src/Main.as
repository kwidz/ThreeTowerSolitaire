package 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author geoffrey glangine
	 */
	public class Main extends MovieClip 
	{
		
		public var btnplay:SimpleButton = new BtnPlay();
		private var partie:Partie;	
		
		public var gameOverScore:TextField = new TextField();
		public var wildCardBonus:TextField = new TextField();
		public var deckCardBonus:TextField = new TextField();
		public var roundNumberBonus:TextField = new TextField();
		public var yourScore:TextField = new TextField();
		public var pointage:TextField = new TextField();
		public var suite:TextField = new TextField();
		public var ronde:TextField = new TextField();
		
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			stop();
		}
		
		private function init(e:Event = null):void 
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			btnplay.x = 237;
			btnplay.y = 282;
			stage.addChild(btnplay);
			btnplay.addEventListener(MouseEvent.CLICK, clickplay);
			
		}
		
		private function clickplay(e:MouseEvent):void 
		{
			
			partie = new Partie(stage,this, gameOverScore, wildCardBonus, deckCardBonus, roundNumberBonus, yourScore, pointage, suite, ronde, new Score());			
			partie.jouer();
			stage.removeChild(btnplay);
			gotoAndStop("jeu");
			creerTextes();
			
			
		}	
		
		private function creerTextes():void {
			var police:TextFormat = new TextFormat();
			police.size = 20;
			police.color = 0xFFFFFF;
			police.font = "Times New Roman";
			police.bold = 0.5;
			
			pointage.defaultTextFormat = police;
			pointage.x = 173;
			pointage.y = 411;
			pointage.text = "0";
			stage.addChild(pointage);
			
			suite.defaultTextFormat = police;
			suite.x = 518;
			suite.y = 411;
			suite.text = "Suite : 0";
			stage.addChild(suite);
			
			ronde.defaultTextFormat = police;
			ronde.x = 518;
			ronde.y = 6;
			ronde.height = 30;
			ronde.text = "Ronde : 1";
			stage.addChild(ronde);
			
			wildCardBonus.defaultTextFormat = police;
			wildCardBonus.x = 372;
			wildCardBonus.y = 209;
			wildCardBonus.height = 30;
			
			deckCardBonus.defaultTextFormat = police;
			deckCardBonus.x = 372;
			deckCardBonus.y = 247;
			deckCardBonus.height = 30;
			
			roundNumberBonus.defaultTextFormat = police;
			roundNumberBonus.x = 372;
			roundNumberBonus.y = 284;
			roundNumberBonus.height = 30;
			
			yourScore.defaultTextFormat = police;
			yourScore.x = 372;
			yourScore.y = 317;
			yourScore.height = 30;
			
			gameOverScore.defaultTextFormat = police;
			gameOverScore.x = 248;
			gameOverScore.y = 238;
			gameOverScore.height = 30;
			
			
			
			}
		
	}
	
}