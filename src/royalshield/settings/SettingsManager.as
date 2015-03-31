package royalshield.settings
{
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    
    import royalshield.errors.NullArgumentError;
    import royalshield.errors.SingletonClassError;
    
    public final class SettingsManager implements ISettingsManager
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_directory:File;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function SettingsManager()
        {
            if (s_instance)
                throw new SingletonClassError(SettingsManager);
            
            s_instance = this;
            m_directory = File.applicationStorageDirectory.resolvePath("settings");
            m_directory.createDirectory();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function loadSettings(settings:ISettings):Boolean
        {
            if (!settings)
                throw new NullArgumentError("settings");
            
            var type:String = settings.settingsClassType;
            var file:File = m_directory.resolvePath(type + ".xml");
            if (!file.exists)
                return false;
            
            var xml:XML;
            
            try
            {
                var stream:FileStream = new FileStream();
                stream.open(file, FileMode.READ);
                xml = XML( stream.readUTFBytes(stream.bytesAvailable) );
                stream.close();
            }
            catch (error:Error)
            {
                return false;
            }
            return settings.unserialize(xml);
        }
        
        public function saveSettings(settings:ISettings):Boolean
        {
            if (!settings)
                throw new NullArgumentError("settings");
            
            var type:String = settings.settingsClassType;
            var xml:XML = settings.serialize();
            var file:File = m_directory.resolvePath(type + ".xml");
            var stream:FileStream = new FileStream();
            stream.open(file, FileMode.WRITE);
            stream.writeUTFBytes( xml.toXMLString() );
            stream.close();
            
            return true;
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        private static var s_instance:ISettingsManager;
        public static function getInstance():ISettingsManager
        {
            if (!s_instance)
                new SettingsManager();
            
            return s_instance;
        }
    }
}
