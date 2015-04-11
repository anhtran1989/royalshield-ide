package royalshield.edition
{
    import flash.events.IEventDispatcher;
    
    import royalshield.history.IHistoryManager;
    import royalshield.world.IWorldMap;
    
    public interface IEditorManager extends IEventDispatcher
    {
        function get currentEditor():IMapEditor;
        function set currentEditor(value:IMapEditor):void;
        
        function get currentMap():IWorldMap;
        
        function get currentHistoryManager():IHistoryManager;
        
        function get canUndo():Boolean;
        function get canRedo():Boolean;
        
        function get canZoomIn():Boolean;
        function get canZoomOut():Boolean;
        
        function get showGrid():Boolean;
        function set showGrid(value:Boolean):void;
        
        function get showMouseTile():Boolean;
        function set showMouseTile(value:Boolean):void;
        
        function get editorCount():uint;
        
        function get waiting():Boolean;
        
        function get changed():Boolean;
        
        function createMap(name:String, width:uint, height:uint, layers:uint):IMapEditor;
        function createEditor(map:IWorldMap):IMapEditor;
        function removeEditor(editor:IMapEditor):void;
        function removeCurrentEditor():void;
        function removeAll(checkSave:Boolean = true):void;
        function getEditor(map:IWorldMap):IMapEditor;
        function saveEditor(editor:IMapEditor):void;
        
        function undo():void;
        function redo():void;
        
        function zoomIn():void;
        function zoomOut():void;
        
        function createUntitledName():String;
    }
}
