package royalshield.brushes
{
    import flash.events.IEventDispatcher;
    
    import mx.managers.ICursorManager;
    
    import royalshield.drawing.IDrawingTarget;
    
    public interface IBrushManager extends IEventDispatcher
    {
        function get target():IDrawingTarget;
        function set target(value:IDrawingTarget):void;
        
        function get isOver():Boolean;
        function set isOver(value:Boolean):void;
        
        function get brushType():String;
        function set brushType(value:String):void;
        
        function get brush():IBrush;
        
        function get itemId():uint;
        function set itemId(value:uint):void;
        
        function get size():uint;
        function set size(value:uint):void;
        
        function get cursorManager():ICursorManager;
        function set cursorManager(value:ICursorManager):void;
        
        function doPress(x:uint, y:uint):void;
        function doMove(x:uint, y:uint):void;
        function doDrag(x:uint, y:uint):void;
        function doRelease(x:uint, y:uint):void;
        
        function showCursor():void;
        function hideCursor():void;
        function invalidateCursor():void;
    }
}
