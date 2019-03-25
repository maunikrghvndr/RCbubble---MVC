// Commannds to call on annotations

function DeleteAnno()
{
	var anns = WebAnnotationViewer1.getSelectedAnnotations();
	WebAnnotationViewer1.DeleteAnnotations(anns);
}

function MoveSelectedAnnoToPos(i)
{
	var layer = _currentAnno.getParent();
	var count = layer.getAnnotations().length;
	if (i >= 0 && i <= count) {
		layer.Insert(_currentAnno, i);
	}
}

function MoveSelectedAnnoForward()
{			
	MoveSelectedAnnoToPos(_currentAnno.getZIndex() + 1);	
}

function MoveSelectedAnnoFront()
{		
	MoveSelectedAnnoToPos(_currentAnno.getParent().getAnnotations().length);	
}

function MoveSelectedAnnoBackward()
{
	MoveSelectedAnnoToPos(_currentAnno.getZIndex() - 1);
}

function MoveSelectedAnnoBack()
{
	MoveSelectedAnnoToPos(0);
}


