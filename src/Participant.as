package  
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 18/12/10
	 */
	
	public class Participant extends FlxSprite
	{
		[Embed(source = '../data/characters/participant.png')] public var imgParticipant:Class;
		
		public function Participant(fYPos:Number) 
		{
			super(0, fYPos);
			loadGraphic(imgParticipant);
			
			x = FlxU.random() * (FlxG.width - width);
		}
	}
}