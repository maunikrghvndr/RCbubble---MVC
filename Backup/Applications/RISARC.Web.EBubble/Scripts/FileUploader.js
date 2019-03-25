/// <reference name="jquery-1.3.2-vsdoc.js"/>

$(document).ready(function() {
    var uploadForm = $('.UploadMedicalDocumentform');
    uploadForm.attr('target', 'upload_target');
    $(".btnUploaderCss").find('span:first').text("Select/Add File …");
    $(".btnUploaderCss").find('span:first').parents('div:first').width(150);
});

function displayUpLoadingPanel(senderButton) {
    var wrapperPanel = $(senderButton).parents('.uploadFormWrapper');
    var loadingPanel = wrapperPanel.siblings('.uploadInProgressWrapper');
    wrapperPanel.hide();
     generalizedShowLoader();
   // generalizedShowLoader();
    return true;
}

function populateResponseToForm() {
    var targetHtmlFrame = $(frames['upload_target'].document);
    var targetBody = targetHtmlFrame.find('body');
    var responseHtml = targetBody.html();
    $('.fileUploaderForm').children('.formContents').html(responseHtml);
}

function swapToUploadPrompt(senderLink) {
    $(senderLink).parents('ul').hide();
    $(senderLink).parents('ul').siblings('.uploadFormWrapper').show();
    $('#UploadedFileId').val(null);
    $('#DocumentFileId').val(null);
    return false;
}




