package royalshield.brushes
{
    import mx.managers.ICursorManager;
    
    import royalshield.assets.AssetsManager;
    import royalshield.drawing.IDrawingTarget;
    import royalshield.entities.items.Item;
    import royalshield.world.Tile;
    
    public class Brush implements IBrush
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_target:IDrawingTarget;
        private var m_lastTile:Tile;
        private var m_type:String;
        private var m_itemId:uint;
        private var m_size:uint;
        private var m_zoom:Number;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get type():String { return m_type; }
        
        public function get itemId():uint { return m_itemId; }
        public function set itemId(value:uint):void { m_itemId = value; }
        
        public function get size():uint { return 0; }
        public function set size(value:uint):void { }
        
        public function get zoom():Number { return 0; }
        public function set zoom(value:Number):void { }
        
        public function get brushManager():IBrushManager { return null; }
        public function set brushManager(value:IBrushManager):void { }
        
        public function get cursorManager():ICursorManager { return null; }
        public function set cursorManager(value:ICursorManager):void { }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Brush()
        {
            m_size = 1;
            m_zoom = 1.0;
            m_type = BrushType.BRUSH;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function doPress(target:IDrawingTarget, x:uint, y:uint):void
        {
            //if (m_itemId == 0) return;
            
            m_target = target;
            doDrag(x, y);
        }
        
        public function doMove(x:uint, y:uint):void
        {
            //
        }
        
        public function doDrag(x:uint, y:uint):void
        {
            if (m_itemId == 0)
                return;
            
            var item:Item = AssetsManager.getInstance().getItem(m_itemId);
            if (!item)
                return;
            
            var tile:Tile = m_target.worldMap.setTile(m_target.mouseMapX, m_target.mouseMapY, m_target.mouseMapZ);
            if (!tile || tile == m_lastTile)
                return;
            
            m_lastTile = tile;
            m_lastTile.addItem(item);
        }
        
        public function doRelease(x:uint, y:uint):void
        {
            m_lastTile = null;
        }
        
        public function forceCommit():void
        {
            //
        }
        
        public function showCursor():void
        {
            //
        }
        
        public function hideCursor():void
        {
            //
        }
    }
}
