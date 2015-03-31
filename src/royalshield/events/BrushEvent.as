package royalshield.events
{
    import flash.events.Event;
    
    public class BrushEvent extends Event
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var brushType:String;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function BrushEvent(type:String, brushType:String)
        {
            super(type);
            
            this.brushType = brushType;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public Protected
        //--------------------------------------
        
        override public function clone():Event
        {
            return new BrushEvent(this.type, this.brushType);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static const BRUSH_CHANGE:String = "brushChange";
    }
}
