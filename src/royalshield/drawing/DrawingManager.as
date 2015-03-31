package royalshield.drawing
{
    import flash.events.EventDispatcher;
    
    import royalshield.brushes.BrushManager;
    import royalshield.brushes.IBrushManager;
    import royalshield.drawing.IDrawingManager;
    import royalshield.drawing.IDrawingTarget;
    import royalshield.errors.NullArgumentError;
    import royalshield.errors.SingletonClassError;
    import royalshield.events.DrawingEvent;
    
    public final class DrawingManager extends EventDispatcher implements IDrawingManager
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_currentTarget:IDrawingTarget;
        private var m_brushManager:IBrushManager;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function DrawingManager()
        {
            if (s_instance)
                throw new SingletonClassError(DrawingManager);
            
            s_instance = this;
            m_brushManager = BrushManager.getInstance();
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
            
            m_currentTarget = target;
            addListeners(target);
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function addListeners(target:IDrawingTarget):void
        {
            target.addEventListener(DrawingEvent.BRUSH_PRESS, targetPressHandler);
            target.addEventListener(DrawingEvent.BRUSH_MOVE, targetMoveHandler);
            target.addEventListener(DrawingEvent.BRUSH_DRAG, targetDragHandler);
            target.addEventListener(DrawingEvent.BRUSH_RELEASE, targetReleaseHandler);
            target.addEventListener(DrawingEvent.ZOOM, targetZoomChangeHandler);
        }
        
        private function removeListeners(target:IDrawingTarget):void
        {
            target.removeEventListener(DrawingEvent.BRUSH_PRESS, targetPressHandler);
            target.removeEventListener(DrawingEvent.BRUSH_MOVE, targetMoveHandler);
            target.removeEventListener(DrawingEvent.BRUSH_DRAG, targetDragHandler);
            target.removeEventListener(DrawingEvent.BRUSH_RELEASE, targetReleaseHandler);
            target.removeEventListener(DrawingEvent.ZOOM, targetZoomChangeHandler);
        }
        
        //--------------------------------------
        // Event Handlers
        //--------------------------------------
        
        private function targetPressHandler(event:DrawingEvent):void
        {
            m_brushManager.doPress(m_currentTarget, m_currentTarget.mouseDownX, m_currentTarget.mouseDownY);
        }
        
        private function targetMoveHandler(event:DrawingEvent):void
        {
            m_brushManager.doMove(m_currentTarget.mouseMapX, m_currentTarget.mouseMapY);
        }
        
        private function targetDragHandler(event:DrawingEvent):void
        {
            m_brushManager.doDrag(m_currentTarget.mouseMapX, m_currentTarget.mouseMapY);
        }
        
        private function targetReleaseHandler(event:DrawingEvent):void
        {
            m_brushManager.doRelease(m_currentTarget.mouseMapX, m_currentTarget.mouseMapY);
        }
        
        private function targetZoomChangeHandler(event:DrawingEvent):void
        {
            //dispatchEvent(new DrawingManagerEvent(DrawingManagerEvent.TARGET_ZOOM_CHANGE));
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
