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
    import royalshield.drawing.DrawingManager;
    import royalshield.drawing.IDrawingManager;
    import royalshield.drawing.IDrawingTarget;
    import royalshield.entities.items.Item;
    import royalshield.events.DrawingEvent;
    import royalshield.signals.Signal;
    import royalshield.utils.IDisposable;
    import royalshield.world.IWorldMap;
    import royalshield.world.Tile;
    
    [Event(name="brushPress", type="royalshield.events.DrawingEvent")]
    [Event(name="brushMove", type="royalshield.events.DrawingEvent")]
    [Event(name="brushDrag", type="royalshield.events.DrawingEvent")]
    [Event(name="brushRelease", type="royalshield.events.DrawingEvent")]
    [Event(name="selectionStart", type="royalshield.events.DrawingEvent")]
    [Event(name="selectionEnd", type="royalshield.events.DrawingEvent")]
    [Event(name="zoom", type="royalshield.events.DrawingEvent")]
    
    public class WorldMapDisplay extends UIComponent implements IDrawingTarget, IDisposable
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var editor:MapEditor;
        
        private var m_drawingManager:IDrawingManager;
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
        private var m_ctrlDown:Boolean;
        private var m_shiftDown:Boolean;
        private var m_zoom:Number;
        private var m_gridSurface:FlexShape;
        private var m_mouseTileSurface:FlexShape;
        private var m_selectionSurface:SelectionSurface;
        private var m_showGrid:Boolean;
        private var m_showMouseTile:Boolean;
        
        private var m_mouseMapChanged:Signal;
        
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
        
        public function get mouseDown():Boolean { return m_mouseDown; }
        public function get ctrlDown():Boolean { return m_ctrlDown; }
        public function get shiftDown():Boolean { return m_shiftDown; }
        
        public function get zoom():Number { return m_zoom; }
        public function set zoom(value:Number):void
        {
            if (isNaN(value))
                value = MIN_ZOOM;
            else if (value < MIN_ZOOM)
                value = MIN_ZOOM;
            else if (value > MAX_ZOOM)
                value = MAX_ZOOM;
            
            if (m_zoom != value) {
                m_zoom = value;
                invalidateDisplayList();
                invalidateSize();
                dispatchEvent(new DrawingEvent(DrawingEvent.ZOOM));
            }
        }
        
        public function get showGrid():Boolean { return m_showGrid; }
        public function set showGrid(value:Boolean):void
        {
            if (m_showGrid != value) {
                m_showGrid = value;
                invalidateDisplayList();
            }
        }
        
        public function get showMouseTile():Boolean { return m_showMouseTile; }
        public function set showMouseTile(value:Boolean):void
        {
            if (m_showMouseTile != value) {
                m_showMouseTile = value;
                invalidateDisplayList();
            }
        }
        
        public function get onMouseMapChanged():Signal { return m_mouseMapChanged; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function WorldMapDisplay()
        {
            super();
            
            m_drawingManager = DrawingManager.getInstance();
            
            m_matrix = new Matrix();
            m_zoom = 1.0;
            
            m_mouseMapChanged = new Signal();
            
            this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function draw():void
        {
            invalidateDisplayList();
        }
        
        public function dispose():void
        {
            this.worldMap = null;
            this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            this.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            this.onMouseMapChanged.removeAll();
        }
        
        //--------------------------------------
        // Override Protected
        //--------------------------------------
        
        override protected function createChildren():void
        {
            super.createChildren();
            
            m_gridSurface = new FlexShape();
            m_gridSurface.blendMode = BlendMode.INVERT;
            addChild(m_gridSurface);
            
            m_mouseTileSurface = new FlexShape();
            m_mouseTileSurface.blendMode = BlendMode.INVERT;
            addChild(m_mouseTileSurface);
            
            m_selectionSurface = new SelectionSurface();
            addChild(m_selectionSurface);
        }
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            if (!m_worldMap) return;
            
            var w:Number = Math.min(CANVAS_WIDTH, unscaledWidth);
            var h:Number = Math.min(CANVAS_HEIGHT, unscaledHeight);
            
            m_viewportX = int(w / (GameConsts.VIEWPORT_TILE_SIZE * m_zoom)) + 1;
            m_viewportY = int(h / (GameConsts.VIEWPORT_TILE_SIZE * m_zoom)) + 1;
            m_tilesSum = m_viewportX + m_viewportY;
            m_tilesTotal = m_viewportX * m_viewportY;
            m_matrix.a = m_zoom;
            m_matrix.d = m_zoom;
            
            CANVAS.lock();
            CANVAS.erase();
            
            for (var z:uint = 0; z <= m_worldMap.z; z++)
                drawTiles(z);
            
            CANVAS.unlock();
            
            graphics.clear();
            graphics.beginBitmapFill(CANVAS, m_matrix, false, true);
            graphics.drawRect(0, 0, w, h);
            graphics.endFill();
            
            drawGrid(w, h);
            drawMouseTile();
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
            if (!tile) return;
            
            var tileOffsetX:uint = (x + 1) * GameConsts.VIEWPORT_TILE_SIZE;
            var tileOffsetY:uint = (y + 1) * GameConsts.VIEWPORT_TILE_SIZE;
            var length:uint = tile.itemCount;
            var item:Item;
            
            CANVAS.useAlphaBitmapData = m_drawingManager.selectedTiles.hasTile(tile, this);
            for (var i:int = 0; i < length; i++) {
                item = tile.getItemAt(i);
                if (item)
                    item.render(CANVAS, tileOffsetX, tileOffsetY, tx, ty, z);
            }
        }
        
        private function drawGrid(width:Number, height:Number):void
        {
            var g:Graphics = m_gridSurface.graphics;
            g.clear();
            if (m_showGrid) {
                var size:Number = GameConsts.VIEWPORT_TILE_SIZE * m_zoom;
                
                g.lineStyle(0.5, 0x000000, 0.1);
                for (var x:int = 0; x < m_viewportX; x++) {
                    for (var y:int = 0; y < m_viewportY; y++) {
                        g.drawRect(x * size, y * size, size, size);
                    }
                }
                g.endFill();
            }
        }
        
        private function drawMouseTile():void
        {
            var g:Graphics = m_mouseTileSurface.graphics;
            g.clear();
            if (m_showMouseTile) {
                var size:Number = GameConsts.VIEWPORT_TILE_SIZE * m_zoom;
                var x:Number = Math.floor(this.mouseX / size) * size;
                var y:Number = Math.floor(this.mouseY / size) * size;
                if (x >= 0 && x < this.width && y >= 0 && y < this.height) {
                    g.lineStyle(0.5, 0x000000, 0.6);
                    g.drawRect(x, y, size, size);
                    g.endFill();
                }
            }
        }
        
        private function refreshMouseMap():void
        {
            var size:Number = GameConsts.VIEWPORT_TILE_SIZE * m_zoom;
            var posx:int = int(this.mouseX / size);
            if (posx < 0 || posx > m_viewportX)
                return;
            
            var posy:int = int(this.mouseY / size);
            if (posy < 0 || posy > m_viewportY)
                return;
            
            var scrollPoint:Point = editor.scrollPoint;
            var x:uint = scrollPoint.x + posx;
            var y:uint = scrollPoint.y + posy;
            var z:uint = m_worldMap.z;
            
            if (m_mouseMapX != x || m_mouseMapY != y || m_mouseMapZ != z) {
                m_mouseMapX = x;
                m_mouseMapY = y;
                m_mouseMapZ = z;
                m_mouseMapChanged.dispatch(m_mouseMapX, m_mouseMapY, m_mouseMapZ);
            }
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
            m_mouseDownY = m_mouseMapY;
            m_mouseDown = true;
            m_ctrlDown = event.ctrlKey;
            m_shiftDown = event.shiftKey;
            
            if (m_ctrlDown || m_shiftDown) {
                m_selectionSurface.startDraw(this.mouseX, this.mouseY);
                dispatchEvent(new DrawingEvent(DrawingEvent.SELECTION_START));
            }
            else
                dispatchEvent(new DrawingEvent(DrawingEvent.BRUSH_PRESS));
            
            systemManager.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        }
        
        protected function mouseMoveHandler(event:MouseEvent):void
        {
            refreshMouseMap();
            drawMouseTile();
            
            if (m_mouseDown) {
                m_selectionSurface.update(this.mouseX, this.mouseY);
                if (!m_selectionSurface.selecting)
                    dispatchEvent(new DrawingEvent(DrawingEvent.BRUSH_DRAG));
            }
        }
        
        protected function mouseUpHandler(event:MouseEvent):void
        {
            if (m_mouseDown) {
                if (m_selectionSurface.selecting)
                    dispatchEvent(new DrawingEvent(DrawingEvent.SELECTION_END));
                else
                    dispatchEvent(new DrawingEvent(DrawingEvent.BRUSH_RELEASE));
                
                m_mouseDown = false;
                systemManager.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
                m_selectionSurface.clear();
            }
            
            m_mouseDownX = uint.MAX_VALUE;
            m_mouseDownY = uint.MAX_VALUE;
            invalidateDisplayList();
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static private const MIN_ZOOM:Number = 1.0;
        static private const MAX_ZOOM:Number = 3.0;
        static private const CANVAS_WIDTH:uint = 1024;
        static private const CANVAS_HEIGHT:uint = 1024;
        static private const CANVAS:GameCanvas = new GameCanvas(CANVAS_WIDTH, CANVAS_HEIGHT);
    }
}
