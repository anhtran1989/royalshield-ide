package royalshield.history
{
    import royalshield.errors.NullOrEmptyArgumentError;
    import royalshield.utils.isNullOrEmpty;
    import royalshield.world.Tile;
    
    public class TileMapHistoryAction implements IHistoryAction
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_tiles:Vector.<Tile>;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get tiles():Vector.<Tile> { return m_tiles; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function TileMapHistoryAction(tiles:Vector.<Tile>)
        {
            if (isNullOrEmpty(tiles))
                throw new NullOrEmptyArgumentError("tiles");
            
            m_tiles = tiles;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function dispose():void
        {
            m_tiles = null;
        }
    }
}
