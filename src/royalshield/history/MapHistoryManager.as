package royalshield.history
{
    import royalshield.entities.items.Item;
    import royalshield.geom.Position;
    import royalshield.world.IWorldMap;
    import royalshield.world.Tile;
    
    public class MapHistoryManager extends HistoryManager
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var map:IWorldMap;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function MapHistoryManager()
        {
            super(20);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Override Protected
        //--------------------------------------
        
        override protected function onUndo(action:IHistoryAction):void
        {
            if (action is ItemMapHistoryAction)
                onItemMapUndo(action as ItemMapHistoryAction);
            else if (TileMapHistoryAction(action))
                onTileMapUndo(TileMapHistoryAction(action));
        }
        
        override protected function onRedo(action:IHistoryAction):void
        {
            if (action is ItemMapHistoryAction)
                onItemMapRedo(ItemMapHistoryAction(action));
            else if (TileMapHistoryAction(action))
                onTileMapRedo(TileMapHistoryAction(action));
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function onItemMapUndo(action:ItemMapHistoryAction):void
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
        
        private function onItemMapRedo(action:ItemMapHistoryAction):void
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
        
        private function onTileMapUndo(action:TileMapHistoryAction):void
        {
            var tiles:Vector.<Tile> = action.tiles;
            if (tiles) {
                var length:uint = tiles.length;
                for (var t:uint = 0; t < length; t++) {
                    var oldTile:Tile = tiles[t];
                    if (oldTile && oldTile.itemCount > 0) {
                        var newTile:Tile = map.setTile(oldTile.x, oldTile.y, oldTile.z);
                        for (var i:uint = 0; i < oldTile.itemCount; i++) {
                            var item:Item = oldTile.getItemAt(i);
                            newTile.addItem(item);
                        }
                    }
                }
            }
        }
        
        private function onTileMapRedo(action:TileMapHistoryAction):void
        {
            var tiles:Vector.<Tile> = action.tiles;
            if (tiles) {
                var length:uint = tiles.length;
                for (var i:uint = 0; i < length; i++) {
                    var oldTile:Tile = tiles[i];
                    if (oldTile)
                        map.deleteTileAt(oldTile.x, oldTile.y, oldTile.z);
                }
            }
        }
    }
}
