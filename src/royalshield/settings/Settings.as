package royalshield.settings
{
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
    import royalshield.errors.NullArgumentError;
    import royalshield.utils.DescriptorUtil;
    
    public class Settings implements ISettings
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_application:String;
        private var m_version:String;
        private var m_type:String;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get settingsApplicationName():String { return m_application; }
        public function get settingsApplicationVersion():String { return m_version; }
        public function get settingsClassType():String { return m_type; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Settings()
        {
            m_type = describeType(this).@name;
            
            var index:int = m_type.indexOf("::");
            
            if (index != -1)
                m_type = m_type.substr(index + 2);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function serialize():XML
        {
            var describe:XML = describeType(this);
            
            var xml:XML = <settings/>;
            xml.@application = getName();
            xml.@version = getVersionNumber();
            xml.@type = describe.@name;
            
            var properties:XMLList = describe.variable;
            
            for each (var property:XML in properties) {
                
                var name:String = property.@name;
                var type:String = property.@type;
                var value:* = this[name];
                var node:XML = createXMLNode(name);
                
                switch (type)
                {
                    case "int":
                    case "uint":
                    case "Number":
                    case "Boolean":
                        node.appendChild(value);
                        break;
                    case "String":
                        if (value != null && value.length != 0) node.appendChild(value);
                        break;
                    case "Array":
                        createArrayXML(node, value);
                        break;
                }
                
                xml.appendChild(node);
            }
            
            return xml;
        }
        
        public function unserialize(xml:XML):Boolean
        {
            if (!xml)
                throw new NullArgumentError("xml");
            
            if (xml.localName() != "settings")
                throw new Error("Settings.unserialize: Invalid settings XML.");
            
            if (!xml.hasOwnProperty("@application"))
                throw new Error("Settings.unserialize: Missing 'application' attribute.");
            
            if (!xml.hasOwnProperty("@version"))
                throw new Error("Settings.unserialize: Missing 'version' attribute.");
            
            if (!xml.hasOwnProperty("@type"))
                throw new Error("Settings.unserialize: Missing 'type' attribute.");
            
            if (xml.@type != getQualifiedClassName(this))
                return false;
            
            m_application = xml.@application;
            m_version = xml.@version;
            
            var describe:XML = describeType(this);
            var properties:XMLList = describe.variable;
            
            for each (var property:XML in properties)
            {
                var name:String = property.@name;
                var type:String = property.@type;
                
                if (xml.hasOwnProperty(name))
                    this[name] = getValue(xml[name], getDefinitionByName(type) as Class);
            }
            return true;
        }
        
        //--------------------------------------
        // Protected
        //--------------------------------------
        
        protected function getName():String
        {
            return DescriptorUtil.getName();
        }
        
        protected function getVersionNumber():String 
        {
            return DescriptorUtil.getVersionNumber();
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function createXMLNode(name:String):XML
        {
            var node:XML = <node/>;
            node.setName(name);
            return node;
        }
        
        private function createArrayXML(node:XML, array:Array):void
        {
            if (array) {
                
                var length:uint = array.length;
                
                for (var i:uint = 0; i < length; i++) 
                {
                    var object:XML = <object/>;
                    
                    var value:* = array[i];
                    if (value is String)
                        object.@type = "String";
                    else if (value is int)
                        object.@type = "int";
                    else if (value is uint)
                        object.@type = "uint";
                    else if (value is Number)
                        object.@type = "Number";
                    else if (value is Boolean)
                        object.@type = "Boolean";
                    else
                        continue;
                    
                    object.@value = value;
                    node.appendChild(object);
                }
            }
        }
        
        private function getValue(str:String, type:Class):*
        {
            switch (type)
            {
                case int:
                    return int(str);
                    
                case uint:
                    return uint(str);
                    
                case Number:
                    return Number(str);
                    
                case String:
                    return str;
                    
                case Boolean:
                    return str == "true" ? true : false;
                    
                case Array:
                    return getArray(XML(str));
                    
                default:
                    throw new ArgumentError("Settings.getValue: Unsupported type: " + type);
            }
            return null;
        }
        
        private function getArray(xml:XML):Array
        {
            var array:Array = [];
            for each(var object:XML in xml.object)
                array.push( getValue(object.@value, getDefinitionByName(object.@type) as Class) );
            
            return array;
        }
    }
}
