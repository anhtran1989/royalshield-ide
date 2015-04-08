package royalshield.history
{
    import flash.events.IEventDispatcher;
    
    public interface IHistoryManager extends IEventDispatcher
    {
        function get canUndo():Boolean;
        function get canRedo():Boolean;
        function get collection():HistoryActionCollection;
        
        function addActionGroup(actionGroup:HistoryActionGroup, ... rest):void;
        function undo(indices:uint = 1):void;
        function redo(indices:uint = 1):void;
        function dispose():void;
    }
}
