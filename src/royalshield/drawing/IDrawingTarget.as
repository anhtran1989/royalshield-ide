package royalshield.drawing
{
    import flash.events.IEventDispatcher;
    
    import royalshield.world.IWorldMap;
    
    public interface IDrawingTarget extends IEventDispatcher
    {
        function get worldMap():IWorldMap;
        
        function get mouseMapX():uint;
        function get mouseMapY():uint;
        function get mouseMapZ():uint;
        
        function get mouseDownX():uint;
        function get mouseDownY():uint;
        
        function get mouseDown():Boolean;
        function get ctrlDown():Boolean;
        function get shiftDown():Boolean;
        
        function get zoom():Number;
        function set zoom(value:Number):void;
        
        function draw():void;
    }
}
