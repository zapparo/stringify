package stringify 
{
	import stringify.FontTexture;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import stringify.BitmapDataHelper;
	/**
	 * ...
	 * @author Ionut Ghenade
	 */
	public class BitmapDataProccesing 
	{	
		public function BitmapDataProccesing() 
		{
			
		}
		
		/**
		 * Get a grayscale version of a bmpdata using luminosity
		 * @param source source bitmapdata
		 * @return grayscale bitmdapdata
		 */			
		public static function getGrayscale(source:BitmapData):BitmapData
		{
			var result:BitmapData = new BitmapData(source.width, source.height, true, 0x00ffffff);			
			
			var rect:Rectangle = new Rectangle(0, 0, source.width, source.height);
			
			var pixels:Vector.<uint> = source.getVector(rect);
			for (var i:uint = 0; i < pixels.length; i++) {				
				var pixel:uint = pixels[i];
				var a:uint = BitmapDataHelper.getAlphaChannelFrom(pixel);
				var r:uint = BitmapDataHelper.getRedChannelFrom(pixel);
				var g:uint = BitmapDataHelper.getGreenChannelFrom(pixel);
				var b:uint = BitmapDataHelper.getBlueChannelFrom(pixel);
				var l:uint = r * 0.21 + g * 0.71 + b * 0.07;
				
				pixels[i] = BitmapDataHelper.getARGBPixel(a, l, l, l);				
			}		
			
			result.setVector(rect, pixels);
			
			pixels = null;
			rect = null;						
			
			return result;
		}		
				
		/**
		 * Get the histogram
		 * @param source source bitmapdata
		 * @return vector of uint
		 */					
		public static function getHistogram(source:BitmapData):Vector.<uint>
		{
			var histrogram:Vector.<uint> = new Vector.<uint>(256);

			var rect:Rectangle = new Rectangle(0, 0, source.width, source.height);
			var pixels:Vector.<uint> = source.getVector(rect);
			for (var i:uint = 0; i < pixels.length; i++) {	
				histrogram[BitmapDataHelper.getRedChannelFrom(pixels[i])]++;	
			}
			
			pixels = null;
			rect = null;			
		
			return histrogram;
		}	
		
		/**
		 * Get the Otsu theshold
		 * @param source source bitmapdata
		 * @return threshold
		 */		
		public static function getOtsuTheshold(source:BitmapData):uint
		{			
			var histogram:Vector.<uint> = getHistogram(source);
			var pixelNum:uint = source.width * source.height;
			
			var sum:Number = 0;
			
			var i:int = 0;
			for (i = 0; i < histogram.length; i++) { sum += i * histogram[i]; }
	
			var sumB:Number = 0;
			var wB:Number = 0;
			var wF:Number = 0;
			
			var varMax:Number = 0;
			var threshold:uint = 0;
			
			for (i = 0; i < histogram.length; i++) {			
				wB += histogram[i];			
				if (wB == 0) { continue; }
				
				wF = pixelNum - wB; 
				if(wF == 0) { break; }
	 
				sumB += i * histogram[i];
				
				var mB:Number = sumB / wB;
				var mF:Number = (sum - sumB) / wF;
	 
				var varBetween:Number = wB * wF * (mB - mF) * (mB - mF);			
	 
				if (varBetween > varMax) {				
					varMax = varBetween;
					threshold = i;
				}
			}
 
			return threshold;				
		}
		
		/**
		 * Binarize bitmapdata
		 * @param source source bitmapdata
		 * @return binarized bitmapdata
		 */			
		public static function binarize(source:BitmapData):BitmapData
		{
			var result:BitmapData = getGrayscale(source);
			var threshold:uint = getOtsuTheshold(result);
			
			var rect:Rectangle = new Rectangle(0, 0, result.width, result.height);
			var pixels:Vector.<uint> = result.getVector(rect);
			
			for (var i:int = 0; i < pixels.length; i++) {
				var pixel:uint = pixels[i];
				var pixelThreshold:uint = BitmapDataHelper.getRedChannelFrom(pixel) + BitmapDataHelper.getGreenChannelFrom(pixel) + BitmapDataHelper.getBlueChannelFrom(pixel);
				pixelThreshold > threshold ? pixels[i] = BitmapDataHelper.getARGBPixel(0xff, 0, 0, 0) : pixels[i] = BitmapDataHelper.getARGBPixel(0xff, 0xff, 0xff, 0xff);				
			}
			
			result.setVector(rect, pixels);
			
			rect = null;
			pixels = null;
			
			return result;
		}
		
		/**
		 * Binarize bitmapdata taking into account the alpha ratio
		 * @param source source bitmapdata
		 * @return binarized bitmapda
		 */			
		public static function binarizeWithAlphaRatio(source:BitmapData):BitmapData
		{
			var result:BitmapData = getGrayscale(source);
			var threshold:uint = getOtsuTheshold(result);
			
			var rect:Rectangle = new Rectangle(0, 0, result.width, result.height);
			var pixels:Vector.<uint> = result.getVector(rect);
			
			for (var i:int = 0; i < pixels.length; i++) {				
				var pixel:uint = pixels[i];
				var pixelThreshold:uint = BitmapDataHelper.getRedChannelFrom(pixel) + BitmapDataHelper.getGreenChannelFrom(pixel) + BitmapDataHelper.getBlueChannelFrom(pixel);				
				pixels[i] = BitmapDataHelper.getARGBPixel(BitmapDataHelper.getRedChannelFrom(pixel) / threshold * 0xff, 0, 0, 0);
			}
			
			result.setVector(rect, pixels);
			
			rect = null;
			pixels = null;
			
			return result;
		}	
	}
}