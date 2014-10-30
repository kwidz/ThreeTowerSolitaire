package  
{
	import flash.display.MovieClip;
	/**
	 * Classe Carte avec une valeur et une indication de Retournée ou pas 
	 * @author geoffrey glangine
	 */
	public class Carte extends MovieClip
	{
		public var valeur:int;
		public var retournee:Boolean = false;
		
		//informations utiles au chainage des cartes 
		public var carte1:Carte = null;
		public var carte2:Carte = null;
		public var cartePrecedente1:Carte = null;
		public var cartePrecedente2:Carte = null;
		
		//position de la carte dans le tableau
		public var ligne:int;
		public var colone:int;
		
		//Si la carte est retournée, on lui ajoute une carte de dos
		public var carteDos:CarteDos = null;
		
		//informations Utiles au bouton Undo
		public var ancienX:int;
		public var ancienY:int;
		public var jouee:Boolean = false;
		
		public function Carte(valeur:int) 
		{
			this.valeur = valeur;
		}
		
	}

}