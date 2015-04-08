package royalshield.drawing
{
    import flash.events.IEventDispatcher;
    
    public interface IDrawingManager extends IEventDispatcher
    {
        function get currentTarget():IDrawingTarget;
        
        function addTarget(target:IDrawingTarget):void;
    }
}
