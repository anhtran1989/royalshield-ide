package royalshield.components
{
    import mx.containers.ViewStack;
    import mx.events.IndexChangedEvent;
    
    import spark.components.SkinnableContainer;
    
    import royalshield.edition.EditorManager;
    import royalshield.edition.IEditorManager;
    import royalshield.edition.IMapEditor;
    import royalshield.events.EditorManagerEvent;
    import royalshield.events.TabBarEvent;
    
    public class EditorPanel extends SkinnableContainer
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        [SkinPart(required="true", type="royalshield.components.TabBarPlus")]
        public var tabBar:TabBarPlus;
        
        [SkinPart(required="true", type="mx.containers.ViewStack")]
        public var viewStack:ViewStack;
        
        private var m_editorManager:IEditorManager;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function EditorPanel()
        {
            super();
            
            m_editorManager = EditorManager.getInstance();
            m_editorManager.addEventListener(EditorManagerEvent.EDITOR_CREATING, editorManagerCreatingHandler);
            m_editorManager.addEventListener(EditorManagerEvent.EDITOR_CHANGED, editorManagerChangedHandler);
            m_editorManager.addEventListener(EditorManagerEvent.EDITOR_REMOVED, editorManagerRemovedHandler);
            
            this.focusEnabled = false;
        }
        
        //--------------------------------------
        // Override Protected
        //--------------------------------------
        
        override protected function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName, instance);
            
            if (instance == tabBar)
                tabBar.addEventListener(TabBarEvent.TAB_CLOSE, tabBarCloseHandler);
            else if (instance == viewStack)
                viewStack.addEventListener(IndexChangedEvent.CHANGE, indexChangeHandler);
        }
        
        //--------------------------------------
        // Event Handlers
        //--------------------------------------
        
        protected function editorManagerCreatingHandler(event:EditorManagerEvent):void
        {
            var editor:IMapEditor = event.editor;
            viewStack.addItem(editor);
            viewStack.selectedIndex = viewStack.getItemIndex(editor);
            
            focusManager.setFocus(editor);
        }
        
        protected function editorManagerChangedHandler(event:EditorManagerEvent):void
        {
            var editor:IMapEditor = event.editor;
            viewStack.selectedIndex = viewStack.getItemIndex(editor);
            
            focusManager.setFocus(editor);
        }
        
        protected function editorManagerRemovedHandler(event:EditorManagerEvent):void
        {
            var index:int = viewStack.getItemIndex(event.editor);
            viewStack.removeItemAt(index);
            index--;
            if (index >= 0 && viewStack.length != 0)
                m_editorManager.currentEditor = viewStack.getItemAt(index) as IMapEditor;
        }
        
        protected function tabBarCloseHandler(event:TabBarEvent):void
        {
            m_editorManager.removeEditor(IMapEditor(viewStack.getElementAt(event.tabIndex)));
        }
        
        protected function indexChangeHandler(event:IndexChangedEvent):void
        {
            m_editorManager.currentEditor = IMapEditor(viewStack.getItemAt(event.newIndex));
        }
    }
}
