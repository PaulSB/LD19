package states 
{
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 18/12/10
	 */	
	
	public class MenuState extends FlxState
	{
		[Embed(source = "../../../Istria-Old-Style-Regular.ttf", fontFamily = "Istria", embedAsCFF = "false")] protected var junk:String;

		override public function create():void
		{
			bgColor = 0xff797979;
			
			// Title text
			var tTxt:FlxText;
			tTxt = new FlxText(0, 40, FlxG.width,
					"The Prophecy tells of The Five, the young band of "
					+"warriors who would meet the Demon Lord in combat "
					+"before his War of Chaos could decimate the land we "
					+"have called home since the days of our ancestors.\n\n"
					+"The time of The Prophecy is at hand. It is time for "
					+"The Five to discover their potential and rise to their calling, or else for everything "
					+"we know and love to be torn asunder and left to burn.\n\n"
					+"It is time.");
			tTxt.setFormat("Istria", 32, 0xfff2f2f2, "center");
			add(tTxt);
			
			// Shadow
			tTxt = new FlxText(0, FlxG.height -32 +2, FlxG.width +2, "Press 1 to begin");
			tTxt.setFormat("Istria", 20, 0xff000000, "center");
			add(tTxt);
			// Instruction text
			tTxt = new FlxText(0, FlxG.height -32, FlxG.width, "Press 1 to begin");
			tTxt.setFormat("Istria", 20, 0xfff2f2f2, "center");
			add(tTxt);
		}
		
		override public function update():void
		{
			if (FlxG.keys.justPressed("SPACE"))
			{
				FlxG.fade.start(0xff000000, 0.5, onFade);
			}            
			super.update();
		}
		
		private function onFade():void
		{
			FlxG.state = new PlayState();
		}
	}
}