package royalshield.components
{
    import mx.events.ListEvent;
    
    import spark.components.TabBar;
    import spark.events.RendererExistenceEvent;
    
    import royalshield.events.TabBarEvent;
    
    [Style(name="tabSkin", type="Class", inherit="no")]
    
    [Event(name="tabClose", type="royalshield.events.TabBarEvent")]
    
    public class TabBarPlus extends TabBar
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_closePolicy:String = CLOSE_ALWAYS;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        [Inspectable(type="String", format="String", enumeration="never,always", defaultValue="always")]
        public function get closePolicy():String { return m_closePolicy; }
        public function set closePolicy(val:String):void {  m_closePolicy = val; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function TabBarPlus()
        {
            super();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
       
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function setTabClosePolicy(index:int, canClose:Boolean):void
        {
            var tab:TabPlus = dataGroup.getElementAt(index) as TabPlus;
            if (tab)
                tab.canClose = canClose;
        }
        
        //--------------------------------------
        // Override Protected
        //--------------------------------------
        
        protected override function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName, instance);
            
            if (instance == dataGroup) {
                dataGroup.addEventListener(TabPlus.CLOSE_TAB_EVENT, onCloseTabClicked);
                dataGroup.addEventListener(RendererExistenceEvent.RENDERER_ADD, tabAdded);
            }
        }
        
        protected override function partRemoved(partName:String, instance:Object):void
        {
            super.partRemoved(partName, instance);
            
            if (instance == dataGroup) {
                dataGroup.removeEventListener(TabPlus.CLOSE_TAB_EVENT, onCloseTabClicked);
                dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_ADD, tabAdded);
            }
        }
        
        //--------------------------------------
        // Event Handlers
        //--------------------------------------
        
        protected function tabAdded(event:RendererExistenceEvent):void
        {
            var tab:TabPlus = dataGroup.getElementAt(event.index) as TabPlus;
            
            var tabSkinClass:Class = getStyle("tabSkin");
            if (tabSkinClass)
                tab.setStyle("skinClass", tabSkinClass);
            
            tab.canClose = (m_closePolicy == CLOSE_ALWAYS);
        }
        
        protected function onCloseTabClicked(event:ListEvent):void
        {
            dispatchEvent(new TabBarEvent(TabBarEvent.TAB_CLOSE, event.rowIndex));
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static public const CLOSE_ALWAYS:String = "always";
        static public const CLOSE_NEVER:String = "never";
    }
}
