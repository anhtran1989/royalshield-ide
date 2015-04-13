package royalshield.brushes
{
    import flash.display.Graphics;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.GlowFilter;
    import flash.ui.Mouse;
    
    import mx.core.mx_internal;
    
    import royalshield.assets.AssetsManager;
    import royalshield.drawing.IDrawingTarget;
    import royalshield.edition.EditorManager;
    import royalshield.entities.items.Item;
    import royalshield.geom.Position;
    import royalshield.history.HistoryActionGroup;
    import royalshield.history.ItemMapHistoryAction;
    import royalshield.utils.StringUtil;
    import royalshield.world.Tile;
    
    use namespace mx_internal;
    
    public class Brush implements IBrush
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_brushManager:IBrushManager;
        private var m_lastTile:Tile;
        private var m_type:String;
        private var m_itemId:uint;
        private var m_size:uint;
        private var m_visible:Boolean;
        private var m_actions:Vector.<ItemMapHistoryAction>;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get type():String { return m_type; }
        
        public function get itemId():uint { return m_itemId; }
        public function set itemId(value:uint):void { m_itemId = value; }
        
        public function get size():uint { return m_size; }
        public function set size(value:uint):void { m_size = value; }
        
        public function get brushManager():IBrushManager { return m_brushManager; }
        public function set brushManager(value:IBrushManager):void { m_brushManager = value; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Brush()
        {
            m_size = 1;
            m_type = BrushType.BRUSH;
            m_actions = new Vector.<ItemMapHistoryAction>();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function doPress(x:uint, y:uint):void
        {
            if (m_itemId != 0)
                doDrag(x, y);
        }
        
        public function doMove(x:uint, y:uint):void
        {
            if (m_brushManager && m_brushManager.target && m_visible && m_itemId !== 0) {
                drawCursor();
            }
        }
        
        public function doDrag(x:uint, y:uint):void
        {
            if (m_itemId == 0)
                return;
            
            var item:Item = AssetsManager.getInstance().getItem(m_itemId);
            if (!item)
                return;
            
            var target:IDrawingTarget = m_brushManager.target;
            var tile:Tile = target.worldMap.setTile(target.mouseMapX, target.mouseMapY, target.mouseMapZ);
            if (!tile || tile == m_lastTile)
                return;
            
            m_lastTile = tile;
            if (tile.queryAdd(item) && tile.addItem(item)){
                var index:int = tile.indexOfItem(item);
                m_actions[m_actions.length] = new ItemMapHistoryAction(null, new Position(tile.x, tile.y, tile.z), item, -1, index);
            }
        }
        
        public function doRelease(x:uint, y:uint):void
        {
            m_lastTile = null;
            
            var length:uint = m_actions.length;
            if (length > 0) {
                var description:String = StringUtil.format("Added {0} item{1} id {2}", length, length > 1 ? "s" : "", m_itemId);
                var actionGroup:HistoryActionGroup = new HistoryActionGroup(description);
                
                for (var i:int = 0; i < length; i++)
                    actionGroup.addAction(m_actions[i]);
                
                m_actions.length = 0;
                EditorManager.getInstance().currentHistoryManager.addActionGroup(actionGroup);
            }
        }
        
        public function showCursor():void
        {
            if (m_brushManager && m_brushManager.target && !m_visible && m_itemId !== 0) {
                m_visible = true;
                Mouse.hide();
                drawCursor();
            }
        }
        
        public function hideCursor():void
        {
            if (m_visible) {
                m_visible = false;
                Mouse.show();
                drawCursor();
            }
        }
        
        public function dispose():void
        {
            m_brushManager = null;
            m_lastTile = null;
            m_type = null;
            m_itemId = 0;
            m_size = 0;
            m_visible = false;
            m_actions.length = 0;
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function drawCursor():void
        {
            var target:IDrawingTarget = m_brushManager.target;
            var g:Graphics = target.cursorSurface.graphics;
            g.clear();
            if (m_visible) {
                var centerX:Number = Math.floor(target.mouseX / target.measuredTileSize) * target.measuredTileSize;
                var centerY:Number = Math.floor(target.mouseY / target.measuredTileSize) * target.measuredTileSize;
                if (centerX >= 0 && centerX < target.width && centerY >= 0 && centerY < target.height) {
                    g.lineStyle(0.5, 0xFFFFFF, 0.6);
                    g.beginFill(0x0000FF, 0.3);
                    g.drawRect(centerX, centerY, target.measuredTileSize, target.measuredTileSize);
                    g.endFill();
                }
            }
        }
    }
}
