package royalshield.utils
{
    import flash.desktop.NativeApplication;
    
    import royalshield.errors.AbstractClassError;
    
    public final class DescriptorUtil
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function DescriptorUtil()
        {
            throw new AbstractClassError(DescriptorUtil);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //---------------------------------------------------------------------------
        
        public static function getXML():XML
        {
            return NativeApplication.nativeApplication.applicationDescriptor;
        }
        
        public static function getNamespace():Namespace
        {
            return getXML().namespace();
        }
        
        public static function getName():String
        {
            var ns:Namespace = getNamespace();
            
            if (getXML().ns::name[0] === undefined)
                return getXML().ns::filename[0].toString();
            
            return getXML().ns::name[0].toString();
        }
        
        public static function getID():String
        {
            var ns:Namespace = getNamespace();
            return getXML().ns::id[0].toString();
        }
        
        public static function getVersionNumber():String
        {
            var ns:Namespace = getNamespace();
            return getXML().ns::versionNumber[0].toString();
        }
        
        public static function getVersionLabel():String
        {
            var ns:Namespace = getNamespace();
            var xml:XML = getXML();
            
            if (xml.ns::versionLabel[0] === undefined)
                return getVersionNumber();
            
            return xml.ns::versionLabel;
        }
        
        public static function getCopyright():String
        {
            var ns:Namespace = getNamespace();
            var xml:XML = getXML();
            
            if (xml.ns::copyright[0] === undefined)
                return "";
                
            return xml.ns::copyright[0].toString();
        }
        
        public static function getIconUrl(iconSize:uint):String
        {	
            var icons:XML = getIconsXML();
            if (icons) {
                var ns:Namespace = icons.namespace();
                var tag:String = StringUtil.format("image{0}x{1}", iconSize, iconSize);
                
                if (icons.ns::[tag] !== undefined)
                    return icons.ns::[tag].toString();
            }
            return null;
        }
        
        public static function getIconsXML():XML
        {
            var ns:Namespace = getNamespace();
            return getXML().ns::icon[0];
        }
    }
}
