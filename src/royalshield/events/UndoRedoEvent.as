package royalshield.events
{
    import flash.events.Event;
    
    public class UndoRedoEvent extends Event
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var indices:uint;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function UndoRedoEvent(type:String, indices:uint = 1, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            
            this.indices = indices;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Override Public
        //--------------------------------------
        
        override public function clone():Event
        {
            return new UndoRedoEvent(this.type, this.indices, this.bubbles, this.cancelable);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static const UNDO:String = "undo";
        public static const REDO:String = "redo";
    }
}
