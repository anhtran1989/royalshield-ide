package royalshield.components
{
    import flash.display.BlendMode;
    import flash.display.Graphics;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    
    import mx.core.FlexShape;
    import mx.core.UIComponent;
    
    import royalshield.core.GameConsts;
    import royalshield.display.GameCanvas;
    import royalshield.drawing.IDrawingTarget;
    import royalshield.entities.items.Item;
    import royalshield.events.DrawingEvent;
    import royalshield.world.IWorldMap;
    import royalshield.world.Tile;
    
    [Event(name="brushPress", type="royalshield.events.DrawingEvent")]
    [Event(name="brushMove", type="royalshield.events.DrawingEvent")]
    [Event(name="brushDrag", type="royalshield.events.DrawingEvent")]
    [Event(name="brushRelease", type="royalshield.events.DrawingEvent")]
    [Event(name="zoom", type="royalshield.events.DrawingEvent")]
    
    public class WorldMapDisplay extends UIComponent implements IDrawingTarget
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var editorPanel:EditorPanel;
        
        private var m_canvas:GameCanvas;
        private var m_worldMap:IWorldMap;
        private var m_matrix:Matrix;
        private var m_viewportX:int;
        private var m_viewportY:int;
        private var m_tilesSum:int;
        private var m_tilesTotal:int;
        private var m_mouseMapX:uint;
        private var m_mouseMapY:uint;
        private var m_mouseMapZ:uint;
        private var m_mouseDownX:uint;
        private var m_mouseDownY:uint;
        private var m_mouseDown:Boolean;
        private var m_zoom:Number;
        private var m_gridSurface:FlexShape;
        private var m_showGrid:Boolean;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get worldMap():IWorldMap { return m_worldMap; }
        public function set worldMap(value:IWorldMap):void
        {
            if (m_worldMap != value) {
                if (m_worldMap) {
                    m_worldMap.onPositionChanged.remove(mapPositionChangeCallback);
                    m_worldMap.onMapDirty.add(mapDirtyCallback);
                }
                
                m_worldMap = value;
                invalidateDisplayList();
                
                if (m_worldMap) {
                    m_worldMap.onPositionChanged.add(mapPositionChangeCallback);
                    m_worldMap.onMapDirty.add(mapDirtyCallback);
                }
            }
        }
        
        public function get mouseMapX():uint { return m_mouseMapX; }
        public function get mouseMapY():uint { return m_mouseMapY; }
        public function get mouseMapZ():uint { return m_mouseMapZ; }
        
        public function get mouseDownX():uint { return m_mouseDownX; }
        public function get mouseDownY():uint { return m_mouseDownY; }
        
        public function get zoom():Number { return m_zoom; }
        public function set zoom(value:Number):void { }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function WorldMapDisplay()
        {
            super();
            
            m_canvas = new GameCanvas(CANVAS_WIDTH, CANVAS_HEIGHT);
            m_matrix = new Matrix();
            m_showGrid = true;
            m_zoom = 1.0;
            
            addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Override Protected
        //--------------------------------------
        
        override protected function createChildren():void
        {
            super.createChildren();
            
            m_gridSurface = new FlexShape();
            m_gridSurface.blendMode = BlendMode.INVERT;
            addChild(m_gridSurface);
        }
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            if (!m_worldMap) return;
            
            var w:Number = Math.min(CANVAS_WIDTH, unscaledWidth);
            var h:Number = Math.min(CANVAS_HEIGHT, unscaledHeight);
            
            m_viewportX = int(w / (m_worldMap.tileSize * m_zoom)) + 1;
            m_viewportY = int(h / (m_worldMap.tileSize * m_zoom)) + 1;
            m_tilesSum = m_viewportX + m_viewportY;
            m_tilesTotal = m_viewportX * m_viewportY;
            m_matrix.a = m_zoom;
            m_matrix.d = m_zoom;
            
            m_canvas.lock();
            m_canvas.erase();
            
            drawTiles(m_worldMap.z);
            
            m_canvas.unlock();
            
            graphics.clear();
            graphics.beginBitmapFill(m_canvas, m_matrix, false, true);
            graphics.drawRect(0, 0, w, h);
            graphics.endFill();
            
            if (m_showGrid)
                drawGrid(w, h);
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function drawTiles(z:int):void
        {
            var x:int;
            var y:int;
            
            for (var i:int = 0; i < m_tilesSum; i++) {
                x = (m_viewportX - 1);
                x = x > i ? i : x
                y = (i - m_viewportX + 1);
                y = y < 0 ? 0 : y;
                
                while (x >= 0 && y < m_viewportY) {
                    drawTile(x, y, z);
                    x--;
                    y++;
                }
            }
        }
        
        private function drawTile(x:uint, y:uint, z:uint):void
        {
            var tx:uint = x + m_worldMap.x;
            var ty:uint = y + m_worldMap.y;
            var tile:Tile = m_worldMap.getTile(tx, ty, z);
            if (!tile)
                return;
            
            var tileOffsetX:uint = (x + 1) * GameConsts.VIEWPORT_TILE_SIZE;
            var tileOffsetY:uint = (y + 1) * GameConsts.VIEWPORT_TILE_SIZE;
            var length:uint = tile.itemCount;
            var item:Item;
            
            for (var i:int = 0; i < length; i++) {
                item = tile.getItemAt(i);
                if (item)
                    item.render(m_canvas, tileOffsetX, tileOffsetY, tx, ty, z);
            }
        }
        
        private function drawGrid(width:Number, height:Number):void
        {
            var size:Number = m_worldMap.tileSize * this.zoom;
            var g:Graphics = m_gridSurface.graphics;
            g.clear();
            g.lineStyle(0.5, 0x000000, 0.1);
            
            for (var x:int = 0; x < m_viewportX; x++) {
                for (var y:int = 0; y < m_viewportY; y++) {
                    g.drawRect(x * size, y * size, size, size);
                }
            }
            
            g.endFill();
        }
        
        private function refreshMouseMap():void
        {
            var size:Number = GameConsts.VIEWPORT_TILE_SIZE * zoom;
            var posx:int = int((mouseX - m_matrix.tx) / m_matrix.a / size);
            if (posx < 0 || posx > m_viewportX)
                return;
            
            var posy:int = int((mouseY - m_matrix.ty) / m_matrix.d / size);
            if (posy < 0 || posy > m_viewportY)
                return;
            
            var scrollPoint:Point = editorPanel.scrollPoint;
            m_mouseMapX = uint(scrollPoint.x / size) + posx;
            m_mouseMapY = uint(scrollPoint.y / size) + posy;
            m_mouseMapZ = m_worldMap.z;
        }
        
        private function mapPositionChangeCallback(x:uint, y:uint, z:uint):void
        {
            invalidateDisplayList();
            refreshMouseMap();
        }
        
        private function mapDirtyCallback():void
        {
            invalidateDisplayList();
        }
        
        //--------------------------------------
        // Event Handlers
        //--------------------------------------
        
        protected function mouseDownHandler(event:MouseEvent):void
        { 
            refreshMouseMap();
            m_mouseDownX = m_mouseMapX;
            m_mouseDownY = m_mouseDownY;
            m_mouseDown = true;
            
            systemManager.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            dispatchEvent(new DrawingEvent(DrawingEvent.BRUSH_PRESS));
        }
        
        protected function mouseMoveHandler(event:MouseEvent):void
        {
            refreshMouseMap();
            dispatchEvent(new DrawingEvent(DrawingEvent.BRUSH_MOVE));
            
            if (m_mouseDown)
                dispatchEvent(new DrawingEvent(DrawingEvent.BRUSH_DRAG));
        }
        
        protected function mouseUpHandler(event:MouseEvent):void
        {
            m_mouseDownX = uint.MAX_VALUE;
            m_mouseDownY = uint.MAX_VALUE;
            
            if (m_mouseDown) {
                m_mouseDown = false;
                systemManager.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
                dispatchEvent(new DrawingEvent(DrawingEvent.BRUSH_RELEASE));
            }
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static const CANVAS_WIDTH:uint = 1024;
        public static const CANVAS_HEIGHT:uint = 1024;
        
        private static const MIN_ZOOM:Number = 1.0;
        private static const MAX_ZOOM:Number = 3.0;
    }
}
