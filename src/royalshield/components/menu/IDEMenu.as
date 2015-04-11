package royalshield.components.menu
{
    import flash.events.Event;
    
    import mx.controls.FlexNativeMenu;
    import mx.core.FlexGlobals;
    import mx.events.FlexEvent;
    import mx.events.FlexNativeMenuEvent;
    
    import royalshield.core.IRoyalShieldIDE;
    import royalshield.events.MenuEvent;
    import royalshield.utils.CapabilitiesUtil;
    import royalshield.utils.DescriptorUtil;
    
    [Event(name="selected", type="royalshield.events.MenuEvent")]
    
    public class IDEMenu extends FlexNativeMenu
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_application:IRoyalShieldIDE;
        private var m_isMac:Boolean;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function IDEMenu()
        {
            super();
            
            m_application = IRoyalShieldIDE(FlexGlobals.topLevelApplication);
            m_application.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
            m_isMac = CapabilitiesUtil.isMac;
            
            this.labelField = "@label";
            this.keyEquivalentField = "@keyEquivalent";
            this.showRoot = false;
            
            this.addEventListener(FlexNativeMenuEvent.ITEM_CLICK, itemClickHandler);
            this.addEventListener(FlexNativeMenuEvent.MENU_SHOW, showMenuItem);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function create():void
        {
            // Root menu
            var menu:MenuItem = new MenuItem();
            var macMenu:MenuItem;
            
            // Separator
            var separator:MenuItem = new MenuItem();
            
            if (m_isMac) {
                macMenu = new MenuItem();
                macMenu.label = DescriptorUtil.getName();
                menu.addMenuItem(macMenu);
            }
            
            // File
            var fileMenu:MenuItem = new MenuItem();
            fileMenu.label = "File";
            menu.addMenuItem(fileMenu);
            
            // File > New...
            var fileNewMenu:MenuItem = new MenuItem();
            fileNewMenu.label = "New...";
            fileMenu.addMenuItem(fileNewMenu);
            
            // File > New... > Project...
            var fileNewProjectMenu:MenuItem = new MenuItem();
            fileNewProjectMenu.label = "Project...";
            fileNewProjectMenu.data = FILE_NEW_PROJECT;
            fileNewProjectMenu.keyEquivalent = "N";
            fileNewProjectMenu.controlKey = true;
            fileNewMenu.addMenuItem(fileNewProjectMenu);
            
            // Separator
            fileNewMenu.addMenuItem(separator);
            
            // File > New... > Map
            var fileNewMapMenu:MenuItem = new MenuItem();
            fileNewMapMenu.label = "Map";
            fileNewMapMenu.data = FILE_NEW_MAP;
            fileNewMenu.addMenuItem(fileNewMapMenu);
            
            // File > Open
            var fileOpenMenu:MenuItem = new MenuItem();
            fileOpenMenu.label = "Open";
            fileOpenMenu.data = FILE_OPEN;
            fileOpenMenu.keyEquivalent = "O";
            fileOpenMenu.controlKey = true;
            fileMenu.addMenuItem(fileOpenMenu);
            
            // File > Save
            var fileSaveMenu:MenuItem = new MenuItem();
            fileSaveMenu.label = "Save";
            fileSaveMenu.data = FILE_OPEN;
            fileSaveMenu.keyEquivalent = "S";
            fileSaveMenu.controlKey = true;
            fileMenu.addMenuItem(fileSaveMenu);
            
            // File > Save As
            var fileSaveAsMenu:MenuItem = new MenuItem();
            fileSaveAsMenu.label = "Save As...";
            fileSaveAsMenu.data = FILE_OPEN;
            fileSaveAsMenu.keyEquivalent = "S";
            fileSaveAsMenu.controlKey = true;
            fileSaveAsMenu.shiftKey = true;
            fileMenu.addMenuItem(fileSaveAsMenu);
            
            // File > Exit
            var fileExitMenu:MenuItem = new MenuItem();
            fileExitMenu.label = "Exit";
            fileExitMenu.data = FILE_EXIT;
            fileExitMenu.keyEquivalent = "Q";
            fileExitMenu.controlKey = true;
            
            // Edit
            var editMenu:MenuItem = new MenuItem();
            editMenu.label = "Edit";
            menu.addMenuItem(editMenu);
            
            // Edit > Undo
            var editUndoMenu:MenuItem = new MenuItem();
            editUndoMenu.label = "Undo";
            editUndoMenu.data = EDIT_UNDO;
            editUndoMenu.keyEquivalent = "Z";
            editUndoMenu.controlKey = true;
            editMenu.addMenuItem(editUndoMenu);
            
            // Edit > Redo
            var editRedoMenu:MenuItem = new MenuItem();
            editRedoMenu.label = "Redo";
            editRedoMenu.data = EDIT_REDO;
            editRedoMenu.keyEquivalent = "Y";
            editRedoMenu.controlKey = true;
            editMenu.addMenuItem(editRedoMenu);
            
            // View
            var viewMenu:MenuItem = new MenuItem();
            viewMenu.label = "View";
            menu.addMenuItem(viewMenu);
            
            // View > Zoom In
            var viewZoomInMenu:MenuItem = new MenuItem();
            viewZoomInMenu.label = "Zoom In";
            viewZoomInMenu.data = VIEW_ZOOM_IN;
            viewZoomInMenu.keyEquivalent = "+";
            viewZoomInMenu.controlKey = true;
            viewMenu.addMenuItem(viewZoomInMenu);
            
            // View > Zoom Out
            var viewZoomOutMenu:MenuItem = new MenuItem();
            viewZoomOutMenu.label = "Zoom Out";
            viewZoomOutMenu.data = VIEW_ZOOM_OUT;
            viewZoomOutMenu.keyEquivalent = "-";
            viewZoomOutMenu.controlKey = true;
            viewMenu.addMenuItem(viewZoomOutMenu);
            
            // Separator
            viewMenu.addMenuItem(separator);
            
            // View > Show Grid
            var viewShowGrid:MenuItem = new MenuItem();
            viewShowGrid.label = "Show Grid";
            viewShowGrid.data = VIEW_SHOW_GRID;
            viewShowGrid.keyEquivalent = "G";
            viewShowGrid.controlKey = true;
            viewShowGrid.isCheck = true;
            viewMenu.addMenuItem(viewShowGrid);
            
            // View > Show Tile
            var viewShowTile:MenuItem = new MenuItem();
            viewShowTile.label = "Show Tile";
            viewShowTile.data = VIEW_SHOW_TILE;
            viewShowTile.keyEquivalent = "T";
            viewShowTile.controlKey = true;
            viewShowTile.isCheck = true;
            viewMenu.addMenuItem(viewShowTile);
            
            // Help
            var helpMenu:MenuItem = new MenuItem();
            helpMenu.label = "Help";
            menu.addMenuItem(helpMenu);
            
            // Help > About
            var aboutMenu:MenuItem = new MenuItem();
            aboutMenu.label = "About " + DescriptorUtil.getName();
            aboutMenu.data = HELP_ABOUT;
            
            if (m_isMac) {
                macMenu.addMenuItem(aboutMenu);
                macMenu.addMenuItem(separator);
                macMenu.addMenuItem(fileExitMenu);
            } else {
                fileMenu.addMenuItem(separator);
                fileMenu.addMenuItem(fileExitMenu);
                helpMenu.addMenuItem(aboutMenu);
            }
            
            this.dataProvider = menu.serialize();
        }
        
        //--------------------------------------
        // Event Handlers
        //--------------------------------------
        
        protected function creationCompleteHandler(event:Event):void
        {
            m_application.removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
            create();
        }
        
        protected function itemClickHandler(event:FlexNativeMenuEvent):void
        {
            event.stopImmediatePropagation();
            dispatchEvent(new MenuEvent(MenuEvent.SELECTED, String(event.item.@data)));
        }
        
        protected function showMenuItem(event:FlexNativeMenuEvent):void
        {
            var index:uint = m_isMac ? 1 : 0;
            
            // menu File > Save
            nativeMenu.items[index].submenu.items[2].enabled = false;
            
            // menu File > Save As
            nativeMenu.items[index].submenu.items[3].enabled = false;
            
            // menu Edit > Undo
            nativeMenu.items[(index + 1)].submenu.items[0].enabled = m_application.editorManager.canUndo;
            
            // menu Edit > Redo
            nativeMenu.items[(index + 1)].submenu.items[1].enabled = m_application.editorManager.canRedo;
            
            // menu View > Zoom in
            nativeMenu.items[(index + 2)].submenu.items[0].enabled = m_application.editorManager.canZoomIn;
            
            // menu View > Zoom Out
            nativeMenu.items[(index + 2)].submenu.items[1].enabled = m_application.editorManager.canZoomOut;
            
            // menu View > Show Grid
            nativeMenu.items[(index + 2)].submenu.items[3].checked = m_application.editorManager.showGrid;
            
            // menu View > Show Tile
            nativeMenu.items[(index + 2)].submenu.items[4].checked = m_application.editorManager.showMouseTile;
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static public const FILE_NEW_PROJECT:String = "fileNewProject";
        static public const FILE_NEW_MAP:String = "fileNewMap";
        static public const FILE_OPEN:String = "fileOpen";
        static public const FILE_SAVE:String = "fileSave";
        static public const FILE_SAVE_AS:String = "fileSaveAs";
        static public const FILE_EXIT:String = "fileExit";
        static public const EDIT_UNDO:String = "editUndo";
        static public const EDIT_REDO:String = "editRedo";
        static public const VIEW_ZOOM_IN:String = "viewZoomIn";
        static public const VIEW_ZOOM_OUT:String = "viewZoomOut";
        static public const VIEW_SHOW_GRID:String = "viewShowGrid";
        static public const VIEW_SHOW_TILE:String = "viewShowTile";
        static public const HELP_ABOUT:String = "helpAbout";
    }
}
