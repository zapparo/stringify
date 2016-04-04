package stringify 
{
	import stringify.BitmapDataProccesing;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Ionut Ghenade
	 */
	public class BitmapDataHelper 
	{
		private static const ZERO_POINT:Point = new Point();
		
		private static var _rect:Rectangle = new Rectangle();
		private static var _point:Point = new Point();	
		
		private static var _colorTrasform:ColorTransform;
		
		public function BitmapDataHelper() { }
		
		public static function getRedChannelFrom(pixel:uint):uint { return (pixel >> 16) & 0xFF;	}
		
		public static function getGreenChannelFrom(pixel:uint):uint { return (pixel >> 8) & 0xFF; }		
		
		public static function getBlueChannelFrom(pixel:uint):uint { return pixel & 0xFF; }		
		
		public static function getAlphaChannelFrom(pixel:uint):uint { return (pixel >> 24) & 0xFF; }
		
		public static function getRGBPixel(r:uint, g:uint, b:uint):uint { return (r << 16) | (g << 8) | b; }
		
		public static function getARGBPixel(a:uint, r:uint, g:uint, b:uint):uint { return (a << 24) | getRGBPixel(r, g, b); }
		
		public static function copy(source:BitmapData):BitmapData
		{			
			_rect.x = _rect.y = 0;
			_rect.width = source.width;
			_rect.height = _rect.height;
		
			var clone:BitmapData = new BitmapData(source.width, source.height, true, 0x00ffffff);
			clone.copyPixels(source, _rect, ZERO_POINT);
			
			return clone;
		}
		
		/**
		 * Tint bitmapdata
		 * @param source source bitmapdata
		 * @param color tint Color
		 * @param alpha 
		 */		
		public static function colorize(source:BitmapData, color:uint, alpha:Number = 1):void
		{
			if (_colorTrasform == null) { _colorTrasform = new ColorTransform(); }
			
			_rect.x = _rect.y = 0;
			_rect.width = source.width;
			_rect.height = source.height;
			
			_colorTrasform.alphaMultiplier = alpha;
			_colorTrasform.redMultiplier = BitmapDataHelper.getRedChannelFrom(color) / 0xff;
			_colorTrasform.greenMultiplier = BitmapDataHelper.getGreenChannelFrom(color) / 0xff;
			_colorTrasform.blueMultiplier = BitmapDataHelper.getBlueChannelFrom(color) / 0xff;
			
			source.colorTransform(_rect, _colorTrasform);
		}
		
		/**
		 * Get the average color of region
		 * @param source source bitmapdata
		 * @param rect region to average
		 * @return average color
		 */				
		public static function getAverageColor(source:BitmapData, rect:Rectangle):uint
		{
			var sumRed:Number = 0;
			var sumGreen:Number = 0;
			var sumBlue:Number = 0;			
			
			var pixels:Vector.<uint> = source.getVector(rect);
			for (var i:int = 0; i < pixels.length; i++) {
				var pixel:uint = pixels[i];
				sumRed += getRedChannelFrom(pixel);
				sumGreen += getGreenChannelFrom(pixel);
				sumBlue += getBlueChannelFrom(pixel);
			}
			
			sumRed /= pixels.length;
			sumGreen /= pixels.length;
			sumBlue /= pixels.length;
			
			pixels = null;
			
			return getARGBPixel(0xff, sumRed, sumGreen, sumBlue);
		}
				
		/**
		 * Get the average number of pixels with alpha > 0
		 * @param source source bitmapdata
		 * @param rect region to average
		 * @return average pixel count
		 */						
		public static function getPixelWeight(source:BitmapData, rect:Rectangle):Number
		{
			var sum:uint = 0;
			
			var pixels:Vector.<uint> = source.getVector(rect);
			for (var i:int = 0; i < pixels.length; i++) {
				if (BitmapDataHelper.getAlphaChannelFrom(pixels[i]) == 0xff) { sum++; }
			}
			
			return sum / (rect.width * rect.height);
		}
				
		/**
		 * Get the average alpha value of pixels
		 * @param source source bitmapdata
		 * @param rect region to average
		 * @return average alpha value
		 */								
		public static function getAlphaWeight(source:BitmapData, rect:Rectangle):Number
		{
			var sum:uint = 0;
			
			var pixels:Vector.<uint> = source.getVector(rect);
			for (var i:int = 0; i < pixels.length; i++) {
				sum += BitmapDataHelper.getAlphaChannelFrom(pixels[i]);				
			}
			
			return sum / (rect.width * rect.height * 0xff);			
		}		
	}

}