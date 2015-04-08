package royalshield.history
{
    import royalshield.errors.NullArgumentError;
    import royalshield.utils.IDisposable;
    
    public class HistoryActionGroup implements IDisposable
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_description:String;
        private var m_list:Vector.<IHistoryAction>;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get length():uint { return m_list.length; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function HistoryActionGroup(description:String)
        {
            m_description = description;
            m_list = new Vector.<IHistoryAction>();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function toString():String
        {
            return m_description;
        }
        
        public function addAction(action:IHistoryAction):void
        {
            if (!action)
                throw new NullArgumentError("action");
            
            m_list[m_list.length] = action;
        }
        
        public function getActionAt(index:uint):IHistoryAction
        {
            if (index < m_list.length)
                return m_list[index];
            
            return null;
        }
        
        public function dispose():void
        {
            for each (var action:IHistoryAction in m_list)
                action.dispose();
            
            m_list.length = 0;
        }
    }
}
