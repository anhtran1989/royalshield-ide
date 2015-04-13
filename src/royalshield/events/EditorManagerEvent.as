package royalshield.events
{
    import flash.events.Event;
    
    import royalshield.edition.IMapEditor;
    
    public class EditorManagerEvent extends Event
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var editor:IMapEditor;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function EditorManagerEvent(type:String, editor:IMapEditor, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this.editor = editor;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public Protected
        //--------------------------------------
        
        override public function clone():Event
        {
            return new EditorManagerEvent(this.type, this.editor, this.bubbles, this.cancelable);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static public const EDITOR_CREATING:String = "editorCreating";
        static public const EDITOR_CREATED:String = "editorCreated";
        static public const EDITOR_CHANGED:String = "editorChanged";
        static public const EDITOR_REMOVED:String = "editorRemoved";
        static public const MAP_CHANGED:String = "mapChanged";
        static public const ZOOM_CHANGED:String = "zoomChanged";
    }
}
