package royalshield.components
{
    import flash.events.Event;
    
    import mx.collections.IList;
    import mx.events.CloseEvent;
    import mx.events.FlexEvent;
    
    import spark.components.BorderContainer;
    import spark.components.Button;
    import spark.components.List;
    import spark.components.supportClasses.DropDownController;
    import spark.events.DropDownEvent;
    import spark.events.IndexChangeEvent;
    
    [SkinState("open")]
    
    [Event(name="change", type="spark.events.IndexChangeEvent")]
    
    public class DropDownButton extends Button
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        [SkinPart(required="true", type="spark.components.Button")]
        public var button:Button;
        
        [SkinPart(required="true", type="spark.components.Button")]
        public var openButton:Button;
        
        [SkinPart(required="true", type="spark.components.BorderContainer")]
        public var dropDown:BorderContainer;
        
        [SkinPart(required="true", type="spark.components.List")]
        public var list:List;
        
        private var m_dropDownController:DropDownController;
        private var m_closeDropDownOnResize:Boolean = true;
        private var m_dataProvider:IList;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get isDropDownOpen():Boolean
        {
            if (m_dropDownController)
                return m_dropDownController.isOpen;
            
            return false;
        }
        
        public function get dataProvider():IList { return m_dataProvider; }
        public function set dataProvider(value:IList):void
        {
            if (m_dataProvider != value) {
                m_dataProvider = value;
                
                if (list)
                    list.dataProvider = m_dataProvider;
            }
        }
        
        protected function get dropDownController():DropDownController { return m_dropDownController; }
        protected function set dropDownController(value:DropDownController):void
        {
            if (m_dropDownController != value) {
                m_dropDownController = value;
                m_dropDownController.addEventListener(DropDownEvent.OPEN, dropDownControllerOpenHandler);
                m_dropDownController.addEventListener(DropDownEvent.CLOSE, dropDownController_closeHandler);
                m_dropDownController.closeOnResize = m_closeDropDownOnResize;
                
                if (openButton)
                    m_dropDownController.openButton = openButton;
                
                if (dropDown)
                    m_dropDownController.dropDown = dropDown;
            }
        }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function DropDownButton()
        {
            this.mouseEnabled = false;
            this.mouseChildren = true;
            this.dropDownController = new DropDownController();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function closeDropDown():void
        {
            if (isDropDownOpen)
                m_dropDownController.closeDropDown(true);
        }
        
        //--------------------------------------
        // Override Protected
        //--------------------------------------
        
        override protected function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName, instance);
            
            if (instance === openButton && m_dropDownController) {
                m_dropDownController.openButton = openButton;
            } else if (instance === dropDown && m_dropDownController) {
                m_dropDownController.dropDown = dropDown;
                dropDown.addEventListener(CloseEvent.CLOSE, widgetCloseHandler);
            } else if (instance === list) {
                list.dataProvider = dataProvider;
                list.addEventListener(IndexChangeEvent.CHANGE, listChangeHandler);
            }
        }
        
        override protected function getCurrentSkinState():String
        {
            if (enabled && isDropDownOpen)
                return "open";
            
            return super.getCurrentSkinState();
        }
        
        //--------------------------------------
        // Event Handlers
        //--------------------------------------
        
        protected function widgetCloseHandler(event:Event):void
        {
            m_dropDownController.closeDropDown(true);
        }
        
        protected function listChangeHandler(event:IndexChangeEvent):void
        {
            dispatchEvent(event);
        }
        
        protected function dropDownControllerOpenHandler(event:Event):void
        {
            addEventListener(FlexEvent.UPDATE_COMPLETE, open_updateCompleteHandler);
            invalidateSkinState();
        }
        
        protected function open_updateCompleteHandler(event:FlexEvent):void
        {
            removeEventListener(FlexEvent.UPDATE_COMPLETE, open_updateCompleteHandler);
            dispatchEvent(new DropDownEvent(DropDownEvent.OPEN));
        }
        
        protected function dropDownController_closeHandler(event:Event):void
        {
            addEventListener(FlexEvent.UPDATE_COMPLETE, close_updateCompleteHandler);
            invalidateSkinState();
        }
        
        protected function close_updateCompleteHandler(event:FlexEvent):void
        {   
            removeEventListener(FlexEvent.UPDATE_COMPLETE, close_updateCompleteHandler);
            dispatchEvent(new DropDownEvent(DropDownEvent.CLOSE));
        }
    }
}
