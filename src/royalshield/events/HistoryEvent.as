package royalshield.events
{
    import flash.events.Event;
    
    public class HistoryEvent extends Event
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function HistoryEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
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
            return new HistoryEvent(this.type, this.bubbles, this.cancelable);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static const LIST_CHANGE:String = "listChange";
        public static const COLLECTION_CHANGE:String = "collectionChange";
    }
}
