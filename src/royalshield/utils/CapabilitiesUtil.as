package royalshield.utils
{
    import flash.system.Capabilities;
    
    import royalshield.errors.AbstractClassError;
    
    public final class CapabilitiesUtil
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function CapabilitiesUtil()
        {
            throw new AbstractClassError(CapabilitiesUtil);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static function get isWin():Boolean
        {
            return (Capabilities.os.indexOf("Windows") >= 0);
        }
        
        public static function get isMac():Boolean
        {
            return (Capabilities.os.indexOf("Mac OS") >= 0);
        }
        
        public static function get isLinux():Boolean
        {
            return (Capabilities.os.indexOf("Linux") >= 0);
        }
    }
}
