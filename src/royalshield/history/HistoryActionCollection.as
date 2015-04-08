package royalshield.history
{
    import flash.events.EventDispatcher;
    
    import royalshield.errors.NullArgumentError;
    import royalshield.events.HistoryEvent;
    import royalshield.utils.IDisposable;
    
    [Event(name="collectionChange", type="royalshield.events.HistoryEvent")]
    
    public class HistoryActionCollection extends EventDispatcher implements IDisposable
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_actionList:Vector.<HistoryActionGroup>;
        private var m_actionIndex:int;
        private var m_maxLength:uint;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get length():uint { return m_actionList.length; }
        
        public function get index():int { return m_actionIndex; }
        public function set index(value:int):void
        {
            if (m_actionIndex != value) {
                m_actionIndex = value;
                dispatchEvent(new HistoryEvent(HistoryEvent.COLLECTION_CHANGE));
            }
        }
        
        public function get maxLength():uint { return m_maxLength; }
        public function set maxLength(value:uint):void { m_maxLength = value; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function HistoryActionCollection(maxLength:uint = 10)
        {
            m_actionList = new Vector.<HistoryActionGroup>();
            m_actionIndex = 0;
            m_maxLength = Math.max(1, maxLength);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function addGroup(group:HistoryActionGroup):void
        {
            if (!group)
                throw new NullArgumentError("group");
            
            var startIndex:int = (m_actionIndex + 1);
            if (startIndex < m_actionList.length) {
                var deleteCount:int = m_actionList.length - startIndex;
                var list:Vector.<HistoryActionGroup>  = m_actionList.splice(startIndex, deleteCount);
                var i:int = list.length - 1;
                while (i > 0) {
                    var temp:HistoryActionGroup = list[i];
                    temp.dispose();
                    i--;
                }
            }
            
            m_actionList[m_actionList.length] = group;
            if (m_actionList.length > m_maxLength) {
                while (m_actionList.length > m_maxLength) {
                    temp = m_actionList.shift();
                    temp.dispose();
                }
            }
            
            this.index = m_actionList.length - 1;
        }
        
        public function getGroup(index:int):HistoryActionGroup
        {
            if (index < 0 || index >= m_actionList.length)
                return null;
            
            return HistoryActionGroup(m_actionList[index]);
        }
        
        public function getCurrentAction():HistoryActionGroup
        {
            return getGroup(m_actionIndex);
        }
        
        public function dispose():void
        {
            for each (var actionroup:HistoryActionGroup in m_actionList)
                actionroup.dispose();
            
            m_actionList.length = 0;
            m_actionIndex = -1;
        }
    }
}
