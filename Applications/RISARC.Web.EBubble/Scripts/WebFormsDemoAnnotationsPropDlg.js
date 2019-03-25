// functions to manage the annotation property dialog

function getAnnoPropertiesDlg(){
	return getObj('AnnoPropDlg');
}

function AnnoProperties(x, y){
	if (x != null){
		_menuX = x;
	}
	if (y != null){
		_menuY = y;
	}
	
	WebAnnotationViewer1.RemoteInvoked = OnAnnoPropertyDialogInvoked;
	WebAnnotationViewer1.RemoteInvoke('PopupAnnoDialog',
		[
			_currentAnno.getParent().getLayerIndex(),
			_currentAnno.getZIndex()
		]
	);
}

function OnAnnoPropertyDialogInvoked(){
	WebAnnotationViewer1.RemoteInvoked = function(){};
	
	var ret = WebAnnotationViewer1.getReturnValue();
	var props = ret.split(":");
	
	getObj("propOutlineColor").value = props[0];
	getObj("propOutlineWidth").value = props[1];
	getObj("propFillColor").value = props[2];
	
	var propDlg = getAnnoPropertiesDlg();

	propDlg.style.visibility = 'visible';
	propDlg.style.left = _menuX + 'px';
	propDlg.style.top = _menuY + 'px';
}

function FormatColor(c){
	if (c.charAt(0) == "#"){
		return c.substring(1);
	}
	
	return c;
}

function PropSave(){
	var outlineColor = FormatColor(getObj("propOutlineColor").value);
	var outlineWidth = getObj("propOutlineWidth").value;
	var fillColor = FormatColor(getObj("propFillColor").value);

	WebAnnotationViewer1.RemoteInvoked = OnAnnoPropertyDialogSaved;
	WebAnnotationViewer1.RemoteInvoke('SaveProps', 
		[
			_currentAnno.getParent().getLayerIndex(), 
			_currentAnno.getZIndex(),
			outlineColor, outlineWidth, fillColor
		]
	);
	return false;
}

function OnAnnoPropertyDialogSaved(){
	var ret = WebAnnotationViewer1.getReturnValue();
	if (ret != ''){
		alert(ret);
	}
	else{
		ClosePropDialog();
		
		if (_currentAnno){
			// we need to update the annotation and thumbnail because we
			// changed server only properties of the annotation in a RemoteInvoke
			_currentAnno.Update();
			WebThumbnailViewer1.UpdateThumb(WebThumbnailViewer1.getSelectedIndex());
		}
	}
	
	WebAnnotationViewer1.RemoteInvoked = function(){};
}

function ClosePropDialog(){
	var propDlg = getAnnoPropertiesDlg();
	propDlg.style.visibility = 'hidden';
}

function PropCancel(){
	ClosePropDialog();
	return false;
}
