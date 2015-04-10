package royalshield.managers
{
    import flash.desktop.NotificationType;
    import flash.events.Event;
    import flash.events.NativeWindowDisplayStateEvent;
    
    import mx.core.FlexGlobals;
    import mx.events.AIREvent;
    import mx.events.CloseEvent;
    
    import spark.components.Application;
    import spark.components.Window;
    
    import royalshield.errors.AbstractClassError;
    import royalshield.errors.NullArgumentError;
    import royalshield.utils.WindowUtil;
    
    public final class PopUpWindowManager
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function PopUpWindowManager()
        {
            throw new AbstractClassError(PopUpWindowManager);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static private var s_currentWindow:Window;
        static public function get currentWindow():Window { return s_currentWindow; }
        
        static public function addWindow(window:Window, centralize:Boolean = true):void
        {
            if (!window)
                throw new NullArgumentError("window");
            
            if (s_currentWindow == window || !window.nativeWindow)
                return;
            
            if (s_currentWindow) {
                s_currentWindow.removeEventListener(CloseEvent.CLOSE, windowCloseHandler);
                s_currentWindow.close();
            }
            
            s_currentWindow = window;
            s_currentWindow.addEventListener(CloseEvent.CLOSE, windowCloseHandler);
            
            if (centralize)
                WindowUtil.centralizeWindowOnScreen(s_currentWindow);
            
            addApplicationEventHandlers();
        }
        
        static private function addApplicationEventHandlers():void
        {
            var app:Application = Application(FlexGlobals.topLevelApplication);
            app.mouseEnabled = false;
            app.mouseChildren = false;
            app.addEventListener(AIREvent.WINDOW_ACTIVATE, applicationWindowActivateHandler);
            app.addEventListener(CloseEvent.CLOSE, applicationCloseHandler);
            app.addEventListener(Event.CLOSING, applicationClosingHandler);
            app.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, applicationDisplayStateHandler);
        }
        
        static private function removeApplicationEventHandlers():void
        {
            var app:Application = Application(FlexGlobals.topLevelApplication);
            app.mouseEnabled = true;
            app.mouseChildren = true;
            app.removeEventListener(AIREvent.WINDOW_ACTIVATE, applicationWindowActivateHandler);
            app.removeEventListener(CloseEvent.CLOSE, applicationCloseHandler);
            app.removeEventListener(Event.CLOSING, applicationClosingHandler);
        }
        
        static private function applicationDisplayStateHandler(event:NativeWindowDisplayStateEvent):void
        {
            if (!s_currentWindow)
                removeApplicationEventHandlers();
            else
                event.preventDefault();
        }
        
        static private function applicationClosingHandler(event:Event):void
        {
            if (!s_currentWindow)
                removeApplicationEventHandlers();
            else
                event.preventDefault();
        }
        
        static private function applicationWindowActivateHandler(event:AIREvent):void
        {
            if (!s_currentWindow) {
                removeApplicationEventHandlers();
            } else if (!s_currentWindow.closed && s_currentWindow.stage) {
                s_currentWindow.orderToFront();
                s_currentWindow.activate();
                s_currentWindow.setFocus();
                s_currentWindow.nativeWindow.notifyUser(NotificationType.INFORMATIONAL);
            }
        }
        
        static private function applicationCloseHandler(event:Event):void
        {
            if (s_currentWindow)
                s_currentWindow.close();
        }
        
        static private function windowCloseHandler(event:Event):void
        {
            s_currentWindow.removeEventListener(CloseEvent.CLOSE, windowCloseHandler);
            s_currentWindow = null;
            removeApplicationEventHandlers();
        }
    }
}
