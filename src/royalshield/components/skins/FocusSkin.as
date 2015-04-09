package royalshield.components.skins
{
    import flash.filters.GlowFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import spark.skins.spark.HighlightBitmapCaptureSkin;
    
    public class FocusSkin extends HighlightBitmapCaptureSkin
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function FocusSkin()
        {
            super();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Override Protected
        //--------------------------------------
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {   
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            if (target)
                blendMode = target.getStyle("focusBlendMode");
        }
        
        override protected function processBitmap():void
        {
            RECTANGLE.setTo(0, 0, bitmap.width, bitmap.height); 
            
            if (target.errorString != null && target.errorString != "" && target.getStyle("showErrorSkin"))
                GLOW_FILTER.color = 0xFF0000;
            else
                GLOW_FILTER.color = 0x1769E7;
            
            GLOW_FILTER.blurX = 2;
            GLOW_FILTER.blurY = 2;
            GLOW_FILTER.strength = 0xFF;
            GLOW_FILTER.alpha = target.getStyle("focusAlpha") * ALPHA_MULTIPLIER;
            bitmap.bitmapData.applyFilter(bitmap.bitmapData, RECTANGLE, POINT, GLOW_FILTER);
        }
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        override protected function get borderWeight():Number
        {
            if (target)
                return target.getStyle("focusThickness");
            
            return getStyle("focusThickness");
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static private const COLOR_TRANSFORM:ColorTransform = new ColorTransform(1.01, 1.01, 1.01, 2);
        static private const GLOW_FILTER:GlowFilter = new GlowFilter(0xE98C2E, 0.85, 5, 5, 3, 1, false, true);
        static private const RECTANGLE:Rectangle = new Rectangle();
        static private const POINT:Point = new Point();
        static private const BLUR_MULTIPLIER:Number = 2.5;
        static private const ALPHA_MULTIPLIER:Number = 1.5454;
    }
}
