package royalshield.edition
{
    import flash.events.EventDispatcher;
    
    import mx.core.FlexGlobals;
    import mx.core.UIComponent;
    import mx.events.CloseEvent;
    import mx.events.FlexEvent;
    
    import royalshield.components.Alert;
    import royalshield.components.MapEditor;
    import royalshield.core.IRoyalShieldIDE;
    import royalshield.errors.NullArgumentError;
    import royalshield.errors.NullOrEmptyArgumentError;
    import royalshield.errors.SingletonClassError;
    import royalshield.events.EditorManagerEvent;
    import royalshield.events.MapPositionEvent;
    import royalshield.history.IHistoryManager;
    import royalshield.utils.StringUtil;
    import royalshield.utils.isNullOrEmpty;
    import royalshield.world.IWorldMap;
    import royalshield.world.WorldMap;
    
    [Event(name="editorCreating", type="royalshield.events.EditorManagerEvent")]
    [Event(name="editorCreated", type="royalshield.events.EditorManagerEvent")]
    [Event(name="editorChanged", type="royalshield.events.EditorManagerEvent")]
    [Event(name="editorClosed", type="royalshield.events.EditorManagerEvent")]
    [Event(name="mousePosition", type="royalshield.events.MapPositionEvent")]
    
    public class EditorManager extends EventDispatcher implements IEditorManager
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_application:IRoyalShieldIDE;
        private var m_editors:Vector.<IMapEditor>;
        private var m_currentEditor:IMapEditor;
        private var m_currentEditorChanged:IMapEditor;
        private var m_currentMap:IWorldMap;
        private var m_currentHistoryManager:IHistoryManager;
        private var m_showGrid:Boolean;
        private var m_showMouseTile:Boolean;
        private var m_closingAll:Boolean;
        private var m_waiting:Boolean;
        private var m_untitledCount:uint;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get currentEditor():IMapEditor { return m_currentEditor; }
        public function set currentEditor(value:IMapEditor):void
        {
            if (m_currentEditor != value)
                setEditor(value);
        }
        
        public function get currentMap():IWorldMap { return m_currentMap; }
        
        public function get currentHistoryManager():IHistoryManager { return m_currentHistoryManager; }
        
        public function get canUndo():Boolean { return m_currentHistoryManager ? m_currentHistoryManager.canUndo : false; }
        public function get canRedo():Boolean { return m_currentHistoryManager ? m_currentHistoryManager.canRedo : false; }
        
        public function get showGrid():Boolean { return m_showGrid; }
        public function set showGrid(value:Boolean):void
        {
            if (m_showGrid != value) {
                m_showGrid = value;
                
                if (m_currentEditor && m_currentEditor.display)
                    m_currentEditor.display.showGrid = m_showGrid;
            }
        }
        
        public function get showMouseTile():Boolean { return m_showMouseTile; }
        public function set showMouseTile(value:Boolean):void
        {
            if (m_showMouseTile != value) {
                m_showMouseTile = value;
                
                if (m_currentEditor && m_currentEditor.display)
                    m_currentEditor.display.showMouseTile = m_showMouseTile;
            }
        }
        
        public function get editorCount():uint { return m_editors.length; }
        
        public function get waiting():Boolean { return m_waiting; }
        
        public function get changed():Boolean
        {
            for (var i:uint = 0; i < m_editors.length; i++) {
                if (m_editors[i].changed)
                    return true;
            }
            return false;
        }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function EditorManager()
        {
            if (s_instance)
                throw new SingletonClassError(EditorManager);
            
            s_instance = this;
            
            m_application = IRoyalShieldIDE(FlexGlobals.topLevelApplication);
            m_editors = new Vector.<IMapEditor>();
            m_untitledCount = 1;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function createMap(name:String, width:uint, height:uint, layers:uint):IMapEditor
        {
            if (isNullOrEmpty(name))
                throw new NullOrEmptyArgumentError("name");
            
            if (width == 0 || height == 0 || layers == 0)
                throw new ArgumentError("Invalid map size.");
            
            return createEditor(new WorldMap(name, width, height, layers));
        }
        
        public function createEditor(map:IWorldMap):IMapEditor
        {
            if (!map)
                throw new NullArgumentError("map");
            
            var editor:IMapEditor = getEditor(map);
            if (!editor) {
                editor = new MapEditor();
                editor.map = map;
                editor.addEventListener(FlexEvent.CREATION_COMPLETE, editorCreationCompleteHandler);
                editor.addEventListener(MapPositionEvent.MOUSE_POSITION, mousePositionHandler);
                
                m_editors[m_editors.length] = editor;
                
                dispatchEvent(new EditorManagerEvent(EditorManagerEvent.EDITOR_CREATING, editor));
            }
            return editor;
        }
        
        public function removeEditor(editor:IMapEditor):void
        {
            var index:int = m_editors.indexOf(editor);
            if (index == -1) return;
            
            if (editor.changed) {
                
                m_waiting = true;
                
                var text:String = "Do you want to save changes to '{0}' before closing?";
                Alert.show(StringUtil.format(text, editor.map.name),
                           "Save",
                           Alert.YES | Alert.NO | Alert.CANCEL,
                           UIComponent(m_application),
                           closeHandler,
                           null,
                           Alert.CANCEL);
                
            } else
                onRemoveEditor(editor);
            
            function closeHandler(event:CloseEvent):void
            {
                m_waiting = false;
                
                if (event.detail == Alert.YES) {
                    saveEditor(editor);
                    onRemoveEditor(editor);
                }
                else if (event.detail == Alert.NO)
                    onRemoveEditor(editor);
                else if (event.detail == Alert.CANCEL) {
                    m_closingAll = false;
                    m_application.cancelClosing();
                }
            }
        }
        
        public function removeCurrentEditor():void
        {
            if (m_currentEditor)
                removeEditor(m_currentEditor);
            else
                m_closingAll = false;
        }
        
        public function removeAll(checkSave:Boolean = true):void
        {
            if (this.editorCount == 0) return;
            
            if (checkSave) {
                m_closingAll = true;
                removeCurrentEditor();
            } else {
                m_editors = new Vector.<IMapEditor>();
                m_currentEditor = null;
                m_currentHistoryManager = null;
                m_currentMap = null;
                m_waiting = false;
                m_closingAll = false;
            }
        }
        
        public function getEditor(map:IWorldMap):IMapEditor
        {
            for (var i:int = 0; i < m_editors.length; i++) {
                if (m_editors[i].map == map)
                    return m_editors[i];
            }
            return null;
        }
        
        public function saveEditor(editor:IMapEditor):void
        {
            if (!editor)
                throw new NullArgumentError("editor");
            
            //
        }
        
        public function undo():void
        {
            if (m_currentHistoryManager)
                m_currentHistoryManager.undo();
        }
        
        public function redo():void
        {
            if (m_currentHistoryManager)
                m_currentHistoryManager.redo();
        }
        
        public function createUntitledName():String
        {
            var count:uint = m_untitledCount;
            var name:String = "Untitled - " + count;
            
            for (var i:uint = 0; i < m_editors.length; i++) {
                if (m_editors[i].map.name == name) {
                    count++;
                    name = "Untitled - " + count;
                    i = 0;
                }
            }
            
            m_untitledCount = count;
            return name;
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function setEditor(editor:IMapEditor):void
        {
            m_currentEditor = null;
            m_currentMap = null;
            m_currentHistoryManager = null;
            
            var index:int = m_editors.indexOf(editor);
            if (index != -1) {
                m_currentEditor = editor;
                m_currentMap = editor.map;
                m_currentHistoryManager = editor.historyManager;
                editor.display.showGrid = this.showGrid;
                editor.display.showMouseTile = this.showMouseTile;
                editor.display.draw();
                dispatchEvent(new EditorManagerEvent(EditorManagerEvent.EDITOR_CHANGED, editor));
            }
        }
        
        private function onRemoveEditor(editor:IMapEditor):void
        {
            var index:int = m_editors.indexOf(editor);
            if (index != -1) {
                m_editors.splice(index, 1);
                
                editor.removeEventListener(FlexEvent.CREATION_COMPLETE, editorCreationCompleteHandler);
                editor.removeEventListener(MapPositionEvent.MOUSE_POSITION, mousePositionHandler);
                editor.dispose();
                
                if (m_currentEditor == editor)
                    setEditor(null);
                
                dispatchEvent(new EditorManagerEvent(EditorManagerEvent.EDITOR_REMOVED, editor));
            }
            
            if (m_closingAll)
                removeCurrentEditor();
        }
        
        //--------------------------------------
        // Event Handlers
        //--------------------------------------
        
        protected function editorCreationCompleteHandler(event:FlexEvent):void
        {
            var editor:IMapEditor = IMapEditor(event.target);
            this.currentEditor = editor;
            dispatchEvent(new EditorManagerEvent(EditorManagerEvent.EDITOR_CREATED, editor));
        }
        
        protected function mousePositionHandler(event:MapPositionEvent):void
        {
            dispatchEvent(event);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static private var s_instance:IEditorManager;
        static public function getInstance():IEditorManager
        {
            if (!s_instance)
                new EditorManager();
            
            return s_instance;
        }
    }
}
