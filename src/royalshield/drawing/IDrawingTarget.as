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
        
        function get zoom():Number;
        function set zoom(value:Number):void;
    }
}
