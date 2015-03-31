package royalshield.brushes
{
    import royalshield.errors.AbstractClassError;

    public final class BrushType
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function BrushType()
        {
            throw new AbstractClassError(BrushType);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static const BRUSH:String = "brush";
        public static const ERASER:String = "eraser";
    }
}
