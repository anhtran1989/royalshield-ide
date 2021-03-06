package royalshield.events
{
    import flash.events.Event;
    
    public class MenuEvent extends Event
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var data:String;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function MenuEvent(type:String, data:String)
        {
            super(type);
            
            this.data = data;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public Protected
        //--------------------------------------
        
        override public function clone():Event
        {
            return new MenuEvent(this.type, this.data);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static const SELECTED:String = "selected";
    }
}
