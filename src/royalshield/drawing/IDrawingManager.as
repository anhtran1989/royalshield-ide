package royalshield.drawing
{
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;
    
    public interface IDrawingManager extends IEventDispatcher
    {
        function get currentTarget():IDrawingTarget;
        function get selectedTiles():Dictionary;
        function get selectedTileCount():uint;
        
        function addTarget(target:IDrawingTarget):void;
        function removeTarget(target:IDrawingTarget):void;
        function onDeleteSelectedTiles():void;
    }
}
