package 
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Ionut Ghenade
	 */
	public class Assets 
	{
		[Embed(source = '../assets/batman.jpg')] 
		public static const BATMAN_SUPERMAN_BMP:Class;		
	
		// files generated by BMFont generator
		[Embed(source = '../assets/zx_spectrum.png')] 
		public static const ZX_FONT_BMP:Class;		
		
		[Embed(source = '../assets/zx_spectrum.fnt', mimeType="application/octet-stream")] 
		public static const ZX_FONT_DATA:Class;				
		
		public function Assets() 
		{
			
		}
		
		public static function getBitmapData(file:Class):BitmapData
		{
			return (new file).bitmapData;
		}
		
		public static function getXML(file:Class):XML
		{
			var bytes:ByteArray = new file;
			return XML(bytes.readUTFBytes(bytes.length));
		}		
	}

}