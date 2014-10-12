package  
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author geoffrey glangine
	 */
	public class Partie
	{
		public var btnOk:BtnOk = new BtnOk();
		public var btnplay:BtnPlay = new BtnPlay();
		public var btnplayNext:PlayNextRound = new PlayNextRound();
		public var score:Score;
		
		private var carte:Carte;
		private var paquet:PaquetCarte;
		private var tableauDesCartes:Array;
		private var undo:Undo = new Undo();
		private var wildCard:WildCard;
		private var main:Main;
		
		//atributs à réinnitialiser au prochain round
		
		private var carteAvant:Carte = null;
		private var paquetjoue:Boolean = true;
		private var wild:Boolean = false;
		private var treeJoue:Boolean = false;
		private var firstTour:Boolean = true;
		private var stage:Stage;
		private var victoire:int;
		private var wildCardRecouverte:Boolean = false;
		private var paquetUse:Array = new Array();
		
		public var gameOverScore:TextField;
		public var wildCardBonus:TextField;
		public var deckCardBonus:TextField;
		public var roundNumberBonus:TextField;
		public var yourScore:TextField;
		public var pointage:TextField;
		public var suite:TextField;
		public var ronde:TextField;
		
		public function Partie(stage:Stage ,main:Main, gameOverScore:TextField, wildCardBonus:TextField, deckCardBonus:TextField, roundNumberBonus:TextField, yourScore:TextField, pointage:TextField, suite:TextField, ronde:TextField, score:Score) 
		{
			this.gameOverScore = gameOverScore;
			this.wildCardBonus = wildCardBonus;
			this.deckCardBonus = deckCardBonus;
			this.roundNumberBonus = roundNumberBonus;
			this.yourScore = yourScore;
			this.pointage = pointage;
			this.suite = suite;
			this.ronde = ronde;
			this.score = score;
			this.stage = stage;
			this.main = main;
			
			
		}
		public function jouer():void 
		{
			paquet = new PaquetCarte();
			paquet.shake();
			tableauDesCartes = new Array();
			
			creerTableau2D();
			creerChainage();
			trace(tableauDesCartes[0] + "\n" + tableauDesCartes[1] + "\n" + tableauDesCartes[2] + "\n" + tableauDesCartes[3]);
			afficherArbre();			
			afficherPaquet();
			trace(paquet.lesCartes.length);
			//affiche la première carte du paquet pour commencer le jeu
			clickOnCard(null);
			afficherWildCard();
			
			stage.addChild(ronde);
			stage.addChild(pointage);
			stage.addChild(suite);
			
			
		}
		
	private function clickOnCard(e:MouseEvent):void {
			
			if (e != null && !firstTour) {
				afficherUndo();
			}
			if (!firstTour) {
				if (carte.valeur == -1)
				wildCardRecouverte = true;
			}
			
			if(firstTour)
				firstTour = false;
			paquetjoue = true;
			wild = false;
			treeJoue = false;
			
			carteAvant = carte;
			
			carte = paquet.piocher();
			stage.removeChild(carte);
			stage.removeChild(carte.carteDos);
			carte.x = 360;
			carte.y = 355;
			paquetUse.push(carte);
			stage.addChild(carte);
			score.suite = 0;
			suite.text = "Suite : " + score.suite;
			if (estPerdue()) 
			{
				supprimerTousLesEnfants();
				main.gotoAndStop(4);
				preparePerdu();
			}
		}
		private function clickWildCard(e:MouseEvent):void {
			afficherUndo();
			paquetjoue = false;
			wild = true;
			treeJoue = false;
			carteAvant = carte;
			carte = Carte(e.target);
			stage.removeChild(carte);
			carte.x = 360;
			carte.y = 355;
			score.suite = 0;
			suite.text = "Suite : " + score.suite;
			stage.addChild(carte);
			
		}
		private function clickOnTree(e:MouseEvent):void {
			
			carteAvant = carte;
			paquetjoue = false;
			wild = false;
			treeJoue = true;
			var cartetmp:Carte = Carte(e.target);
			if (carte.valeur - 1 == cartetmp.valeur 
						|| carte.valeur + 1 == cartetmp.valeur 
						|| carte.valeur == 13 && cartetmp.valeur == 1 
						|| carte.valeur == 1 && cartetmp.valeur == 13
						||carte.valeur == -1) {
							
						
							
				if (carte.valeur == -1) {
					wildCardRecouverte = true;
				}
				cartetmp.jouee = true;
				afficherUndo();
				carte = cartetmp;
				victoire++;
			
				stage.removeChild(carte);
				tableauDesCartes[carte.ligne][carte.colone] = null;
				carte.ancienX = carte.x;
				carte.ancienY = carte.y;
				carte.x = 360;
				carte.y = 355;
				paquetUse.push(carte);
				score.pointage+= 200 + 200 * score.suite;
				score.suite+= 1;
				pointage.text = "" + score.pointage;
				suite.text = "Suite : " + score.suite;
				
				stage.addChild(carte);
						
			if (cartetmp.cartePrecedente1 != null){
				cartetmp.cartePrecedente1.carte1 = null;
				if (cartetmp.cartePrecedente1.carte1 == null && cartetmp.cartePrecedente1.carte2 == null){
				stage.removeChild(cartetmp.cartePrecedente1.carteDos);
				cartetmp.cartePrecedente1.addEventListener(MouseEvent.CLICK, clickOnTree);
			}
				
			}
			if(cartetmp.cartePrecedente2 != null){
				cartetmp.cartePrecedente2.carte2 = null;
				if (cartetmp.cartePrecedente2.carte1 == null && cartetmp.cartePrecedente2.carte2 == null){
				stage.removeChild(cartetmp.cartePrecedente2.carteDos);
				cartetmp.cartePrecedente2.addEventListener(MouseEvent.CLICK, clickOnTree);
				}
			}
						}
			
			if (estGagnee()) 
			{
				supprimerTousLesEnfants();
				main.gotoAndStop(3);
				prepareNextRound();
			}
			else
			if (estPerdue()) 
			{
				supprimerTousLesEnfants();
				main.gotoAndStop(4);
				preparePerdu();

			}
			
		}
		
		private function creerTableau2D():void 
		{
			for (var i:int = 0; i < 4; i++) 
			{
				tableauDesCartes[i]=new Array()
			}
		}
		
		private function creerChainage():void 
		{
			for (var j:int = 0; j < 10; j++) 
			{
				tableauDesCartes[0][j] = paquet.piocher();
				tableauDesCartes[0][j].ligne = 0;
				tableauDesCartes[0][j].colone = j;
				tableauDesCartes[0][j].addEventListener(MouseEvent.CLICK, clickOnTree);
			}
			for (var k:int = 0; k < 9; k++) 
			{
				tableauDesCartes[1][k] = paquet.piocher();
				tableauDesCartes[1][k].carte1 = tableauDesCartes[0][k];
				tableauDesCartes[0][k].cartePrecedente1 = tableauDesCartes[1][k];
				tableauDesCartes[1][k].carte2 = tableauDesCartes[0][k + 1];
				tableauDesCartes[0][k + 1].cartePrecedente2 = tableauDesCartes[1][k];
				tableauDesCartes[1][k].ligne = 1;
				tableauDesCartes[1][k].colone = k;
			}
			
			for (var l:int = 0; l < 9; l++) 
			{
				if((l+1)%3!=0){	
					tableauDesCartes[2][l] = paquet.piocher();
					tableauDesCartes[2][l].carte1 = tableauDesCartes[1][l];
					tableauDesCartes[1][l].cartePrecedente1 = tableauDesCartes[2][l];
					tableauDesCartes[2][l].carte2 = tableauDesCartes[1][l + 1];
					tableauDesCartes[1][l + 1].cartePrecedente2 = tableauDesCartes[2][l];
					tableauDesCartes[2][l].ligne = 2;
				tableauDesCartes[2][l].colone = l;
				}
			}
			for (var m:int = 0; m < 7; m++) 
			{
				if((m)%3==0){	
					tableauDesCartes[3][m] = paquet.piocher();
					tableauDesCartes[3][m].carte1 = tableauDesCartes[2][m];
					tableauDesCartes[2][m].cartePrecedente1 = tableauDesCartes[3][m]
					tableauDesCartes[3][m].carte2 = tableauDesCartes[2][m + 1];
					tableauDesCartes[2][m + 1].cartePrecedente2 = tableauDesCartes[3][m];
					tableauDesCartes[3][m].ligne = 3;
				tableauDesCartes[3][m].colone = m;
				}
			}
		}
		
		private function afficherArbre():void 
		{
			for (var n:int = 3; n >=0; n--) 
			{
				for (var o:int = 9; o >=0; o--) 
				{
					if(tableauDesCartes[n][o] != null){
						tableauDesCartes[n][o].x = 37+ n*35 + tableauDesCartes[n][o].colone * 63;
						tableauDesCartes[n][o].y = 230 - tableauDesCartes[n][o].ligne * 45;
						tableauDesCartes[n][o].gotoAndStop(tableauDesCartes[n][o].valeur);
						stage.addChild(tableauDesCartes[n][o]);
						if (tableauDesCartes[n][o].carte1!=null || tableauDesCartes[n][o].carte2!=null) 
						{
							tableauDesCartes[n][o].carteDos = new CarteDos(0);
							tableauDesCartes[n][o].carteDos.x = tableauDesCartes[n][o].x;
							tableauDesCartes[n][o].carteDos.y = tableauDesCartes[n][o].y;
							stage.addChild(tableauDesCartes[n][o].carteDos);
						}
						
					}
				}
			}
		}
		
		private function afficherPaquet():void 
		{
			for (var p:int = 0; p < paquet.lesCartes.length; p++) 
			{
				paquet.lesCartes[p].y = 355;
				paquet.lesCartes[p].x =60 + p * 10;
				paquet.lesCartes[p].gotoAndStop(paquet.lesCartes[p].valeur)
				paquet.lesCartes[p].carteDos = new CarteDos(0);
				paquet.lesCartes[p].carteDos.x = paquet.lesCartes[p].x;
				paquet.lesCartes[p].carteDos.y = paquet.lesCartes[p].y;
				stage.addChild(paquet.lesCartes[p]);
				stage.addChild(paquet.lesCartes[p].carteDos);
				if (p==paquet.lesCartes.length - 1) 
				{
					paquet.lesCartes[p].carteDos.addEventListener(MouseEvent.CLICK, clickOnCard)
				}
			}
		}
		
		private function afficherWildCard():void 
		{
			wildCard = new WildCard();
			wildCard.x = 550;
			wildCard.y = 355;
			wildCard.addEventListener(MouseEvent.CLICK, clickWildCard);
			stage.addChild(wildCard);
		}
		private function afficherUndo():void {
			
			undo.x = 406;
			undo.y = 355;
			stage.addChild(undo);
			undo.addEventListener(MouseEvent.CLICK, clickOnUndo)
		}
		private function masquerUndo():void {
			stage.removeChild(undo);
		}
		private function clickOnUndo(e:MouseEvent):void {
			score.suite = 0;
			suite.text = "Suite : " + score.suite;
			if (paquetjoue) 
			{
				paquet.remettre(carte);				
				stage.removeChild(carte);
				carte.x = carte.carteDos.x;
				carte.y = carte.carteDos.y;
				stage.addChildAt(carte.carteDos,1);
				stage.addChildAt(carte,0);
				carte = carteAvant;
				
			}
			if (wild) 
			{
				stage.removeChild(wildCard);
				wildCard.x = 550;
				wildCard.y = 355;
				stage.addChild(wildCard);
				carte = carteAvant;
				
			}
			if (treeJoue) {
				victoire--;
					
					if (carte.cartePrecedente1!=null) 
					{				
						trace("carte precedente1");
						if (carte.cartePrecedente1.carte1 ==null && carte.cartePrecedente1.carte2 == null) 
						{
							stage.addChild(carte.cartePrecedente1.carteDos);
						}
						carte.cartePrecedente1.carte1 = carte;
					}
					
					if (carte.cartePrecedente2!=null) 
					{	trace("carte precedente2");					
						if (carte.cartePrecedente2.carte2 ==null && carte.cartePrecedente2.carte1 == null) 
						{
							stage.addChild(carte.cartePrecedente2.carteDos);
						}
						carte.cartePrecedente2.carte2 = carte;
					}
					
					stage.removeChild(carte);
					carte.x = carte.ancienX;
					carte.y = carte.ancienY;
					stage.addChild(carte);
					carte.jouee = false;
					
					carte = carteAvant;
					
				}
			masquerUndo();
		}
		
		public function estGagnee():Boolean {
			if (victoire == 28)
				return true;
				
			return false;
		}
		public function estPerdue():Boolean {
			if (wildCardRecouverte && !estGagnee() && aucunCoupJouable())
				return true;
			return false;
		}
		public function aucunCoupJouable():Boolean 
		{
			var jouable:Boolean = false;
			trace(paquet.lesCartes.length);
			trace("aucun coup jouable");
			if (paquet.lesCartes.length == 0) {
				trace("paquet vide");
				for (var n:int = 3; n >=0; n--) 
				{
					for (var o:int = 9; o >=0; o--) 
					{
						if (tableauDesCartes[n][o] != null) {
							if (tableauDesCartes[n][o].jouee == false) {
								if (tableauDesCartes[n][o].carte1==null&&tableauDesCartes[n][o].carte2==null) 
								{
									var cartetmp:Carte = tableauDesCartes[n][o];
									if (carte.valeur - 1 == cartetmp.valeur 
															|| carte.valeur + 1 == cartetmp.valeur 
															|| carte.valeur == 13 && cartetmp.valeur == 1 
															|| carte.valeur == 1 && cartetmp.valeur == 13
															||carte.valeur == -1) 
									{
										trace("jouable");
										jouable = true;
										
									}
								}
								}
						}
					}
				}
			}
			else {
				return false;
			}
			if (jouable) 
			{
				
				return false;
			}
			return true;
		}
		
		public function supprimerTousLesEnfants():void {
			for (var n:int = 3; n >=0; n--) 
				{
					for (var o:int = 9; o >=0; o--) 
					{
						if (tableauDesCartes[n][o] != null) {
							stage.removeChild(tableauDesCartes[n][o]);
							if (tableauDesCartes[n][o].carte1!=null || tableauDesCartes[n][o].carte2!=null  ) 
							{
								stage.removeChild(tableauDesCartes[n][o].carteDos);
							}
						}
					}
				}
				for (var i:int = 0; i < paquet.lesCartes.length; i++) 
				{
					stage.removeChild(paquet.lesCartes[i]);
					stage.removeChild(paquet.lesCartes[i].carteDos);
				}
				for (var j:int = 0; j < paquetUse.length; j++) 
				{
					try 
					{
						stage.removeChild(paquetUse[j]);

					}
					catch (err:Error)
					{
						
					}
				}
				stage.removeChild(undo);
				stage.removeChild(wildCard);
				stage.removeChild(ronde);
				stage.removeChild(pointage);
				stage.removeChild(suite);
		}
		
		public function preparePerdu():void{
			btnOk.x = 270;
			btnOk.y = 325;
			gameOverScore.text = "" + score.pointage;
			stage.addChild(gameOverScore);
			stage.addChild(btnOk);
			btnOk.addEventListener(MouseEvent.CLICK, clickOk);
		}
		public function clickOk(e:MouseEvent):void 
		{
			stage.removeChild(btnOk);
			main.gotoAndStop(1);
			stage.removeChild(gameOverScore);
			prepareMenu();
		}
		
		public function prepareMenu():void{
			btnplay.x = 237;
			btnplay.y = 282;
			stage.addChild(btnplay);
			btnplay.addEventListener(MouseEvent.CLICK, clickplay);
		}
		public function clickplay(e:MouseEvent):void 
		{
			var partie:Partie = new Partie(stage,main,  gameOverScore, wildCardBonus, deckCardBonus, roundNumberBonus, yourScore, pointage, suite, ronde, new Score());
			
			partie.jouer();
			stage.removeChild(btnplay);
			main.gotoAndStop("jeu");	
			ronde.text = "Ronde : " + score.ronde;
		}
		public function prepareNextRound():void {
			calculBonus();
			wildCardBonus.text = ""+score.wildCardBonus;
			deckCardBonus.text = ""+score.deckCardBonus;
			roundNumberBonus.text = ""+score.roundBonus;
			yourScore.text = ""+score.pointage;
			stage.addChild(wildCardBonus);
			stage.addChild(deckCardBonus);
			stage.addChild(roundNumberBonus);
			stage.addChild(yourScore);
			btnplayNext.x = 242;
			btnplayNext.y = 375;
			stage.addChild(btnplayNext);
			trace(btnplayNext);
			btnplayNext.addEventListener(MouseEvent.CLICK, clicknext);
		}
		public function clicknext(e:MouseEvent):void 
		{
			main.gotoAndStop("jeu");
			ronde.text = "Ronde : " + score.ronde;
			var partie:Partie = new Partie(stage,main,  gameOverScore, wildCardBonus, deckCardBonus, roundNumberBonus, yourScore, pointage, suite, ronde,score);			
			partie.jouer();
			stage.removeChild(btnplayNext);
			stage.removeChild(wildCardBonus);
			stage.removeChild(deckCardBonus);
			stage.removeChild(roundNumberBonus);
			stage.removeChild(yourScore);
			pointage.text = ""+score.pointage;
				
		}
		
		public function calculBonus():void {
			if (!wild) 
			{
				score.wildCardBonus = 2500;
			}
			else {
				score.wildCardBonus = 0;
			}
			score.deckCardBonus = paquet.lesCartes.length * 100;
			score.roundBonus = score.ronde * 1000;
			score.pointage += score.wildCardBonus + score.deckCardBonus + score.roundBonus;
			score.ronde++;
		}
		
	}
	

}