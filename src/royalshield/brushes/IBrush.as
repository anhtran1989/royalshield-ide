package royalshield.brushes
{
    import royalshield.utils.IDisposable;
    
    public interface IBrush extends IDisposable
    {
        function get type():String;
        
        function get itemId():uint;
        function set itemId(value:uint):void;
        
        function get size():uint;
        function set size(value:uint):void;
        
        function get brushManager():IBrushManager;
        function set brushManager(value:IBrushManager):void;
        
        function doPress(x:uint, y:uint):void;
        function doMove(x:uint, y:uint):void;
        function doDrag(x:uint, y:uint):void;
        function doRelease(x:uint, y:uint):void;
        function showCursor():void;
        function hideCursor():void;
    }
}
