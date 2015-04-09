package royalshield.components
{
    import flash.events.MouseEvent;
    
    import mx.events.ListEvent;
    
    import spark.components.Button;
    import spark.components.ButtonBarButton;
    
    public class TabPlus extends ButtonBarButton
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        [SkinPart(required="true", type="spark.components.Button")]
        public var closeButton:Button;
        
        private var m_closePolicy:String;
        private var m_closeIncluded:Boolean;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get canClose():Boolean { return m_closeIncluded; }
        public function set canClose(value:Boolean):void 
        { 
            m_closeIncluded = value;
            skin.invalidateDisplayList();
        }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function TabPlus()
        {
            super();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Override Protected
        //--------------------------------------
        
        override protected function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName, instance);
            
            if (instance == closeButton)
                closeButton.addEventListener(MouseEvent.CLICK, closeButtonClickHandler);
        }
        
        override protected function partRemoved(partName:String, instance:Object):void
        {
            super.partRemoved(partName, instance);
            
            if (instance == closeButton)
                closeButton.removeEventListener(MouseEvent.CLICK, closeButtonClickHandler);
        }
        
        //--------------------------------------
        // Event Handlers
        //--------------------------------------
        
        protected function closeButtonClickHandler(event:MouseEvent):void
        {
            dispatchEvent(new ListEvent(CLOSE_TAB_EVENT, true, false, -1, itemIndex));
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static const CLOSE_TAB_EVENT:String = "closeTab";
    }
}
