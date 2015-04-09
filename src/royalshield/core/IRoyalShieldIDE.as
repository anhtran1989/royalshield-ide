package royalshield.core
{
    import mx.core.IUIComponent;
    import mx.core.IWindow;
    
    import royalshield.brushes.IBrushManager;
    import royalshield.drawing.IDrawingManager;
    import royalshield.edition.IEditorManager;
    import royalshield.settings.ISettingsManager;
    
    public interface IRoyalShieldIDE extends IUIComponent, IWindow
    {
        function get settingsManager():ISettingsManager;
        function get brushManager():IBrushManager;
        function get drawingManager():IDrawingManager;
        function get editorManager():IEditorManager;
        
        function cancelClosing():void;
    }
}
