package royalshield.components
{
    import flash.events.MouseEvent;
    
    import mx.collections.ArrayCollection;
    import mx.events.CollectionEvent;
    
    import spark.components.SkinnableContainer;
    import spark.events.IndexChangeEvent;
    
    import royalshield.events.HistoryEvent;
    import royalshield.events.UndoRedoEvent;
    import royalshield.history.HistoryActionCollection;
    import royalshield.history.IHistoryManager;
    
    [Event(name="undo", type="royalshield.events.UndoRedoEvent")]
    [Event(name="redo", type="royalshield.events.UndoRedoEvent")]
    
    public class HistoryControl extends SkinnableContainer
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        [SkinPart(required="true", type="royalshield.components.DropDownButton")]
        public var undoButton:DropDownButton;
        
        [SkinPart(required="true", type="royalshield.components.DropDownButton")]
        public var redoButton:DropDownButton;
        
        private var m_historyManager:IHistoryManager;
        private var m_historyManagerChanged:Boolean;
        private var m_undoCollection:ArrayCollection;
        private var m_redoCollection:ArrayCollection;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get historyManager():IHistoryManager { return m_historyManager; }
        public function set historyManager(value:IHistoryManager):void
        { 
           if (m_historyManager != value) {
               if (m_historyManager) {
                   m_historyManager.removeEventListener(HistoryEvent.LIST_CHANGE, historyManagerChangeHandler);
                   m_historyManager.removeEventListener(HistoryEvent.DISPOSE, historyManagerDisposeHandler);
                   m_historyManager = null;
               }
               m_historyManager = value;
               m_historyManagerChanged = true;
               invalidateProperties();
           }
        }
        
        public function get undoSource():Array { return m_undoCollection.source; }
        public function set undoSource(value:Array):void { m_undoCollection.source = value; }
        
        public function get redoSource():Array { return m_redoCollection.source; }
        public function set redoSource(value:Array):void { m_redoCollection.source = value; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function HistoryControl()
        {
            m_undoCollection = new ArrayCollection();
            m_undoCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE, undoCollectionChangeaHandler);
            m_redoCollection = new ArrayCollection();
            m_redoCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE, redoCollectionChangeaHandler);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Override Protected
        //--------------------------------------
        
        override protected function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName, instance);
            
            if (instance == undoButton) {
                undoButton.dataProvider = m_undoCollection;
                undoButton.enabled = (m_undoCollection.length != 0);
                undoButton.addEventListener(MouseEvent.CLICK, undoButtonClickHandler);
                undoButton.addEventListener(IndexChangeEvent.CHANGE, undoListChangeHandler);
            } else if (instance == redoButton) {
                redoButton.dataProvider = m_redoCollection;
                redoButton.enabled = (m_redoCollection.length != 0);
                redoButton.addEventListener(MouseEvent.CLICK, redoButtonClickHandler);
                redoButton.addEventListener(IndexChangeEvent.CHANGE, redoListChangeHandler);
            }
        }
        
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            if (m_historyManagerChanged) {
                setHistoryManager(m_historyManager);
                m_historyManagerChanged = false;
            }
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function setHistoryManager(historyManager:IHistoryManager):void
        {
            if (historyManager) {
                historyManager.addEventListener(HistoryEvent.LIST_CHANGE, historyManagerChangeHandler);
                historyManager.addEventListener(HistoryEvent.DISPOSE, historyManagerDisposeHandler);
                updateHistoryLists();
            } else {
                m_redoCollection.removeAll();
                m_undoCollection.removeAll();
            }
        }
        
        protected function updateHistoryLists():void
        {
            if (!m_historyManager)
                return;
            
            var collection:HistoryActionCollection = m_historyManager.collection;
            var undo:Array = [];
            var redo:Array = [];
            var i:int;
            
            for (i = collection.index; i > 0; i--)
                undo.push(collection.getGroup(i).toString());
            
            for (i = collection.length - 1; i > collection.index; i--)
                redo.unshift(collection.getGroup(i).toString());
            
            m_undoCollection.source = undo;
            m_redoCollection.source = redo;
        }
        
        //--------------------------------------
        // Event Handlers
        //--------------------------------------
        
        protected function historyManagerChangeHandler(event:HistoryEvent):void
        {
            updateHistoryLists();
        }
        
        protected function historyManagerDisposeHandler(event:HistoryEvent):void
        {
            this.historyManager = null;
        }
        
        protected function undoButtonClickHandler(event:MouseEvent):void
        {
            if (event.target === undoButton.button) {
                dispatchEvent(new UndoRedoEvent(UndoRedoEvent.UNDO));
                
                if (m_historyManager)
                    m_historyManager.undo();
            }
        }
        
        protected function undoListChangeHandler(event:IndexChangeEvent):void
        {
            var indices:uint = event.newIndex + 1;
            
            undoButton.closeDropDown();
            dispatchEvent(new UndoRedoEvent(UndoRedoEvent.UNDO, indices));
            
            if (m_historyManager)
                m_historyManager.undo(indices);
        }
        
        protected function redoButtonClickHandler(event:MouseEvent):void
        {
            if (event.target === redoButton.button) {
                dispatchEvent(new UndoRedoEvent(UndoRedoEvent.REDO));
                
                if (m_historyManager)
                    m_historyManager.redo();
            }
        }
        
        protected function redoListChangeHandler(event:IndexChangeEvent):void
        {
            var indices:uint = event.newIndex + 1;
            
            redoButton.closeDropDown();
            dispatchEvent(new UndoRedoEvent(UndoRedoEvent.REDO, indices));
            
            if (m_historyManager)
                m_historyManager.redo(indices);
        }
        
        protected function undoCollectionChangeaHandler(event:CollectionEvent):void
        {
            if (undoButton)
                undoButton.enabled = (m_undoCollection.length != 0);
        }
        
        protected function redoCollectionChangeaHandler(event:CollectionEvent):void
        {
            if (redoButton)
                redoButton.enabled = (m_redoCollection.length != 0);
        }
    }
}
