package royalshield.utils
{
    import flash.display.Screen;
    import flash.geom.Rectangle;
    
    import mx.core.IWindow;
    
    import royalshield.errors.AbstractClassError;
    
    public final class WindowUtil
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function WindowUtil()
        {
            throw new AbstractClassError(WindowUtil);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static function centralizeWindowOnScreen(window:IWindow):void
        {
            if (window) {
                var screenBounds:Rectangle = Screen.mainScreen.bounds;
                window.nativeWindow.x = (screenBounds.width - window.nativeWindow.width) * 0.5;
                window.nativeWindow.y = (screenBounds.height - window.nativeWindow.height) * 0.5;
            }
        }
    }
}
