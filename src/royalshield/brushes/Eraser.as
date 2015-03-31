package royalshield.brushes
{
    import mx.managers.ICursorManager;
    
    import royalshield.drawing.IDrawingTarget;
    import royalshield.world.Tile;
    
    public class Eraser implements IBrush
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_target:IDrawingTarget;
        private var m_lastTile:Tile;
        private var m_type:String;
        private var m_size:uint;
        private var m_zoom:Number;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get type():String { return m_type; }
        
        public function get itemId():uint { return 0; }
        public function set itemId(value:uint):void {}
        
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
        
        public function Eraser()
        {
            m_size = 1;
            m_zoom = 1.0;
            m_type = BrushType.ERASER;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function doPress(target:IDrawingTarget, x:uint, y:uint):void
        {
            m_target = target;
            doDrag(x, y);
        }
        
        public function doMove(x:uint, y:uint):void
        {
        }
        
        public function doDrag(x:uint, y:uint):void
        {
            var tile:Tile = m_target.worldMap.getTile(m_target.mouseMapX, m_target.mouseMapY, m_target.mouseMapZ);
            if (!tile || tile == m_lastTile)
                return;
            
            m_target.worldMap.deleteTile(tile);
            m_lastTile = m_target.worldMap.getTile(m_target.mouseMapX, m_target.mouseMapY, m_target.mouseMapZ);
        }
        
        public function doRelease(x:uint, y:uint):void
        {
        }
        
        public function forceCommit():void
        {
        }
        
        public function showCursor():void
        {
        }
        
        public function hideCursor():void
        {
        }
    }
}
