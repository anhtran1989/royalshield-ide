package royalshield.events
{
    import flash.events.Event;
    
    public class MapPositionEvent extends Event
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var x:uint = 0;
        public var y:uint = 0;
        public var z:uint = 0;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function MapPositionEvent(type:String, x:uint, y:uint, z:uint, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this.x = x;
            this.y = y;
            this.z = z;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public Protected
        //--------------------------------------
        
        override public function clone():Event
        {
            return new MapPositionEvent(this.type, this.x, this.y, this.z, this.bubbles, this.cancelable);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static const MOUSE_POSITION:String = "mousePosition";
    }
}
