%{--
  jBilling - The Enterprise Open Source Billing System
  Copyright (C) 2003-2011 Enterprise jBilling Software Ltd. and Emiliano Conde

  This file is part of jbilling.

  jbilling is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  jbilling is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.

  You should have received a copy of the GNU Affero General Public License
  along with jbilling.  If not, see <http://www.gnu.org/licenses/>.

 This source was modified by Web Data Technologies LLP (www.webdatatechnologies.in) since 15 Nov 2015.
You may download the latest source from webdataconsulting.github.io.

  --}%

<%@ page import="com.sapienter.jbilling.server.util.db.CurrencyDTO; com.sapienter.jbilling.server.util.db.LanguageDTO;" %>

<%--
  Editor form for price model attributes.

  This template is not the same as the attribute UI in the plan builder. The plan builder
  uses remote AJAX calls that can only be used in a web-flow. This template is to be used
  for standard .gsp pages.

  @author Brian Cowdery
  @since  02-Feb-2011
--%>

<script type="text/javascript">
    
    function addMultiLingualDescription() {
        var languageId = $('#newDescriptionLanguage').val();
        var previousDescription = $("#descriptions div:hidden .descLanguage[value='" + languageId + "']");
        if (previousDescription.size()) {
            previousDescription.parents('.row:first').show();
            previousDescription.parents('.row:first').find(".descDeleted").val(false);
            previousDescription.parents('.row:first').find(".descContent").val('');
        } else {
            var languageDescription = $('#newDescriptionLanguage option:selected').text();
            var clone = $('#descriptionClone').children().clone();
            var languagesCount = $('#descriptions').children().size();
            var newName = '${itemName}.descriptions[' + languagesCount + ']';
            clone.find("label").attr('for', newName + '.content');
            var label = clone.find('label').html();
            clone.find('label').html(label.replace('{0}', languageDescription));
            if (languageDescription == "English") {
                clone.find('label').append("<span id='mandatory-meta-field'>*</span>");
            }

            clone.find(".descContent").attr('id', newName + '.content');
            clone.find(".descContent").attr('name', newName + '.content');

            clone.find(".descLanguage").attr('id', newName + '.languageId');
            clone.find(".descLanguage").attr('name', newName + '.languageId');
            clone.find(".descLanguage").val(languageId);

            clone.find(".descDeleted").attr('id', newName + '.deleted');
            clone.find(".descDeleted").attr('name', newName + '.deleted');

            $('#descriptions').append(clone);
        }
        if (languageId == 1) {
            $('#newDescriptionLanguage').closest("div").find("label span").remove();
        }
        removeSelectedLanguage();
    }

    function removeDescription(elm) {
        var div = $(elm).parents('.row:first');
        //set 'deleted'=true;
        div.find('.descDeleted').val(true);
        div.hide();

        if ($("#addDescription").is(':hidden')) {
            $("#addDescription").show();
        }
        var langId = div.find(".descLanguage").val();
        var langValue = getValueForLangId(langId);
        if (langValue) {
            $("#newDescriptionLanguage").append("<option value='" + langId + "'>" + langValue + "</option>");
            if (langId == 1) {
                $("#newDescriptionLanguage").closest("div").find('label').append(
                        "<span id='mandatory-meta-field'>*</span>");
            }
        }
    }

    function loadAvailableDecLang() {
        var languages = $('#availableDescriptionLanguages').val().split(',');
        if (languages[0] != '') {
            $.each(languages, function (i, lang) {
            	var lang = lang.split('-');
                $("#newDescriptionLanguage").append("<option value='"+lang[0]+"'>"+lang[1]+"</option>");
            });
        } else {
            $('#addDescription').hide();
        }
    }

    function getValueForLangId(langId) {
        var languages = $('#allDescriptionLanguages').val().split(',')
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

    function removeSelectedLanguage() {
        $('#newDescriptionLanguage option:selected').remove();
        if (!$('#newDescriptionLanguage option').size()) {
            $('#addDescription').hide();
        }
    }

    function getSelectValues(select) {
        var result = [];
        var options = select && select.options;
        var opt;

        for (var i = 0, iLen = options.length; i != iLen; i++) {
            opt = options[i];

            if (opt.selected) {
                result.push(opt.value || opt.text);
                result.push(",")
            }
        }
        return result;
    }

    $(document).ready(function () {
        loadAvailableDecLang();
    })

</script>


<div id="descriptionClone" style="display: none">
    <g:applyLayout name="form/description">
        <content tag="label"><g:message code="${itemName}.detail.description.label"/></content>
        <content tag="label.for">desCloneContent</content>

        <input type="text" id="desCloneContent" class="descContent field" size="26" value="" name="desCloneContent">
        <input type="hidden" id="desCloneLangId" class="descLanguage" value="" name="desCloneLangId">
        <input type="hidden" id="desCloneDeleted" class="descDeleted" value="" name="desCloneDeleted">
        <a onclick="removeDescription(this)">
            <img src="${resource(dir:'images', file:'cross.png')}" alt="remove"/>
        </a>
    </g:applyLayout>
</div>

<g:set var="availableDescriptionLanguages" value="${LanguageDTO.list().collect { it.id + '-' + it.description }}"></g:set>

<div id="descriptions">
		<g:if test="${multiLingualEntity?.descriptions}">
        <g:each in="${multiLingualEntity?.descriptions}" var="description" status="index">
            <g:if test="${description?.languageId}">
                <g:applyLayout name="form/description">
                    <g:set var="currentLang" value="${LanguageDTO.get(multiLingualEntity?.descriptions[index]?.languageId)}"></g:set>
                    <g:set var="availableDescriptionLanguages" value="${availableDescriptionLanguages - (currentLang?.id+'-'+currentLang?.description)}"></g:set>
                    <content tag="label"><g:message code="${itemName}.detail.description.label" args="${[currentLang?.description]}"/>
                        <g:if test="${description?.languageId==1}">
                            <span id="mandatory-meta-field">*</span>
                        </g:if>
                    </content>
    
                    <content tag="label.for">${itemName}.descriptions[${index}].content</content>
    
                    <g:textField name="${itemName}.descriptions[${index}].content" class="descContent field" value="${multiLingualEntity?.descriptions[index]?.content}"/>
                    <g:hiddenField name="${itemName}.descriptions[${index}].languageId" class="descLanguage" value="${currentLang?.id}"/>
                    <g:hiddenField name="${itemName}.descriptions[${index}].deleted" value="" class="descDeleted"/>
                    <a onclick="removeDescription(this)">
                        <img src="${resource(dir:'images', file:'cross.png')}" alt="remove"/>
                    </a>
                </g:applyLayout>
            </g:if>
        </g:each>
        </g:if>
        <g:else>
        <g:applyLayout name="form/description">
            <g:set var="currentLang" value="${LanguageDTO.get(session['language_id'] as Integer)}"></g:set>
            <g:set var="availableDescriptionLanguages" value="${availableDescriptionLanguages - (currentLang?.id + '-' + currentLang?.description)}"></g:set>
            <content tag="label">
                <g:message code="${itemName}.detail.description.label" args="${[currentLang?.description]}"/>
            </content>
            <content tag="label.for">${itemName}.descriptions[0].content</content>
            <g:textField name="${itemName}.descriptions[0].content" class="descContent field" value=""/>
            <g:hiddenField name="${itemName}.descriptions[0].languageId" class="descLanguage" value="${currentLang?.id}"/>
            <g:hiddenField name="${itemName}.descriptions[0].deleted" value="" class="descDeleted"/>
            <a onclick="removeDescription(this)">
                <img src="${resource(dir:'images', file:'cross.png')}" alt="remove"/>
            </a>
        </g:applyLayout>
    </g:else>
</div>

<div class="row" id='addDescription'>
    <div class="add-desc">
        <label><g:message code="${itemName}.detail.description.add.title"/></label>
        <select name="newDescriptionLanguage" id="newDescriptionLanguage"></select>
        <a onclick="addMultiLingualDescription()">
            <img src="${resource(dir:'images', file:'add.png')}" alt="remove"/>
        </a>
    </div>
</div>
<g:set var="allDescriptionLanguages" value="${LanguageDTO.list().collect { it.id + '-' + it.description }}"></g:set>
<g:hiddenField name="allDescriptionLanguages" value="${allDescriptionLanguages?.join(',')}"/>
<g:hiddenField name="availableDescriptionLanguages" value="${availableDescriptionLanguages?.join(',')}"/>

