$(document).ready(function() {
    bindOptionsToEnable();
    ensureEnabledCorrectly();
});


function bindOptionsToEnable() {
    $('.enableingOption').click(function() {
        expandRelatedOption(this);
    });
}

function ensureEnabledCorrectly() {
    $('.enableingOption').each(function() {
        expandRelatedOption(this);
    });
}

function expandRelatedOption(senderInput) {
    // see if sended input is checked.  
    // if is, then hide all options and show its relevant option
    if (senderInput.checked) {
        var elementsToHide = $(senderInput).parents('.expandableHolder').find('.expandable');
        elementsToHide.hide();

        var elementToExpand = $(senderInput).siblings('.expandable');
        elementToExpand.fadeIn('fast');
    }
}