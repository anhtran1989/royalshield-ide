package royalshield.history
{
    public class PropertyHistoryAction implements IHistoryAction
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_target:Object;
        private var m_property:String;
        private var m_oldValue:Object;
        private var m_newValue:Object;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get target():Object { return m_target; }
        public function get property():String { return m_property; }
        public function get oldValue():Object { return m_oldValue; }
        public function get newValue():Object { return m_newValue; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function PropertyHistoryAction(target:Object, property:String, oldValue:Object, newValue:Object)
        {
            m_target = target;
            m_property = property;
            m_oldValue = oldValue;
            m_newValue = newValue;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Override Public
        //--------------------------------------
        
        public function dispose():void
        {
            m_target = null;
            m_property = null;
        }
    }
}
