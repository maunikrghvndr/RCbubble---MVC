// functions to manage annotation context menu

var isMouseOverContextMenu = false;
function InitContextMenu(){
	var contextMenu = getAnnoContextMenu();
	
    contextMenu.onmouseover = function() { isMouseOverContextMenu = true; };
    contextMenu.onmouseout = function() { isMouseOverContextMenu = false; };
    
    document.body.onmousedown = ContextMenuMouseClick;    
}

var _menuX = 0;
var _menuY = 0;
function CallFromContextMenu(f){
	f();
	CloseContextMenu();
	return true;
}

function getAnnoContextMenu(){
	return getObj('AnnoContextMenu');
}

function ContextMenuMouseClick(e){
	if (!isMouseOverContextMenu){
        CloseContextMenu();
    }
}

function CloseContextMenu(){
    isMouseOverContextMenu = false;
    var contextMenu = getAnnoContextMenu();
    contextMenu.style.visibility = 'hidden';
}

function ContextMenuShow(e){
    if (isMouseOverContextMenu)
        return;

    if (e == null)
        e = window.event;
        
    var target = e.target != null ? e.target : e.srcElement;
	
    var contextMenu = getAnnoContextMenu();
    
    // set the left
    var scrollLeft = document.body.scrollLeft ? document.body.scrollLeft : 
        document.documentElement.scrollLeft;
    _menuX = e.clientX + scrollLeft;	
    contextMenu.style.left = _menuX + 'px';
    
    // set the top
    var scrollTop = document.body.scrollTop ? document.body.scrollTop : 
        document.documentElement.scrollTop;
    _menuY = e.clientY + scrollTop;
    contextMenu.style.top = _menuY + 'px';
    
    contextMenu.style.visibility = 'visible';
}
