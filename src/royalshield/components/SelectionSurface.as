package royalshield.components
{
    import flash.geom.Point;
    
    import mx.core.UIComponent;
    
    [ExcludeClass]
    public class SelectionSurface extends UIComponent
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_startDrawPoint:Point;
        private var m_selecting:Boolean;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get selecting():Boolean { return m_selecting; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function SelectionSurface()
        {
            super();
            
            m_startDrawPoint = new Point();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function startDraw(x:Number, y:Number):void
        {
            m_startDrawPoint.setTo(x, y);
            m_selecting = true;
        }
        
        public function update(x:Number, y:Number):void
        {
            if (m_selecting) {
                var w:int = -(m_startDrawPoint.x - x);
                var h:int = -(m_startDrawPoint.y - y);
                if (Math.abs(w) > 1 && Math.abs(h) > 1) {
                    this.move(m_startDrawPoint.x, m_startDrawPoint.y);
                    this.setActualSize(w, h);
                }
            }
        }
        
        public function clear():void
        {
            if (m_selecting) {
                graphics.clear();
                m_selecting = false;
            }
        }
        
        //--------------------------------------
        // Override Protected
        //--------------------------------------
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            graphics.clear();
            if (m_selecting) {
                graphics.lineStyle(1, 0x0000FF, 0.5);
                graphics.beginFill(0x0000FF, 0.2);
                graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
                graphics.endFill();
            }
        }
    }
}
