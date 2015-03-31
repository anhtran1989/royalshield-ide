package royalshield.settings
{
    public interface ISettings
    {
        function get settingsApplicationName():String;
        function get settingsApplicationVersion():String;
        function get settingsClassType():String;
            
        function serialize():XML;
        function unserialize(xml:XML):Boolean;
    }
}
