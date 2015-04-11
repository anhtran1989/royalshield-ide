package royalshield.components
{
    import mx.core.UIComponent;
    
    [ExcludeClass]
    public class MapDisplayMask extends UIComponent
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function MapDisplayMask()
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
            graphics.clear();
            graphics.beginFill(0);
            graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
            graphics.endFill();
        }
    }
}
