package royalshield.components
{
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.events.NativeWindowDisplayStateEvent;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.ui.Keyboard;
    import flash.utils.Timer;
    
    import mx.core.FlexGlobals;
    import mx.events.ResizeEvent;
    
    import spark.components.Button;
    import spark.components.HScrollBar;
    import spark.components.NavigatorContent;
    import spark.components.VScrollBar;
    
    import royalshield.core.GameConsts;
    import royalshield.core.IRoyalShieldIDE;
    import royalshield.edition.IMapEditor;
    import royalshield.events.DrawingEvent;
    import royalshield.events.HistoryEvent;
    import royalshield.events.MapPositionEvent;
    import royalshield.history.HistoryActionGroup;
    import royalshield.history.IHistoryManager;
    import royalshield.history.MapHistoryManager;
    import royalshield.world.IWorldMap;
    
    [Event(name="mousePosition", type="royalshield.events.MapPositionEvent")]
    
    public class MapEditor extends NavigatorContent implements IMapEditor
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        [SkinPart(required="true", type="royalshield.components.WorldMapDisplay")]
        public var mapDisplay:WorldMapDisplay;
        
        [SkinPart(required="true", type="spark.components.HScrollBar")]
        public var horizontalScrollBar:HScrollBar;
        
        [SkinPart(required="true", type="spark.components.VScrollBar")]
        public var verticalScrollBar:VScrollBar;
        
        [SkinPart(required="true", type="centralizeButton")]
        public var centralizeButton:Button;
        
        private var m_application:IRoyalShieldIDE;
        private var m_map:IWorldMap;
        private var m_proposedMap:IWorldMap;
        private var m_mapChanged:Boolean;
        private var m_scrollPoint:Point;
        private var m_historyManager:IHistoryManager;
        private var m_timer:Timer;
        private var m_changed:Boolean;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get map():IWorldMap { return m_proposedMap ? m_proposedMap : m_map; }
        public function set map(value:IWorldMap):void
        {
            if (m_map != value) {
                m_proposedMap = value;
                m_mapChanged = true;
                invalidateProperties();
            }
        }
        
        public function get display():WorldMapDisplay { return mapDisplay; }
        
        public function get scrollPoint():Point
        {
            if (initialized)
                m_scrollPoint.setTo(horizontalScrollBar.value, verticalScrollBar.value);
            else
                m_scrollPoint.setTo(0, 0);
            
            return m_scrollPoint;
        }
        
        public function get historyManager():IHistoryManager { return m_historyManager; }
        
        public function get changed():Boolean { return m_changed; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function MapEditor()
        {
            super();
            
            m_application = IRoyalShieldIDE(FlexGlobals.topLevelApplication);
            m_application.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, stateChangeHandler);
            m_scrollPoint = new Point();
            m_historyManager = new MapHistoryManager();
            m_historyManager.addActionGroup(new HistoryActionGroup("default"));
            m_historyManager.addEventListener(HistoryEvent.LIST_CHANGE, historyChangedHandler);
            m_timer = new Timer(100);
            m_timer.addEventListener(TimerEvent.TIMER, timeCompleteHandler);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function onMoveMapNorth():void
        {
            if (m_map)
                m_map.setPosition(m_map.x, Math.max(0, m_map.y - 1), m_map.z);
        }
        
        public function onMoveMapSouth():void
        {
            if (m_map)
                m_map.setPosition(m_map.x, Math.min(verticalScrollBar.maximum, m_map.y + 1), m_map.z);
        }
        
        public function onMoveMapWest():void
        {
            if (m_map)
                m_map.setPosition(Math.max(0, m_map.x - 1), m_map.y, m_map.z);
        }
        
        public function onMoveMapEast():void
        {
            if (m_map)
                m_map.setPosition(Math.min(horizontalScrollBar.maximum, m_map.x + 1), m_map.y, m_map.z);
        }
        
        public function onLayerUp():void
        {
            if (m_map)
                m_map.setPosition(m_map.x, m_map.y, Math.min(m_map.layers - 1, m_map.z + 1));
        }
        
        public function onLayerDown():void
        {
            if (m_map)
                m_map.setPosition(m_map.x, m_map.y, Math.max(0, m_map.z - 1));
        }
        
        public function onCentralizeMap():void
        {
            if (m_map)
                m_map.setPosition(uint(horizontalScrollBar.maximum * 0.5), uint(verticalScrollBar.maximum * 0.5), m_map.z);
        }
        
        public function dispose():void
        {
            m_application.nativeWindow.removeEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, stateChangeHandler);
            m_scrollPoint = null;
            m_historyManager.dispose();
            m_historyManager = null;
            m_timer.removeEventListener(TimerEvent.TIMER, timeCompleteHandler);
            m_timer = null;
            mapDisplay.onMouseMapChanged.remove(onMouseMapChangedCallback);
            mapDisplay.removeEventListener(DrawingEvent.ZOOM, mapDisplayZoomHandler);
            mapDisplay.removeEventListener(Event.RESIZE, mapDisplayResizeHandler);
            mapDisplay.dispose();
        }
        
        //--------------------------------------
        // Override Protected
        //--------------------------------------
        
        override protected function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName, instance);
            
            if (instance == mapDisplay) {
                mapDisplay.editor = this;
                mapDisplay.onMouseMapChanged.add(onMouseMapChangedCallback);
                mapDisplay.addEventListener(DrawingEvent.ZOOM, mapDisplayZoomHandler);
                mapDisplay.addEventListener(Event.RESIZE, mapDisplayResizeHandler);
            } else if (instance == horizontalScrollBar) {
                horizontalScrollBar.minimum = 0;
                horizontalScrollBar.addEventListener(Event.CHANGE, scrollbarChangeHandler);
            } else if (instance == verticalScrollBar) {
                verticalScrollBar.minimum = 0;
                verticalScrollBar.addEventListener(Event.CHANGE, scrollbarChangeHandler);
            } else if (instance == centralizeButton)
                centralizeButton.addEventListener(MouseEvent.CLICK, centralizeButtonClickHandler);
        }
        
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            if (m_mapChanged) {
                setMap(m_proposedMap);
                m_proposedMap = null;
                m_mapChanged = false;
            }
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function setMap(map:IWorldMap):void
        {
            if (m_map)
                m_map.onPositionChanged.remove(mapPositionChangedCallback);
            
            m_map = map;
            mapDisplay.worldMap = m_map;
            label = m_map ? m_map.name : "";
            
            if (m_map)
                m_map.onPositionChanged.add(mapPositionChangedCallback);
            
            MapHistoryManager(m_historyManager).map = m_map;
            updateScrollBarValues();
        }
        
        private function updateScrollBarValues():void
        {
            if (m_map) {
                horizontalScrollBar.maximum = m_map.width - int(mapDisplay.width / GameConsts.VIEWPORT_TILE_SIZE * mapDisplay.zoom);
                verticalScrollBar.maximum = m_map.height - int(mapDisplay.height / GameConsts.VIEWPORT_TILE_SIZE * mapDisplay.zoom);
            }
        }
        
        private function updateMapPosition():void
        {
            if (m_map) {
                var x:uint = horizontalScrollBar.value;
                var y:uint = verticalScrollBar.value;
                if (m_map.inMapRange(x, y, m_map.z))
                    m_map.setPosition(x, y, m_map.z);
            }
        }
        
        private function update():void
        {
            updateScrollBarValues();
            updateMapPosition();
        }
        
        private function mapPositionChangedCallback(x:uint, y:uint, z:uint):void
        {
            if (horizontalScrollBar.value != x || verticalScrollBar.value != y) {
                updateScrollBarValues();
                horizontalScrollBar.value = x;
                verticalScrollBar.value = y;
            }
        }
        
        private function onMouseMapChangedCallback(x:uint, y:uint, z:uint):void
        {
            dispatchEvent(new MapPositionEvent(MapPositionEvent.MOUSE_POSITION, x, y, z));
        }
        
        //--------------------------------------
        // Event Handlers
        //--------------------------------------
        
        protected function centralizeButtonClickHandler(event:MouseEvent):void
        {
            this.onCentralizeMap();
        }
        
        protected function scrollbarChangeHandler(event:Event):void
        {
            this.updateMapPosition();
        }
        
        protected function mapDisplayZoomHandler(event:DrawingEvent):void
        {
            this.updateScrollBarValues();
        }
        
        protected function mapDisplayResizeHandler(event:ResizeEvent):void
        {
            this.update();
        }
        
        protected function stateChangeHandler(event:NativeWindowDisplayStateEvent):void
        {
            if (!m_timer.running)
                m_timer.start();
        }
        
        protected function timeCompleteHandler(event:TimerEvent):void
        {
            update();
            m_timer.stop();
        }
        
        protected function historyChangedHandler(event:HistoryEvent):void
        {
            m_changed = true;
            this.label = m_map.name + " *";
            this.mapDisplay.draw();
        }
        
        override protected function keyDownHandler(event:KeyboardEvent):void
        {
            var keyCode:uint = event.keyCode;
            if (!event.ctrlKey && !event.shiftKey) {
                switch(keyCode)
                {
                    case Keyboard.UP:
                        this.onMoveMapNorth();
                        break;
                    
                    case Keyboard.DOWN:
                        this.onMoveMapSouth();
                        break;
                    
                    case Keyboard.LEFT:
                        this.onMoveMapWest();
                        break;
                    
                    case Keyboard.RIGHT:
                        this.onMoveMapEast();
                        break;
                    
                    case Keyboard.PAGE_UP:
                        this.onLayerUp();
                        break;
                    
                    case Keyboard.PAGE_DOWN:
                        this.onLayerDown();
                        break;
                    
                    case Keyboard.DELETE:
                        m_application.drawingManager.onDeleteSelectedTiles();
                        break;
                }
            } else if (event.ctrlKey && !event.shiftKey) {
                switch(keyCode)
                {
                    case Keyboard.Z:
                        m_historyManager.undo();
                        break;
                    
                    case Keyboard.Y:
                        m_historyManager.redo();
                        break;
                }
            }
        }
    }
}
