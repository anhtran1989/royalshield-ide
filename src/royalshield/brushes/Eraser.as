package royalshield.brushes
{
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.Shape;
    
    import mx.managers.CursorManagerPriority;
    
    import royalshield.core.GameAssets;
    import royalshield.drawing.IDrawingTarget;
    import royalshield.entities.items.Item;
    import royalshield.geom.Position;
    import royalshield.history.HistoryActionGroup;
    import royalshield.history.MapHistoryAction;
    import royalshield.history.RSHistoryManager;
    import royalshield.utils.StringUtil;
    import royalshield.world.Tile;
    
    public class Eraser implements IBrush
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_brushManager:IBrushManager;
        private var m_target:IDrawingTarget;
        private var m_lastTile:Tile;
        private var m_type:String;
        private var m_size:uint;
        private var m_zoom:Number;
        private var m_cursorId:uint;
        private var m_cursor:Shape;
        private var m_actions:Vector.<MapHistoryAction>;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get type():String { return m_type; }
        
        public function get itemId():uint { return 0; }
        public function set itemId(value:uint):void {}
        
        public function get size():uint { return m_size; }
        public function set size(value:uint):void { m_size = value; }
        
        public function get zoom():Number { return m_zoom; }
        public function set zoom(value:Number):void { m_zoom = value; }
        
        public function get brushManager():IBrushManager { return m_brushManager; }
        public function set brushManager(value:IBrushManager):void { m_brushManager = value; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Eraser()
        {
            m_size = 1;
            m_zoom = 1.0;
            m_type = BrushType.ERASER;
            m_actions = new Vector.<MapHistoryAction>();
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
            //
        }
        
        public function doDrag(x:uint, y:uint):void
        {
            var tile:Tile = m_target.worldMap.getTile(m_target.mouseMapX, m_target.mouseMapY, m_target.mouseMapZ);
            if (!tile || tile == m_lastTile)
                return;
            
            m_lastTile = tile;
            
            var item:Item = m_target.worldMap.getTopItemAt(m_target.mouseMapX, m_target.mouseMapY, m_target.mouseMapZ);
            if (item && tile.removeItem(item)) {
                m_actions[m_actions.length] = new MapHistoryAction(new Position(tile.x, tile.y, tile.z), null, item, -1, -1);
                
                if (tile.itemCount == 0)
                    m_target.worldMap.deleteTile(tile);
            }
        }
        
        public function doRelease(x:uint, y:uint):void
        {
            m_lastTile = null;
            
            var length:uint = m_actions.length;
            if (length > 0) {
                var description:String = StringUtil.format("Removed {0} item{1}", length, length > 1 ? "s" : "");
                var actionGroup:HistoryActionGroup = new HistoryActionGroup(description);
                
                for (var i:int = 0; i < length; i++)
                    actionGroup.addAction(m_actions[i]);
                
                m_actions.length = 0;
                RSHistoryManager.getInstance().addActionGroup(actionGroup);
            }
        }
        
        public function forceCommit():void
        {
            //
        }
        
        public function showCursor():void
        {
            if (!m_brushManager || m_cursorId != 0)
                return;
            
            m_cursorId = m_brushManager.cursorManager.setCursor(Shape, CursorManagerPriority.HIGH);
            m_cursor = m_brushManager.cursorManager.currentCursor as Shape;
            if (m_cursor) {
                var texture:BitmapData = GameAssets.getInstance().getObjectTexturePreview(0, null);
                m_cursor.graphics.beginBitmapFill(texture);
                m_cursor.graphics.drawRect(0, 0, texture.width, texture.height);
                m_cursor.blendMode = BlendMode.DARKEN;
                m_cursor.alpha = 0.5;
                
                if (texture.width >= 64) {
                    m_brushManager.cursorManager.currentCursorXOffset = -(texture.width - 16);
                    m_brushManager.cursorManager.currentCursorYOffset = -(texture.height - 16);
                } else {
                    m_brushManager.cursorManager.currentCursorXOffset = -(texture.width * 0.5);
                    m_brushManager.cursorManager.currentCursorYOffset = -(texture.height * 0.5);
                }
            }
        }
        
        public function hideCursor():void
        {
            if (m_cursorId != 0) {
                m_brushManager.cursorManager.removeCursor(m_cursorId);
                m_cursorId = 0;
            }
        }
    }
}
