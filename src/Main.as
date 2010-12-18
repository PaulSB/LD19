package 
{
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 18/12/10
	 */
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import states.MenuState;
	
	// Display properties
	[SWF(width = "720", height = "480", backgroundColor = "#000000")]
	// Prep preloader
	[Frame(factoryClass="Preloader")]
	
	public class Main extends FlxGame
	{
		public function Main()
		{			
			// Entry - invoke FlxGame constructor
			super(720, 480, MenuState, 1);
		}
	}
}