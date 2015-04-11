package royalshield.edition
{
    import flash.events.IEventDispatcher;
    import flash.geom.Point;
    
    import mx.core.INavigatorContent;
    import mx.managers.IFocusManagerComponent;
    
    import royalshield.components.WorldMapDisplay;
    import royalshield.history.IHistoryManager;
    import royalshield.utils.IDisposable;
    import royalshield.world.IWorldMap;
    
    public interface IMapEditor extends IEventDispatcher, INavigatorContent, IFocusManagerComponent, IDisposable
    {
        function get map():IWorldMap;
        function set map(value:IWorldMap):void;
        
        function get display():WorldMapDisplay;
        
        function get scrollPoint():Point;
        
        function get historyManager():IHistoryManager;
        
        function get changed():Boolean;
        
        function moveMapNorth():void;
        function moveMapSouth():void;
        function moveMapWest():void;
        function moveMapEast():void;
        function layerUp():void;
        function layerDown():void;
        function centralizeMap():void;
        
        function zoomIn():void;
        function zoomOut():void;
    }
}
