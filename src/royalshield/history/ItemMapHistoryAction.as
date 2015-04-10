package royalshield.history
{
    import royalshield.entities.items.Item;
    import royalshield.geom.Position;
    import royalshield.history.IHistoryAction;
    
    public class ItemMapHistoryAction implements IHistoryAction
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_oldPosition:Position;
        private var m_newPosition:Position;
        private var m_item:Item;
        private var m_oldIndex:int;
        private var m_newIndex:int;
        private var m_count:uint;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get oldPosition():Position { return m_oldPosition; }
        public function get newPosition():Position { return m_newPosition; }
        public function get item():Item { return m_item; }
        public function get oldIndex():int { return m_oldIndex; }
        public function get newIndex():int { return m_newIndex; }
        public function get count():uint { return m_count; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function ItemMapHistoryAction(oldPosition:Position, newPosition:Position, item:Item, oldIndex:int, newIndex:int, count:uint = 1)
        {
            m_oldPosition = oldPosition;
            m_newPosition = newPosition;
            m_item = item;
            m_oldIndex = oldIndex;
            m_newIndex = newIndex;
            m_count = count;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function dispose():void
        {
            m_oldPosition = null;
            m_newPosition = null;
            m_item = null;
        }
    }
}
