var count = 0;
var totalPageCount = 0;
var _doc = null;

$(document).ready(function () {
    $("#pluginThumbnailList").ImGearThumbnailListPlugin({
        thumbnailCaptionFormat: "{DC}:Page {P#}",
        pageViewClientId: "pluginPageView",
        layout: ImageGear.Web.UI.ImGearThumbnailLayout.VerticalScrollDirection,
        resourcePath: '../../Images',
        useDefaultStyling: false
    });

    $("#pluginPageView").ImGearPageViewPlugin(
   {
       imageHandlerUrl: "../../ImageGearService.svc",
       resourcePath: '../../Images',
       artServiceOption: ImageGear.Web.UI.ImGearArtDataServices.ArtDataService
   });
});

function LoadDocument(documetPath, documetName) {
    debugger;
    _doc = new ImageGear.Web.UI.ImGearDocument(
    {
        documentIdentifier: documetPath,
        includeAllPages: true,
        imageServicePath: "../../ImageGearService.svc"
    });

    _doc.set_caption(documetName);
    _doc.add_pageAdded(pageAddedhandler);
    _doc.add_pageOpenFailed(pageOpenFailedHandler);
    _doc.add_artPageOpenFailed(artPageOpenFailedHandler);

    var documentList = new ImageGear.Web.UI.ImGearDocumentCollection();
    documentList.addDocument(_doc);

    alert(documentList.length);
    documentList.removeAllDocument();
    alert(documentList.length);
    $("#pluginThumbnailList").ImGearThumbnailListPlugin().get_documents().addDocument(_doc);
}

function pageOpenFailedHandler(sender, eventArgs) {
    alert(eventArgs.exception.message);
}

function artPageOpenFailedHandler(sender, eventArgs) {
    if (eventArgs.pageNumber)
        alert("ART page " + eventArgs.pageNumber + " loading reports the error:\r\n" + eventArgs.exception.message);
    else
        alert("ART page loading reports the error:\r\n" + eventArgs.exception.message);
}
function onImageGearItemLogged(logItem) {
    var _log1 = logItem;
}

function pageAddedhandler(sender, eventArgs) {
    var doc = $("#pluginThumbnailList").ImGearThumbnailListPlugin().get_documents().getDocument(0);
    if (sender === doc) {
        var pages = doc.get_pages();
        totalPageCount = doc.get_pageCount();
        if (eventArgs.imGearPage === pages.getPage(0)) {
            pages.getPage(count).set_selected(true);
        }
    }
    $("#pluginPageView").ImGearPageViewPlugin().set_mouseTool(ImageGear.Web.UI.MouseTool.HandPan);
}

function nextToolButton_onclick() {
    var doc = $("#pluginThumbnailList").ImGearThumbnailListPlugin().get_documents().getDocument(0);
    var pages = doc.get_pages();

    if (totalPageCount - 1 > count)
        count = count + 1;
    else
        count = 0;

    pages.getPage(count).set_selected(true);
}

function previousToolButton_onclick() {
    var doc = $("#pluginThumbnailList").ImGearThumbnailListPlugin().get_documents().getDocument(0);
    var pages = doc.get_pages();

    if (totalPageCount - 1 >= count && count != 0)
        count = count - 1;
    else
        count = totalPageCount - 1;

    pages.getPage(count).set_selected(true);
}

function rotateRightToolButton_onclick() {
    $("#pluginPageView").ImGearPageViewPlugin().rotate(90);
}

function rotateLeftToolButton_onclick() {
    $("#pluginPageView").ImGearPageViewPlugin().rotate(-90);
}

function fiToPageToolButton_onclick() {
    $("#pluginPageView").ImGearPageViewPlugin().fitPage(ImageGear.Web.UI.FitType.FullWidth);
    $("#pluginPageView").ImGearPageViewPlugin().fitPage(ImageGear.Web.UI.FitType.FullHeight);
}

function printCurrentPage_onclick() {

    var plugin = $("#pluginPageView").ImGearPageViewPlugin();
    var pageArray = [plugin.get_pageNumber()];
    plugin.showPrintDialog({ pageArray: pageArray, includeAnnotations: true });
}

function printDocument(plugin, printOptions) { try { plugin.QU(printOptions); } catch (e) { plugin.F('showPrintDialog', e); throw e; } }

function goToPageToolButton_onClick() {
    if ($('#txtGoToPage') != null && parseInt($('#txtGoToPage').val()) - 1 >= 0 && totalPageCount >= parseInt($('#txtGoToPage').val())) {
        var doc = $("#pluginThumbnailList").ImGearThumbnailListPlugin().get_documents().getDocument(0);
        var pages = doc.get_pages();
        count = parseInt($('#txtGoToPage').val()) - 1;
        pages.getPage(count).set_selected(true);
    }
    else {
        alert("Invalid page Number. Must be between 1 to " + totalPageCount);
    }
    //$('#txtGoToPage').val('');
}