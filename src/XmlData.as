package  
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.flixel.FlxU;
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 19/12/10
	 */
	public class XmlData
	{
		private var m_tXmlData:XML;
		
		static public var m_aForenames:Array;
		static public var m_aSurnames:Array;
		
		public function XmlData() 
		{
			m_aForenames = new Array;
			m_aSurnames = new Array;
			
			var xmlLoader:URLLoader = new URLLoader(new URLRequest("../data/xml/data.xml"));
			xmlLoader.addEventListener(Event.COMPLETE, processXML);
		}
		
		private function processXML(e:Event):void
		{
			m_tXmlData = new XML(e.target.data);
			
			for (var i:int = 0; i < 50; i++)
			{
				var iNameIndex:int = FlxU.random() * m_tXmlData.Names.Forename.length();
				m_aForenames.push(m_tXmlData.Names.Forename[iNameIndex]);
				
				iNameIndex = FlxU.random() * m_tXmlData.Names.Surname.length();
				m_aSurnames.push(m_tXmlData.Names.Surname[iNameIndex]);
			}
		}
	}
}