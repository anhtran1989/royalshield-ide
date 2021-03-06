package royalshield.brushes
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    
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
        
        private var m_target:IDrawingTarget;
        private var m_isOver:Boolean;
        private var m_brush:IBrush;
        private var m_itemId:uint;
        private var m_cursorManager:ICursorManager;
        private var m_sizes:Dictionary;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get target():IDrawingTarget { return m_target; }
        public function set target(value:IDrawingTarget):void { m_target = value; }
        
        public function get isOver():Boolean { return m_isOver; }
        public function set isOver(value:Boolean):void { m_isOver = value; }
        
        public function get brushType():String { return m_brush ? m_brush.type : null; }
        public function set brushType(value:String):void
        {
            if (isNullOrEmpty(value))
                throw new NullOrEmptyArgumentError("brushType");
                
            if (!m_brush || m_brush.type != value)
                setBrushType(value);
        }
        
        public function get brush():IBrush { return m_brush; }
        
        public function get itemId():uint { return m_itemId; }
        public function set itemId(value:uint):void
        {
            if (m_itemId != value) {
                m_itemId = value;
                if (m_brush)
                    m_brush.itemId = m_itemId;
            }
        }
        
        public function get size():uint { return m_brush ? m_brush.size : 1; }
        public function set size(value:uint):void
        {
            if (m_brush && m_brush.size != value) {
                m_brush.size = value;
                m_sizes[m_brush.type] = m_brush.size;
            }
        }
        
        public function get cursorManager():ICursorManager { return m_cursorManager; }
        public function set cursorManager(value:ICursorManager):void { m_cursorManager = value; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function BrushManager()
        {
            if (s_instance)
                throw new SingletonClassError(BrushManager);
            
            s_instance = this;
            
            m_itemId = 100; // TODO temporary
            m_sizes = new Dictionary();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function doPress(x:uint, y:uint):void
        {
            if (m_brush)
                m_brush.doPress(x, y);
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
        
        public function showCursor():void
        {
            if (m_brush && m_isOver)
                m_brush.showCursor();
        }
        
        public function hideCursor():void
        {
            if (m_brush)
                m_brush.hideCursor();
        }
        
        public function invalidateCursor():void
        {
            this.hideCursor();
            this.showCursor();
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
                m_brush.dispose();
                m_brush = null;
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
                m_brush.size = (m_sizes[type] !== undefined) ? uint(m_sizes[type]) : 1;
                m_brush.brushManager = this;
                
                this.showCursor();
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
