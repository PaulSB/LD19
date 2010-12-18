package states 
{
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 18/12/10
	 */
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
		
	public class MenuState extends FlxState
	{
		[Embed(source = "../../../Istria-Old-Style-Regular.ttf", fontFamily = "Istria", embedAsCFF = "false")] protected var junk:String;

		override public function create():void
		{
			bgColor = 0xff808080;
			
			// Title text
			var tTxt:FlxText;
			tTxt = new FlxText(0, FlxG.height / 2 -64, FlxG.width, "LD 19");
			tTxt.setFormat("Istria", 64, 0xffffffff, "center");
			add(tTxt);
			
			// Instruction text
			tTxt = new FlxText(0, FlxG.height -40, FlxG.width, "Press SPACE to PLAY");
			tTxt.setFormat("Istria", 20, 0xffb0b0b0, "center");
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