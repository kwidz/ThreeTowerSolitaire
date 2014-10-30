package  
{
	/**
	 * Classe de score
	 * @author geoffrey glangine
	 */
	public class Score 
	{
		//nombre de points, taille de la suite, numero de la ronde
		//Bonus de wildCard, Bonus des cartes restantes
		//bonus lié au numéro de ronde
		public var pointage:int = 0;
		public var suite:int = 0;
		public var ronde:int = 1;
		public var wildCardBonus:int = 0;
		public var deckCardBonus:int = 0;
		public var roundBonus:int = 0;
		
		
		public function Score() 
		{
			
		}
		
	}

}