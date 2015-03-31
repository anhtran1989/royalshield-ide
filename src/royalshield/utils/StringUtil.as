package royalshield.utils
{
    import royalshield.errors.AbstractClassError;
    
    public final class StringUtil
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function StringUtil()
        {
            throw new AbstractClassError(StringUtil);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        private static const CHARS:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        private static const HEX_CHARS:String = "ABCDEF0123456789";
        
        public static function toKeyString(value:String):String
        {
            var key:String = removeWhitespaces( value.toLowerCase() );
            return key.replace(/_/g, "");
        }
        
        public static function removeWhitespaces(str:String):String
        {
            if (str == null) return null;
            return str.replace(/\s/g, "");
        }
        
        public static function format(str:String, ... rest):String
        {
            if (str == null) return "";
            
            var length:uint = rest.length;
            for (var i:uint = 0; i < length; i++)
                str = str.replace(new RegExp("\\{" + i + "\\}", "g"), rest[i]);
            
            return str;
        }
        
        public static function randomKeyString(length:uint = 8, hex:Boolean = false):String
        {
            var chars:String = hex ? HEX_CHARS : CHARS;
            var numChars:uint = chars.length - 1;
            var randomChar:String = "";
            
            for (var i:uint = 0; i < length; i++)
                randomChar += chars.charAt(Math.floor(Math.random() * numChars));
            
            return randomChar;
        }
        
        public static function capitaliseFirstLetter(text:String):String
        {
            if (!isNullOrEmpty(text))
                return text.substring(0, 1).toUpperCase() + text.substr(1, text.length - 1);
            
            return text;
        }
    }
}
