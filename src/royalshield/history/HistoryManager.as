package royalshield.history
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    
    import royalshield.errors.NullArgumentError;
    import royalshield.events.HistoryEvent;
    import royalshield.utils.IDisposable;
    
    [Event(name="listChange", type="royalshield.events.HistoryEvent")]
    
    public class HistoryManager extends EventDispatcher implements IHistoryManager, IDisposable
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_collection:HistoryActionCollection;
        private var m_maxLength:uint;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get canUndo():Boolean
        {
            if (m_collection.length > 0 && m_collection.index > 0)
                return true;
            
            return false;
        }
        
        public function get canRedo():Boolean
        {
            if (m_collection.length > 0 && m_collection.index < (m_collection.length - 1))
                return true;
            
            return false;
        }
        
        public function get collection():HistoryActionCollection { return m_collection; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function HistoryManager(maxLength:uint = 10)
        {
            m_maxLength = maxLength;
            m_collection = new HistoryActionCollection(maxLength);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function addActionGroup(actionGroup:HistoryActionGroup, ... rest):void
        {
            if (!actionGroup)
                throw new NullArgumentError("actionGroup");
            
            m_collection.addGroup(actionGroup);
            dispatchChangeEvent();
        }
        
        public function undo(indices:uint = 1):void
        {
            for (var i:uint = 0; i < indices; i++) {
                if (!internalUndo())
                    break;
            }
            undoComplete();
        }
        
        public function redo(indices:uint = 1):void
        {
            for (var i:uint = 0; i < indices; i++) {
                if (!internalRedo())
                    break;
            }
            redoComplete();
        }
        
        public function dispose():void
        {
            m_collection.dispose();
            m_collection = new HistoryActionCollection(m_maxLength);
        }
        
        //--------------------------------------
        // Protected
        //--------------------------------------
        
        protected function dispatchChangeEvent(event:Event = null):void
        {
            dispatchEvent(new HistoryEvent(HistoryEvent.LIST_CHANGE));
        }
        
        protected function onUndo(action:IHistoryAction):void
        {
            throw new Error("Method not implemented.");
        }
        
        protected function onRedo(action:IHistoryAction):void
        {
            throw new Error("Method not implemented.");
        }
        
        protected function undoComplete():void
        {
            //
        }
        
        protected function redoComplete():void
        {
            //
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function internalUndo():Boolean
        {
            if (!this.canUndo)
                return false;
            
            var actionGroup:HistoryActionGroup = m_collection.getCurrentAction();
            
            var length:uint = actionGroup.length;
            for (var i:uint = 0; i < length; i++)
                onUndo( actionGroup.getActionAt(i) );
            
            m_collection.index = (m_collection.index - 1);
            
            dispatchChangeEvent();
            return true;
        }
        
        private function internalRedo():Boolean
        {
            if (!this.canRedo)
                return false;
            
            m_collection.index = (m_collection.index + 1);
            
            var actionGroup:HistoryActionGroup = m_collection.getCurrentAction();
            
            var length:uint = actionGroup.length;
            for (var i:uint = 0; i < length; i++)
                onRedo( actionGroup.getActionAt(i) );
            
            dispatchChangeEvent();
            return true;
        }
    }
}
