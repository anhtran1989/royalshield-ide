package royalshield.drawing
{
    import flash.events.EventDispatcher;
    import flash.events.MouseEvent;
    
    import royalshield.brushes.BrushManager;
    import royalshield.brushes.IBrushManager;
    import royalshield.drawing.IDrawingManager;
    import royalshield.drawing.IDrawingTarget;
    import royalshield.edition.EditorManager;
    import royalshield.edition.IEditorManager;
    import royalshield.errors.NullArgumentError;
    import royalshield.errors.SingletonClassError;
    import royalshield.events.DrawingEvent;
    import royalshield.events.EditorManagerEvent;
    
    public final class DrawingManager extends EventDispatcher implements IDrawingManager
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_currentTarget:IDrawingTarget;
        private var m_brushManager:IBrushManager;
        private var m_editorManager:IEditorManager;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get currentTarget():IDrawingTarget { return m_currentTarget; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function DrawingManager()
        {
            if (s_instance)
                throw new SingletonClassError(DrawingManager);
            
            s_instance = this;
            m_brushManager = BrushManager.getInstance();
            m_editorManager = EditorManager.getInstance();
            m_editorManager.addEventListener(EditorManagerEvent.EDITOR_CREATED, editorManagerCreatedHandler);
            m_editorManager.addEventListener(EditorManagerEvent.EDITOR_CHANGED, editorManagerChangedHandler);
            m_editorManager.addEventListener(EditorManagerEvent.EDITOR_REMOVED, editorManagerRemovedHandler);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function addTarget(target:IDrawingTarget):void
        {
            if (!target)
                throw new NullArgumentError("target");
            
            addListeners(target);
            setTarget(target);
        }
        
        public function removeTarget(target:IDrawingTarget):void
        {
            if (target) {
                if (m_currentTarget == target)
                    setTarget(null);
                
                removeListeners(target);
            }
        }
        
        public function setTarget(target:IDrawingTarget):void
        {
            m_currentTarget = target;
            m_brushManager.target = target;
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function addListeners(target:IDrawingTarget):void
        {
            target.addEventListener(DrawingEvent.BRUSH_PRESS, targetPressHandler);
            target.addEventListener(DrawingEvent.BRUSH_DRAG, targetDragHandler);
            target.addEventListener(DrawingEvent.BRUSH_RELEASE, targetReleaseHandler);
            target.addEventListener(DrawingEvent.SELECTION_START, targetSelectionStartHandler);
            target.addEventListener(DrawingEvent.SELECTION_END, targetSelectionEndHandler);
            target.addEventListener(DrawingEvent.ZOOM, targetZoomChangeHandler);
            target.addEventListener(MouseEvent.ROLL_OVER, targetRollOverHandler);
            target.addEventListener(MouseEvent.ROLL_OUT, targetRollOutHandler);
        }
        
        private function removeListeners(target:IDrawingTarget):void
        {
            target.removeEventListener(DrawingEvent.BRUSH_PRESS, targetPressHandler);
            target.removeEventListener(DrawingEvent.BRUSH_DRAG, targetDragHandler);
            target.removeEventListener(DrawingEvent.BRUSH_RELEASE, targetReleaseHandler);
            target.removeEventListener(DrawingEvent.SELECTION_START, targetSelectionStartHandler);
            target.removeEventListener(DrawingEvent.SELECTION_END, targetSelectionEndHandler);
            target.removeEventListener(DrawingEvent.ZOOM, targetZoomChangeHandler);
            target.removeEventListener(MouseEvent.ROLL_OVER, targetRollOverHandler);
            target.removeEventListener(MouseEvent.ROLL_OUT, targetRollOutHandler);
        }
        
        //--------------------------------------
        // Event Handlers
        //--------------------------------------
        
        private function editorManagerCreatedHandler(event:EditorManagerEvent):void
        {
            addTarget(event.editor.display);
        }
        
        private function editorManagerChangedHandler(event:EditorManagerEvent):void
        {
            setTarget(event.editor.display);
        }
        
        private function editorManagerRemovedHandler(event:EditorManagerEvent):void
        {
            removeTarget(event.editor.display);
        }
        
        private function targetPressHandler(event:DrawingEvent):void
        {
            m_brushManager.doPress(m_currentTarget.mouseDownX, m_currentTarget.mouseDownY);
        }
        
        private function targetDragHandler(event:DrawingEvent):void
        {
            m_brushManager.doDrag(m_currentTarget.mouseMapX, m_currentTarget.mouseMapY);
        }
        
        private function targetReleaseHandler(event:DrawingEvent):void
        {
            m_brushManager.doRelease(m_currentTarget.mouseMapX, m_currentTarget.mouseMapY);
        }
        
        private function targetSelectionStartHandler(event:DrawingEvent):void
        {
            m_brushManager.hideCursor();
        }
        
        private function targetSelectionEndHandler(event:DrawingEvent):void
        {
            m_brushManager.showCursor();
        }
        
        private function targetZoomChangeHandler(event:DrawingEvent):void
        {
            ////
        }
        
        private function targetRollOverHandler(event:MouseEvent):void
        {
            m_brushManager.isOver = true;
            m_brushManager.showCursor();
        }
        
        private function targetRollOutHandler(event:MouseEvent):void
        {
            m_brushManager.isOver = false;
            m_brushManager.hideCursor();
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        private static var s_instance:IDrawingManager;
        public static function getInstance():IDrawingManager
        {
            if (!s_instance)
                new DrawingManager();
            
            return s_instance;
        }
    }
}
