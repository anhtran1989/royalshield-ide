package royalshield.brushes
{
    import flash.events.IEventDispatcher;
    
    import mx.managers.ICursorManager;
    
    import royalshield.drawing.IDrawingTarget;
    
    public interface IBrushManager extends IEventDispatcher
    {
        function get brushType():String;
        function set brushType(value:String):void;
        
        function get itemId():uint;
        function set itemId(value:uint):void;
        
        function get cursorManager():ICursorManager;
        function set cursorManager(value:ICursorManager):void;
        
        function doPress(target:IDrawingTarget, x:uint, y:uint):void;
        function doDrag(x:uint, y:uint):void;
        function doMove(x:uint, y:uint):void;
        function doRelease(x:uint, y:uint):void;
    }
}
