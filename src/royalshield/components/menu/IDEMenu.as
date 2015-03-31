package royalshield.components.menu
{
    import flash.events.Event;
    
    import mx.controls.FlexNativeMenu;
    import mx.core.FlexGlobals;
    import mx.events.FlexEvent;
    import mx.events.FlexNativeMenuEvent;
    
    import royalshield.core.IIDE;
    import royalshield.utils.CapabilitiesUtil;
    import royalshield.utils.DescriptorUtil;
    
    [Event(name="selected", type="royalshield.events.MenuEvent")]
    
    public class IDEMenu extends FlexNativeMenu
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_application:IIDE;
        private var m_isMac:Boolean;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function IDEMenu()
        {
            super();
            
            m_application = IIDE(FlexGlobals.topLevelApplication);
            m_application.addEventListener(FlexEvent.CREATION_COMPLETE, creationComplete);
            m_isMac = CapabilitiesUtil.isMac;
            
            this.labelField = "@label";
            this.keyEquivalentField = "@keyEquivalent";
            this.showRoot = false;
            
            this.addEventListener(FlexNativeMenuEvent.ITEM_CLICK, itemClickHandler);
            this.addEventListener(FlexNativeMenuEvent.MENU_SHOW, showMenuItem);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function create():void
        {
            // Root menu
            var menu:MenuItem = new MenuItem();
            var macMenu:MenuItem;
            
            // Separator
            var separator:MenuItem = new MenuItem();
            
            if (m_isMac) {
                macMenu = new MenuItem();
                macMenu.label = DescriptorUtil.getName();
                menu.addMenuItem(macMenu);
            }
            
            // Help
            var helpMenu:MenuItem = new MenuItem();
            helpMenu.label = "Help";
            menu.addMenuItem(helpMenu);
            
            // Help > About
            var aboutMenu:MenuItem = new MenuItem();
            aboutMenu.label = "About " + DescriptorUtil.getName();
            aboutMenu.data = HELP_ABOUT;
            
            if (m_isMac) {
                macMenu.addMenuItem(aboutMenu);
            } else {
                helpMenu.addMenuItem(aboutMenu);
            }
            
            this.dataProvider = menu.serialize();
        }
        
        //--------------------------------------
        // Event Handlers
        //--------------------------------------
        
        protected function creationComplete(event:Event):void
        {
            m_application.removeEventListener(FlexEvent.CREATION_COMPLETE, creationComplete);
            create();
        }
        
        protected function itemClickHandler(event:FlexNativeMenuEvent):void
        {
            // TODO Auto-generated method stub
        }
        
        protected function showMenuItem(event:FlexNativeMenuEvent):void
        {
            // TODO Auto-generated method stub
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static const HELP_ABOUT:String = "helpAbout";
    }
}
