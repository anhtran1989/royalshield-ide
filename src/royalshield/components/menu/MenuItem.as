package royalshield.components.menu
{
    import royalshield.errors.NullArgumentError;
    import royalshield.utils.CapabilitiesUtil;
    import royalshield.utils.isNullOrEmpty;
    
    public class MenuItem
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var label:String;
        public var data:String;
        public var keyEquivalent:String;
        public var altKey:Boolean;
        public var controlKey:Boolean;
        public var shiftKey:Boolean;
        public var isSeparator:Boolean;
        public var isCheck:Boolean;
        public var toggled:Boolean;
        public var enabled:Boolean;
        public var items:Array;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function MenuItem(label:String = null)
        {
            this.label = label;
            this.enabled = true;
            this.items = [];
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function serialize():XML
        {
            var xml:XML = <menuitem/>;
            
            if (!isNullOrEmpty(label))
                xml.@label = label;
            else
                isSeparator = true;
            
            if (!isNullOrEmpty(data))
                xml.@data = data;
            
            if (!isNullOrEmpty(keyEquivalent)) {
                var key:String = keyEquivalent.toLowerCase();
                if (key.length > 1 && key.charAt(0) == "f")
                    key = key.toUpperCase();
                    
                xml.@keyEquivalent = key;
            }
            
            if (altKey)
                xml.@altKey = altKey;
            
            if (controlKey) {
                if (CapabilitiesUtil.isMac)
                    xml.@commandKey = controlKey;
                else
                    xml.@controlKey = controlKey;
            }
            
            if (shiftKey)
                xml.@shiftKey = shiftKey;
            
            if (isSeparator) {
                xml.@type = "separator";
            } else if (isCheck) {
                xml.@type = "check";
                xml.@toggled = toggled;
            }
            
            if (!enabled)
                xml.@enabled = enabled;
            
            if (items) {
                var length:uint = items.length;
                for (var i:uint = 0; i < length; i++)
                    xml.appendChild( items[i].serialize() );
            }
            return xml;
        }
        
        public function addMenuItem(item:MenuItem):void
        {
            if (!item)
                throw new NullArgumentError("item");
            
            if (!items)
                items = [];
            
            items[items.length] = item;
        }
    }
}
