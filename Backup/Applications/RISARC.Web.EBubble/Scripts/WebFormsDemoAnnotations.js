Atalasoft.Utils.InitClientScript(OnPageLoad);
function OnPageLoad() {

	WebAnnotationViewer1.AnnotationRightClicked = OnAnnotationRightClicked;
	WebAnnotationViewer1.AnnotationDoubleClicked = OnAnnotationDoubleClicked;

	InitContextMenu();
	
	Atalasoft.Event.Attach(this, WebAnnotationViewer1, 'MouseDown', CloseContextMenu);
    
    WebThumbnailViewer1.UrlChanged = OnThumbnailUrlChanged;

	

}

// helper
function getObj(id)
{
	return document.getElementById(id);
}

function OnThumbnailUrlChanged(){
	WebThumbnailViewer1.SelectThumb(0);	
}

// tells the WebImageViewer that it needs to update the image
function OpenPreparedImage(){
	var path = WebAnnotationViewer1.getReturnValue();
	if (path == ''){
	    alert('Could not load image.\nPDF images require a PDFRasterizer license.\nYou may request an eval license with our Activation Tool.');
	}
	else{
		WebAnnotationViewer1.ClearImage();
	    WebThumbnailViewer1.OpenUrl(path);
	}
}

// integer expected: 0:None 1:BestFit 2:BestFitShrinkOnly 3:FitToWidth 4:FitToHeight 5:FitToImage
function setAutoZoom(zoomMode){
	WebAnnotationViewer1.setAutoZoom(zoomMode);
}

// Increments and decrements the zoom level by the given amount
function Zoom(inOut){
	var z = WebAnnotationViewer1.getZoom();
	var zp = WebAnnotationViewer1.getZoomInOutPercentage();
	
	z += inOut * z * zp / 100;
	
	WebAnnotationViewer1.setZoom(z);
}


// Changes the mouse behavior
function ChangeMouseTool(i){
	switch(i){
		case 0:	// Pan tool
			WebAnnotationViewer1.setMouseTool(6);
			WebAnnotationViewer1.getSelection().Changed = function(){};
			break;
		case 1:	// Zoom tool
			WebAnnotationViewer1.setMouseTool(3, 4);
			setAutoZoom(0);
			WebAnnotationViewer1.getSelection().Changed = function(){};
			break;
		case 2:	// Zoom Area tool
			WebAnnotationViewer1.setMouseTool(5);
			setAutoZoom(0);
			WebAnnotationViewer1.getSelection().Changed = function(){};
			break;
	}
}

// allow the user to create an annotation with the mouse
function CreateAnnotation(type, name){
	WebAnnotationViewer1.CreateAnnotation(type, name);
}

var _currentAnno;
function OnAnnotationRightClicked(e){
	var annoCell = getObj('annoCell');

	// change the location of the event
	var e2 = new Object();
	e2.clientX = e.clientX + atalaGetOffsetLeft(annoCell)+15;
	e2.clientY = e.clientY + atalaGetOffsetTop(annoCell)+15;	
	e2.target = e.target;
	e2.srcElement = e.srcElement;
	
	_currentAnno = e.annotation;	
	ContextMenuShow(e2);	
	return true;
}

function OnAnnotationDoubleClicked(e){
	if (e.annotation.getType() != 'TextData' && e.annotation.getType() != 'ReferencedImageData'){
		_currentAnno = e.annotation;
		var annoCell = getObj('annoCell');
		AnnoProperties(e.clientX + atalaGetOffsetLeft(annoCell), e.clientY + atalaGetOffsetTop(annoCell));
	}
}

function OpenImageFile(file){
	WebAnnotationViewer1.RemoteInvoke('PrepareImageForOpen', [file]);
	WebAnnotationViewer1.RemoteInvoked = OpenPreparedImage;
}
