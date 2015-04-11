package royalshield.drawing
{
    import flash.events.IEventDispatcher;
    
    
    public interface IDrawingManager extends IEventDispatcher
    {
        function get currentTarget():IDrawingTarget;
        function get selectedTiles():SelectedTiles
        
        function addTarget(target:IDrawingTarget):void;
        function removeTarget(target:IDrawingTarget):void;
        function onDeleteSelectedTiles():void;
    }
}
