$(document).ready(function() {
    bindOptionsToExpand();
    ensureExpandedCorrectly();
});


function bindOptionsToExpand() {
    var expandableOptions = $('.expandingOption');
    expandableOptions.click(function() {
        showHideExpandee(this);
    });
}

function ensureExpandedCorrectly() {
    $('.expandingOption').each(function() {
        showHideExpandee(this);
    });
}

function showHideExpandee(senderCheckBox) {

    var expandeeElement = $(senderCheckBox).siblings('.expandable');

    if (senderCheckBox.checked) {
        expandeeElement.fadeIn('fast');
    }
    else
        expandeeElement.hide();
}