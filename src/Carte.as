package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author geoffrey glangine
	 */
	public class Carte extends MovieClip
	{
		public var valeur:int;
		public var retournee:Boolean = false;
		public var carte1:Carte = null;
		public var carte2:Carte = null;
		public var cartePrecedente1:Carte = null;
		public var cartePrecedente2:Carte = null;
		public var ligne:int;
		public var colone:int;
		public var carteDos:CarteDos = null;
		public var ancienX:int;
		public var ancienY:int;
		public var jouee:Boolean = false;
		
		public function Carte(valeur:int) 
		{
			this.valeur = valeur;
		}
		
	}

}