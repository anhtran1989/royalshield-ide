package royalshield.history
{
    import royalshield.errors.SingletonClassError;
    import royalshield.geom.Position;
    import royalshield.world.IWorldMap;
    import royalshield.world.Tile;
    
    public class RSHistoryManager extends HistoryManager
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var map:IWorldMap;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function RSHistoryManager()
        {
            super(20);
            
            if (s_instance)
                throw new SingletonClassError(RSHistoryManager);
            
            s_instance = this;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Override Protected
        //--------------------------------------
        
        override protected function onUndo(action:IHistoryAction):void
        {
            if (action is MapHistoryAction)
                onMapUndo(action as MapHistoryAction);
        }
        
        override protected function onRedo(action:IHistoryAction):void
        {
            if (action is MapHistoryAction)
                onMapRedo(action as MapHistoryAction);
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function onMapUndo(action:MapHistoryAction):void
        {
            var newPos:Position = action.newPosition;
            if (newPos) {
                var newTile:Tile = map.getTile(newPos.x, newPos.y, newPos.z);
                if (newTile) {
                    newTile.removeItem(action.item);
                    if (newTile.itemCount == 0)
                        map.deleteTile(newTile);
                }
            }
            
            var oldPos:Position = action.oldPosition;
            if (oldPos) {
                var oldtile:Tile = map.setTile(oldPos.x, oldPos.y, oldPos.z);
                if (oldtile)
                    oldtile.addItem(action.item);
            }
        }
        
        private function onMapRedo(action:MapHistoryAction):void
        {
            var oldPos:Position = action.oldPosition;
            if (oldPos) {
                var oldtile:Tile = map.getTile(oldPos.x, oldPos.y, oldPos.z);
                if (oldtile) {
                    oldtile.removeItem(action.item);
                    
                    if (oldtile.itemCount == 0)
                        map.deleteTile(oldtile);
                }
            }
            
            var newPos:Position = action.newPosition;
            if (newPos) {
                var newTile:Tile = map.setTile(newPos.x, newPos.y, newPos.z);
                if (newTile)
                    newTile.addItem(action.item);
            }
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static private var s_instance:RSHistoryManager;
        static public function getInstance():RSHistoryManager
        {
            if (!s_instance)
                new RSHistoryManager();
            
            return s_instance;
        }
    }
}
