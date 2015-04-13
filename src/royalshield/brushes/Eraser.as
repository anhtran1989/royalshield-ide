package royalshield.brushes
{
    import flash.display.Graphics;
    import flash.ui.Mouse;
    
    import royalshield.drawing.IDrawingTarget;
    import royalshield.edition.EditorManager;
    import royalshield.entities.items.Item;
    import royalshield.geom.Position;
    import royalshield.history.HistoryActionGroup;
    import royalshield.history.ItemMapHistoryAction;
    import royalshield.utils.StringUtil;
    import royalshield.world.Tile;
    
    public class Eraser implements IBrush
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_brushManager:IBrushManager;
        private var m_type:String;
        private var m_size:uint;
        private var m_visible:Boolean;
        private var m_actions:Vector.<ItemMapHistoryAction>;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get type():String { return m_type; }
        
        public function get itemId():uint { return 0; }
        public function set itemId(value:uint):void {}
        
        public function get size():uint { return m_size; }
        public function set size(value:uint):void
        { 
            value = value == 0 ? 1 : value;
            
            if (m_size != value) {
                m_size = value;
                if (m_visible)
                    drawCursor();
            }
        }
        
        public function get brushManager():IBrushManager { return m_brushManager; }
        public function set brushManager(value:IBrushManager):void { m_brushManager = value; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Eraser()
        {
            m_size = 1;
            m_type = BrushType.ERASER;
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
            doDrag(x, y);
        }
        
        public function doMove(x:uint, y:uint):void
        {
            if (m_brushManager && m_brushManager.target && m_visible) {
                drawCursor();
            }
        }
        
        public function doDrag(x:uint, y:uint):void
        {
            var target:IDrawingTarget = m_brushManager.target;
            for (var tx:int = 0; tx < m_size; tx++) {
                for (var ty:int = 0; ty < m_size; ty++) {
                    var px:Number = target.mouseMapX - tx;
                    var py:Number = target.mouseMapY - ty;
                    if (px >= 0 && py >= 0) {
                        var tile:Tile = target.worldMap.setTile(px, py, target.mouseMapZ);
                        var item:Item = target.worldMap.getTopItemAt(px, py, target.mouseMapZ);
                        if (tile && tile.removeItem(item)) {
                            m_actions[m_actions.length] = new ItemMapHistoryAction(new Position(tile.x, tile.y, tile.z), null, item, -1, -1);
                            
                            if (tile.itemCount == 0)
                                target.worldMap.deleteTile(tile);
                        }
                    }
                }
            }
        }
        
        public function doRelease(x:uint, y:uint):void
        {
            var length:uint = m_actions.length;
            if (length > 0) {
                var description:String = StringUtil.format("Removed {0} item{1}", length, length > 1 ? "s" : "");
                var actionGroup:HistoryActionGroup = new HistoryActionGroup(description);
                
                for (var i:int = 0; i < length; i++)
                    actionGroup.addAction(m_actions[i]);
                
                m_actions.length = 0;
                EditorManager.getInstance().currentHistoryManager.addActionGroup(actionGroup);
            }
        }
        
        public function showCursor():void
        {
            if (m_brushManager && m_brushManager.target && !m_visible) {
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
            m_type = null;
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
                var tileX:Number = Math.floor(target.mouseX / target.measuredTileSize);
                var tileY:Number = Math.floor(target.mouseY / target.measuredTileSize);
                
                g.lineStyle(0.5, 0xFFFFFF, 0.6);
                g.beginFill(0xFF0000, 0.3);
                for (var x:int = 0; x < m_size; x++) {
                    for (var y:int = 0; y < m_size; y++) {
                        var px:Number = tileX - x;
                        var py:Number = tileY - y;
                        if (px >= 0 && px < target.width && py >= 0 && py < target.height) {
                            g.drawRect(px * target.measuredTileSize, py * target.measuredTileSize, target.measuredTileSize, target.measuredTileSize);
                        }
                    }
                }
                g.endFill();
            }
        }
    }
}
