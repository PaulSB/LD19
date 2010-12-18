package  
{
	import org.flixel.FlxPreloader;
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 18/12/10
	 */
	
	public class Preloader extends FlxPreloader
	{
		public function Preloader() 
		{
			className = "Main";
			super();
			
			// Force at least this much preloader
			minDisplayTime = 3;
		}
	}
}