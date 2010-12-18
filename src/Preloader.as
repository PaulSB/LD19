package  
{
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 18/12/10
	 */
	import org.flixel.FlxPreloader;
		
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