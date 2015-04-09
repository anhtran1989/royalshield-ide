package royalshield.brushes
{
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.Shape;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.GlowFilter;
    
    import mx.core.mx_internal;
    import mx.managers.CursorManagerPriority;
    
    import royalshield.assets.AssetsManager;
    import royalshield.core.GameAssets;
    import royalshield.drawing.IDrawingTarget;
    import royalshield.edition.EditorManager;
    import royalshield.entities.items.Item;
    import royalshield.geom.Position;
    import royalshield.history.HistoryActionGroup;
    import royalshield.history.MapHistoryAction;
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
        private var m_zoom:Number;
        private var m_cursorId:uint;
        private var m_cursor:Shape;
        private var m_actions:Vector.<MapHistoryAction>;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get type():String { return m_type; }
        
        public function get itemId():uint { return m_itemId; }
        public function set itemId(value:uint):void { m_itemId = value; }
        
        public function get size():uint { return m_size; }
        public function set size(value:uint):void { m_size = value; }
        
        public function get zoom():Number { return m_zoom; }
        public function set zoom(value:Number):void { m_zoom = value; }
        
        public function get brushManager():IBrushManager { return m_brushManager; }
        public function set brushManager(value:IBrushManager):void { m_brushManager = value; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Brush()
        {
            m_size = 1;
            m_zoom = 1.0;
            m_type = BrushType.BRUSH;
            m_actions = new Vector.<MapHistoryAction>();
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
            if (m_lastTile.addItem(item)){
                var index:int = tile.indexOfItem(item);
                m_actions[m_actions.length] = new MapHistoryAction(null, new Position(tile.x, tile.y, tile.z), item, -1, index);
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
            if (!m_brushManager || m_cursorId != 0 || m_itemId == 0)
                return;
            
            m_cursorId = m_brushManager.cursorManager.setCursor(Shape, CursorManagerPriority.HIGH);
            m_cursor = m_brushManager.cursorManager.currentCursor as Shape;
            if (m_cursor) {
                var texture:BitmapData = GameAssets.getInstance().getObjectTexturePreview(0, null);
                m_cursor.graphics.beginBitmapFill(texture);
                m_cursor.graphics.drawRect(0, 0, texture.width, texture.height);
                m_cursor.blendMode = BlendMode.NORMAL;
                m_cursor.alpha = 0.5;
                m_cursor.filters = [OUTLINE];
                
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
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        private static const OUTLINE:GlowFilter = new GlowFilter(0, 1, 2, 2, 4, BitmapFilterQuality.MEDIUM);
    }
}
