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
        
        function onMoveMapNorth():void;
        function onMoveMapSouth():void;
        function onMoveMapWest():void;
        function onMoveMapEast():void;
        function onLayerUp():void;
        function onLayerDown():void;
        function onCentralizeMap():void;
    }
}
