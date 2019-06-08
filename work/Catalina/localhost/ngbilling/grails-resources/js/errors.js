
function addNewDescription(parent) {
    addNewDescription(parent, '')
}

function addNewDescription(parent, fieldIdx) {
    var ancestor = isEmpty(parent) ?  '' : '#' + parent + ' '
    var languageId = $(ancestor + '#newDescriptionLanguage'+fieldIdx).val();
    var previousDescription = $(ancestor + "#descriptions"+fieldIdx+" div:hidden .descLanguage[value='" + languageId + "']");

    if (previousDescription.size()) {
        previousDescription.parents('.row:first').show();
        previousDescription.parents('.row:first').find(".descDeleted").val(false);
        previousDescription.parents('.row:first').find(".descContent").val('');
    } else {
        var languageDescription = $(ancestor + '#newDescriptionLanguage'+fieldIdx+' option:selected').text();
        if (languageDescription == null || languageDescription == '') return;
        var clone = $(ancestor + '#descriptionClone'+fieldIdx).children().clone();
        var languagesCount = $(ancestor + '#descriptions'+fieldIdx).children().size();
        var newName = 'errorMessages'+fieldIdx+'[' + languagesCount + ']';
        clone.find("label").attr('for', newName + '.content');
        var label = clone.find('label').html();
        clone.find('label').html(label.replace('{0}', languageDescription));

        clone.find(".descContent").attr('id', newName + '.content');
        clone.find(".descContent").attr('name', newName + '.content');

        clone.find(".descLanguage").attr('id', newName + '.languageId');
        clone.find(".descLanguage").attr('name', newName + '.languageId');
        clone.find(".descLanguage").val(languageId);

        clone.find(".descDeleted").attr('id', newName + '.deleted');
        clone.find(".descDeleted").attr('name', newName + '.deleted');

        $(ancestor + '#descriptions'+fieldIdx).append(clone);
    }
   
    removeSelectedErrorLanguage( $(ancestor + '#newDescriptionLanguage'), fieldIdx)
}

function removeErrorDescription(elm){
	removeErrorDescription(elm, '');
}

function removeErrorDescription(elm, fieldIdx){
    var div = $(elm).parents('.row:first');
    //set 'deleted'=true;
    div.find('.descDeleted').val(true);
    div.hide();

    if($("#addDescription"+fieldIdx).is(':hidden')){
        $("#addDescription"+fieldIdx).show();
    }
    var langId = div.find(".descLanguage").val();
    var langValue = getValueForLangId(langId, fieldIdx);
    if(langValue){
        $("#newDescriptionLanguage"+fieldIdx).append("<option value='"+langId+"'>"+langValue+"</option>");
    }
}

function loadAvailableDescriptionLangs(parent) {
    loadAvailableDescriptionLangs(parent, '')
}

function loadAvailableDescriptionLangs(parent, fieldIdx) {
    var ancestor = isEmpty(parent) ?  '' : '#' + parent + ' '
    var languages = $(ancestor + '#availableDescriptionLanguages'+fieldIdx).val().split(',')
    $(ancestor + '#newDescriptionLanguage'+fieldIdx).empty();
    if (languages[0] != '') {
        $.each(languages, function (i, lang) {
            var lang = lang.split('-');
            $(ancestor + '#newDescriptionLanguage'+fieldIdx).append("<option value='" + lang[0] + "'>" + lang[1] + "</option>");
        });
    } else {
        $(ancestor + '#addDescription'+fieldIdx).hide();
    }
}

function getValueForLangId(langId) {
    getValueForLangId(langId, '')
}

function getValueForLangId(langId, fieldIdx) {
    var languages = $('#allDescriptionLanguages'+fieldIdx).val().split(',')
    if (languages[0] != '') {
        var value = false;
        $.each(languages, function (i, lang) {
            var lang = lang.split('-');
            if (lang[0] == langId) {
                value = lang[1];
            }
        });
        return value;
    } else {
        return false;
    }
    return false;
}

function removeSelectedErrorLanguage(parent){
	removeSelectedErrorLanguage(parent, '');
}

function removeSelectedErrorLanguage(parent, fieldIdx){
    		
    $('#newDescriptionLanguage'+fieldIdx+' option:selected').remove();
    if(!$('#newDescriptionLanguage'+fieldIdx+' option').size()){
        $('#addDescription'+fieldIdx).hide();
    }
}

function isEmpty(str) {
    return (!str || 0 === str.length);
}
