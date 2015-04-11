package royalshield.drawing
{
    import flash.utils.Dictionary;
    
    import royalshield.world.Tile;
    
    [ExcludeClass]
    public class SelectedTiles
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_slots:Dictionary;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function SelectedTiles()
        {
            m_slots = new Dictionary();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function addTile(tile:Tile, target:IDrawingTarget):void
        {
            this.getSlot(target, true).addTile(tile);
        }
        
        public function hasTile(tile:Tile, target:IDrawingTarget):Boolean
        {
            var slot:Slot = getSlot(target);
            return slot ? slot.hasTile(tile) : false;
        }
        
        public function getList(target:IDrawingTarget):Dictionary
        {
            var slot:Slot = getSlot(target);
            return slot ? slot.tiles : null;
        }
        
        public function clear(target:IDrawingTarget):void
        {
            var slot:Slot = getSlot(target);
            if (slot) {
                slot.dispose();
                delete m_slots[target];
            }
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function getSlot(target:IDrawingTarget, create:Boolean = false):Slot
        {
            if (m_slots[target] !== undefined)
                return Slot(m_slots[target]);
            else if (create) {
                var slot:Slot = new Slot();
                m_slots[target] = slot;
                return slot;
            }
            
            return null;
        }
    }
}

// ******************************************************************************
// HELPER CLASS
// ******************************************************************************

import flash.utils.Dictionary;

import royalshield.world.Tile;

class Slot
{
    //--------------------------------------------------------------------------
    // PROPERTIES
    //--------------------------------------------------------------------------
    
    private var m_tiles:Dictionary;
    private var m_length:uint;
    
    //--------------------------------------------------------------------------
    // PROPERTIES
    //--------------------------------------------------------------------------
    
    public function get tiles():Dictionary { return m_tiles; }
    public function get length():uint { return m_length; }
    
    //--------------------------------------------------------------------------
    // CONSTRUCTOR
    //--------------------------------------------------------------------------
    
    public function Slot()
    {
        m_tiles = new Dictionary();
    }
    
    //--------------------------------------------------------------------------
    // METHODS
    //--------------------------------------------------------------------------
    
    //--------------------------------------
    // Public
    //--------------------------------------
    
    public function addTile(tile:Tile):void
    {
        if (m_tiles[tile] === undefined) {
            m_tiles[tile] = true;
            m_length++;
        }
    }
    
    public function hasTile(tile:Tile):Boolean
    {
        return (m_tiles[tile] !== undefined);
    }
    
    public function removeTile(tile:Tile):void
    {
        if (m_tiles[tile] !== undefined) {
            delete m_tiles[tile];
            m_length--;
        }
    }
    
    public function dispose():void
    {
        m_tiles = null;
        m_length = 0;
    }
}
