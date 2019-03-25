$(document).ready(function() {
    $('.ProviderState').change(populateProviderCities);
    $('.ProviderCity').change(populateProviders);
});

function populateProviderCities() {
    var selectedVal = $(this).val();
    var targetDropDown = $(".ProviderCity");

    if (selectedVal == '' || selectedVal == null) {
        clearDropDownOptionsAndDisable(targetDropDown, "-Select Provider's State-");
    } else {
        clearDropDownOptionsAndDisable(targetDropDown, 'Loading...');
        jQuery.get('../Setup/ProviderCitiesDropDown', {
            fieldName: targetDropDown.attr('name'),
            emptyOptionText: '-Select-',
            providerState: selectedVal
        },
        loadProviderCities, 'html');
    }
}

function loadProviderCities(data, textStatus) {
    var elementToPopulate = $('.ProviderCitiesHolder');
    elementToPopulate.html(data);
    // rebind provider city change event, since new drop down was brought in
    $('.ProviderCity').change(populateProviders);
}

function populateProviders() {
    var selectedVal = $(this).val();
    var selectedState = $('.ProviderState').val();
    var targetDropDown = $('.ProviderHolder').children('select');

    if (selectedVal == '' || selectedVal == null) {
        clearDropDownOptionsAndDisable(targetDropDown, "-Select Provider's City and State-");
    } else {
        clearDropDownOptionsAndDisable(targetDropDown, 'Loading...');
        jQuery.get('../Setup/ProvidersDropDown', {
            fieldName: targetDropDown.attr('name'),
            emptyOptionText: '-Select-',
            providerState: selectedState,
            providerCity: selectedVal
        },
        loadProviders, 'html');
    }
}

function loadProviders(data, textStatus) {
    var elementToPopulate = $('.ProviderHolder');
    elementToPopulate.html(data);
}


