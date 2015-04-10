package royalshield.utils
{
    import royalshield.errors.AbstractClassError;
    
    public final class DialogDetail
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function DialogDetail()
        {
            throw new AbstractClassError(DialogDetail);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static const CANCEL:uint     = 0;
        public static const OK:uint         = 1 << 1;
        public static const CONFIRM:uint    = 1 << 2;
        public static const YES:uint        = 1 << 3;
        public static const YES_TO_ALL:uint = 1 << 4;
        public static const NO:uint         = 1 << 5;
    }
}
