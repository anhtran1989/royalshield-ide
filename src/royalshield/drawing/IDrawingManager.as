package royalshield.drawing
{
    import flash.events.IEventDispatcher;
    
    public interface IDrawingManager extends IEventDispatcher
    {
        function addTarget(target:IDrawingTarget):void;
    }
}
