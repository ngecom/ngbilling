/*
 * JBILLING CONFIDENTIAL
 * _____________________
 *
 * [2003] - [2013] Enterprise jBilling Software Ltd.
 * All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Enterprise jBilling Software.
 * The intellectual and technical concepts contained
 * herein are proprietary to Enterprise jBilling Software
 * and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden.
 */
/*
    Define the following variables when including this file
     var metaFieldIdx = ${metaFieldIMaxIdx + 3};
     var localLang = '${session.locale.language}';
     var pickerDateFormat = "${message(code: 'datepicker.jquery.ui.format')}";
     var assetSearchFormId; //form which contains the meta fields - used as base to select meta fields
     var assetSearchFunction; //function that will do the asset search
 */

// Add an extra meta field filter
function addMetafieldFilter() {
    metaFieldIdx ++;
    // Clone the template
    var template = $("#metafield-filter-template").clone().html().replace(/_mfIdx_/g, metaFieldIdx);
    $("#mf-row-holder").after(template);

    //event listeners to reload results
    $('#'+assetSearchFormId+' :input[name=filterByMetaFieldValue'+metaFieldIdx+']').change(function () {
        assetSearchFunction();
//            $('#'+assetSearchFormId).submit();
    });

    //Show the correct widget to select a meta field value when metafield changes
    $('#mf-id-'+metaFieldIdx).change(function () {
            showCorrectWidget(this);
    }).change();

    //Initialize the date picker
    var options = $.datepicker.regional[localLang];
    if (options == null) options = $.datepicker.regional[''];

    options.dateFormat = pickerDateFormat;
    options.buttonImage = "";

    $(".mfdate-"+metaFieldIdx).datepicker(options);
}

//A metafield filter has been removed
function removeMetafieldFilter() {
    assetSearchFunction();
}

//Show the correct widget to select a meta field value
function showCorrectWidget(src, noSearch) {
    var prefixLen = "mf-id-".length;
    var idx = $(src).prop('id').substring(prefixLen);
    var obj = $('.valuemarker-'+idx);
    obj.prop('disabled', true);
    obj.hide();

    obj = $('.valuemarker-div-'+idx);
    obj.hide();

    var baseSel = '#mf-val-'+$(src).val().split(':')[0];
    var sel = baseSel+'-'+idx;
    obj = $(sel);
    if(!obj.length) {
        baseSel = '#mf-val'
        sel = baseSel+'-'+idx;
        obj = $(sel);
    }
    obj.prop('disabled', false);
    obj.show();

    obj = $(baseSel+'-div-'+idx);
    if(obj.length) {
        obj.prop('disabled', false);
        obj.show();
    }

    //reload the list
    if(!noSearch) assetSearchFunction();
}