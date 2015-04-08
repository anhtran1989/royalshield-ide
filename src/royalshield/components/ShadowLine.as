package royalshield.components
{
    import mx.core.UIComponent;
    
    [Style(name="lineColor", inherit="no", type="uint")]
    [Style(name="shadowColor", inherit="yes", type="uint")]
    
    public class ShadowLine extends UIComponent
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function ShadowLine()
        {
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Override Protected
        //--------------------------------------
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            var lineColor:Number = getStyle("lineColor");
            var shadowColor:Number = getStyle("shadowColor");
            
            if (isNaN(lineColor))
                lineColor = 0x000000;
            
            graphics.clear();
            
            if (unscaledWidth < unscaledHeight) {
                if (!isNaN(shadowColor)) {
                    graphics.beginFill(shadowColor);
                    graphics.drawRect(1, 0, Math.max(1, unscaledWidth), unscaledHeight);
                    graphics.endFill();
                }
                
                graphics.beginFill(lineColor);
                graphics.drawRect(0, 0, Math.max(1, unscaledWidth), unscaledHeight);
                graphics.endFill();
            } else {
                if (!isNaN(shadowColor)) {
                    graphics.beginFill(shadowColor);
                    graphics.drawRect(0, 1, unscaledWidth, Math.max(1, unscaledHeight));
                    graphics.endFill();
                }
                
                graphics.beginFill(lineColor);
                graphics.drawRect(0, 0, unscaledWidth, Math.max(1, unscaledHeight));
                graphics.endFill();
            }
        }
    }
}
