package  
{
	/**
	 * ...
	 * @author geoffrey glangine
	 */
	public class PaquetCarte 
	{
		public var lesCartes:Array = new Array();
		
		public function PaquetCarte() 
		{
			for (var i:int = 0; i < 4 ; i++) 
			{
				for (var j:int = 1; j <= 13; j++) 
				{
					switch (i) 
					{
						case 0:
							lesCartes.push(new CarteCareau(j));
						break;
						case 1:
							lesCartes.push(new CarteCoeur(j));
						break;
						case 2:
							lesCartes.push(new CartePique(j));
						break;
						case 3:
							lesCartes.push(new CarteTrefle(j));
						break;
						default:
					}
				}
			}
		}
		public function shake():void 
		{
			var tabCartesAleatoire:Array = new Array();
			var position:int;
			while (lesCartes.length != 0) //tant qu'il reste des nombres dans le tableau des nombres en ordre croissant.
			{
				position = Math.floor(Math.random() * lesCartes.length); //générer une position du tableau aléatoirement 
				
				tabCartesAleatoire.push(lesCartes[position]); //mettre dans le tableau aléatoire le nombre compris dans l'indice généré.
				lesCartes.splice(position, 1); //enlever le nombre transféré du tableau de nombre en ordre croissant.
			}
			lesCartes = tabCartesAleatoire;
			//trace(lesCartes);
		}
		public function piocher():Carte {
			return lesCartes.shift();
			
		}
		public function remettre(carte:Carte):void {
			lesCartes.unshift(carte);
			
		}

		
	}

}