package royalshield.assets
{
    import flash.display.Bitmap;
    
    import royalshield.core.GameAssets;
    import royalshield.entities.items.Ground;
    import royalshield.entities.items.Item;
    import royalshield.errors.SingletonClassError;
    import royalshield.graphics.Graphic;
    import royalshield.graphics.GraphicType;
    
    public class AssetsManager
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        // TODO temporary
        private var m_item:Item;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function AssetsManager()
        {
            if (s_instance)
                throw new SingletonClassError(AssetsManager);
            
            s_instance = this;
            
            m_item = createDefaultItem();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function getItem(id:uint):Item
        {
            return m_item;
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function createDefaultItem():Item
        {
            var type:GraphicType = new GraphicType();
            type.patternX = 4;
            type.patternY = 3;
            type.spriteSheet = GameAssets.getInstance().getSpriteSheet(type, Bitmap(new GROUND_TEXTURE).bitmapData);
            
            var ground:Ground = new Ground(0, "ground", 100);
            ground.graphic = new Graphic(type);
            return ground;
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        // TODO: temporary textures
        [Embed(source="../assets/ground.png", mimeType="image/png")]
        public static const GROUND_TEXTURE:Class;
        
        private static var s_instance:AssetsManager;
        public static function getInstance():AssetsManager
        {
            if (!s_instance)
                new AssetsManager();
            
            return s_instance;
        }
    }
}
