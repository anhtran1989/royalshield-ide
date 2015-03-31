package royalshield.settings
{
    public interface ISettingsManager
    {
        function loadSettings(settings:ISettings):Boolean;
        function saveSettings(settings:ISettings):Boolean;
    }
}
