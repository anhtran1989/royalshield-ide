package royalshield.brushes
{
    import flash.events.EventDispatcher;
    
    import mx.managers.ICursorManager;
    
    import royalshield.drawing.IDrawingTarget;
    import royalshield.errors.NullOrEmptyArgumentError;
    import royalshield.errors.SingletonClassError;
    import royalshield.events.BrushEvent;
    import royalshield.utils.isNullOrEmpty;
    
    [Event(name="brushChange", type="royalshield.events.BrushEvent")]
    
    public class BrushManager extends EventDispatcher implements IBrushManager
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_brushType:String;
        private var m_brush:IBrush;
        private var m_itemId:uint;
        private var m_zoom:Number;
        private var m_cursorManager:ICursorManager;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get brushType():String { return m_brushType; }
        public function set brushType(value:String):void
        {
            if (isNullOrEmpty(value))
                throw new NullOrEmptyArgumentError("brushType");
                
            if (m_brushType != value)
                setBrushType(value);
        }
        
        public function get itemId():uint { return m_itemId; }
        public function set itemId(value:uint):void
        {
            if (m_itemId != value) {
                m_itemId = value;
                if (m_brush)
                    m_brush.itemId = m_itemId;
            }
        }
        
        public function get cursorManager():ICursorManager { return m_cursorManager; }
        public function set cursorManager(value:ICursorManager):void
        { 
            if (m_cursorManager != value) {
                m_cursorManager = value;
                if (m_brush)
                    m_brush.cursorManager = value;
            }
        }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function BrushManager()
        {
            if (s_instance)
                throw new SingletonClassError(BrushManager);
            
            s_instance = this;
            
            m_itemId = 100; // TODO temporary
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function doPress(target:IDrawingTarget, x:uint, y:uint):void
        {
            if (target && m_brush)
                m_brush.doPress(target, x, y);
        }
        
        public function doMove(x:uint, y:uint):void
        {
            if (m_brush)
                m_brush.doMove(x, y);
        }
        
        public function doDrag(x:uint, y:uint):void
        {
            if (m_brush)
                m_brush.doDrag(x, y);
        }
        
        public function doRelease(x:uint, y:uint):void
        {
            if (m_brush)
                m_brush.doRelease(x, y);
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function setBrushType(type:String):void
        {
            if (m_brush) {
                if (m_brush.type == type)
                    return;
                
                m_brush.hideCursor();
                m_brush.brushManager = null;
                m_brush.cursorManager = null;
            }
            
            switch (type)
            {
                case BrushType.BRUSH:
                    m_brush = new Brush();
                    break;
                
                case BrushType.ERASER:
                    m_brush = new Eraser();
                    break;
            }
            
            if (m_brush) {
                m_brush.itemId = m_itemId;
                m_brush.zoom = m_zoom;
                m_brush.brushManager = this;
                m_brush.cursorManager = m_cursorManager;
            }
            
            dispatchEvent(new BrushEvent(BrushEvent.BRUSH_CHANGE, this.brushType));
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        private static var s_instance:IBrushManager;
        public static function getInstance():IBrushManager
        {
            if (!s_instance)
                new BrushManager();
            
            return s_instance;
        }
    }
}
