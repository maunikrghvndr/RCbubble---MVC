$(document).ready(function() {
    $('.CountriesDropDown').change(changeAddressOptions);
   // alert('loaded');
    // call change event in case value was cached from reset

});

function changeAddressOptions(){
    // this is drop down
    var jsThis = $(this);
    var selectedVal = jsThis.val();

    var targetElementWrapper = jsThis.parents('li:first').siblings('.addressContentsWrapper');
    var elementToPopulate = targetElementWrapper.children('.addressContents');

    if (selectedVal == null || selectedVal == '') {
        targetElementWrapper.fadeOut();
        elementToPopulate.empty();
    }
    else {
        var loadingImage = jsThis.siblings('.loadingImage');
        loadingImage.show();
        var bindingPrefix = extractBindingPrefix(jsThis);
        if (selectedVal == 'US') {
            var elementUrl = '../AddressInfo/UsAddressInfo/?bindingPrefix=' + bindingPrefix;
        }
        else if (selectedVal == 'CA') {
        var elementUrl = '../AddressInfo/CanadaAddressInfo/?bindingPrefix=' + bindingPrefix;
        }
        else {
            var elementUrl = '../AddressInfo/InternationalAddressInfo/?bindingPrefix=' + bindingPrefix;
        }
        targetElementWrapper.hide();
        elementToPopulate.empty();
        $(elementToPopulate).load(elementUrl, countryLoadComplete);
    }
}

function countryLoadComplete() {
    var wrapper = $(this).parents('.addressContentsWrapper:first');
    $(wrapper).fadeIn('fast', hideLoadingImage);
}

function hideLoadingImage() {
    var loadingImage = $(this).siblings().find('.loadingImage');
    loadingImage.hide();
}

function extractBindingPrefix(element) {
    // hack - grab binding prefix from neighboring labe, since lastIndexOf never works;
    var bindingPrefixHolder;
    var bindingPrefix;
    bindingPrefixHolder = $(element).siblings('.bindingPrefix');
  ///  var lastPeriod = elementName.indexOf('.', 0);
   // if (lastPeriod = -1)
   //     bindingPrefix = '';
    //else {
    //    bindingPrefix = elementName.substring(0, lastPeriod);
   // }

    bindingPrefix = bindingPrefixHolder.html();
    return bindingPrefix;
}