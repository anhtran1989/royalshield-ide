package royalshield.events
{
    import flash.events.Event;
    
    public class DrawingEvent extends Event
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function DrawingEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Override Public
        //--------------------------------------
        
        override public function clone():Event
        {
            return new DrawingEvent(this.type, this.bubbles, this.cancelable);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static const BRUSH_PRESS:String = "brushPress";
        public static const BRUSH_MOVE:String = "brushMove";
        public static const BRUSH_DRAG:String = "brushDrag";
        public static const BRUSH_RELEASE:String = "brushRelease";
        public static const SELECTION_START:String = "selectionStart";
        public static const SELECTION_END:String = "selectionEnd";
        public static const ZOOM:String = "zoom";
    }
}
