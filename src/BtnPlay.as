package  
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	
	/**
	 * ...
	 * @author geoffrey glangine
	 */
	public class BtnPlay extends SimpleButton 
	{
		
		public function BtnPlay(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null) 
		{
			super(upState, overState, downState, hitTestState);
			
		}
		
	}

}