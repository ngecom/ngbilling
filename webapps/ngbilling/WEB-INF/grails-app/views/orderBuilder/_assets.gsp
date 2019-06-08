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

<%@ page import="com.sapienter.jbilling.server.util.db.EnumerationDTO; com.sapienter.jbilling.server.metafields.DataType; com.sapienter.jbilling.server.item.db.ItemDTO; com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.item.db.AssetStatusDTO;  com.sapienter.jbilling.server.item.db.AssetDTO" %>

<%--
  Shows the asset list and provides some basic filtering capabilities.

  @author Gerhard Maree
  @since 24-April-2011
--%>
<script>
 var jAssetList =[];
</script>

<div id="#form-div-asset-select-${assetFlow}">

<g:if test='${infoMessage}'>
    <div class="msg-box info msg-box-no-padb">
        <p>${infoMessage}</p>
    </div>
</g:if>

<!-- filter -->
<div id="form-div-${assetFlow}" class="form-columns asset-dialog-filters">
    <g:formRemote name="assets-filter-form-${assetFlow}" url="[action: 'edit']" update="assets-table-${assetFlow}"
                  method="GET">
        <g:hiddenField name="_eventId" value="assets"/>
        <g:hiddenField name="partial" value="true"/>
        <g:hiddenField name="execution" value="${flowExecutionKey}"/>

        <g:applyLayout name="form/input">
            <content tag="label"><g:message code="filters.title"/></content>
            <content tag="label.for">filterBy</content>
            <g:textField name="filterBy" class="field default"
                         placeholder="${message(code: 'assets.filter.by.default')}" value="${params.filterBy}"/>
        </g:applyLayout>

        <g:applyLayout name="form/select">
            <content tag="label"><g:message code="assets.label.status"/></content>
            <content tag="label.for">assetStatusId</content>
            <g:select name="statusId" from="${assetStatuses}"
                      noSelection="['': message(code: 'filters.asset.status.empty')]"
                      optionKey="id" optionValue="description"
                      value="${params.statusId}"/>
        </g:applyLayout>

        <%-- Create inputs for the meta fields --%>
        <g:if test="${assetMetaFields.size() > 0}" >
            <g:render template="assetsMetaField" model="[assetMetaFields: assetMetaFields, assetFlow: assetFlow, metaFieldIdx: '1', addButton: true, initDatePicker: true]"/>
        </g:if>
    </g:formRemote>

</div>

<g:if test="${assetMetaFields.size() > 0}" >
    <div id="metafield-template-${assetFlow}" style="display: none">
        <g:render template="assetsMetaField" model="[assetMetaFields: assetMetaFields, assetFlow: assetFlow, metaFieldIdx: '_mfIdx_', removeButton: true]"/>
    </div>
</g:if>

<div id="assets-table-${assetFlow}" >
    <g:render template="assetsResults"/>
</div>


<div class="btn-box" id="buttons-id-${assetFlow}">

    <g:remoteLink class="submit add" action="edit" id="${assetFlowExitId}" params="[index: params.index, itemId:params.itemId, isAssetMgmt:true,plan: params.plan, _eventId: assetFlowExitEvent, assetFlowExitPlanItemId: assetFlowExitPlanItemId,userID:params.userId]"
                  update="ui-tabs-edit-changes" after="closeAssets${assetFlow}Dialog(event);" method="GET">
        <span><g:message code="button.add.to.order"/></span>
    </g:remoteLink>


    <a href="#" name="reserve-remote-link" class="submit add">
        <span><g:message code="button.reserve.asset"/></span>
    </a>
    %{--<g:remoteLink class="submit add" action="edit" id="${assetFlowExitId}" name="reserve-remote-link"--}%
        %{--params="[_eventId:'reserve', userID:params.userId, checkedAssets:checkedAssets]" update="assets-table-${assetFlow}" method="GET">--}%
        %{--<span><g:message code="button.reserve.asset"/></span>--}%
    %{--</g:remoteLink>--}%

    <a id="assets-dialog-cancel-${assetFlow}" class="submit cancel" onclick="closeAssets${assetFlow}Dialog(event);">
        <span><g:message code="button.cancel"/></span>
    </a>
</div>

<div class="btn-box" id="button-ok-${assetFlow}" style="padding-left:130px;">

    <a id="assets-dialog-cancel-${assetFlow}" class="submit cancel" onclick="closeAssets${assetFlow}Dialog(event);">
        <span><g:message code="prompt.ok"/></span>
    </a>
</div>

</div>

<div id="addNewAssetLink" style="display: none">
<g:remoteLink class="cell double" action="edit" id="_id_"
              params="[_eventId: 'addAsset']" update="assets-table-${assetFlow}" method="GET">
</g:remoteLink>
</div>

<div id="new-asset-dialog">
    <div id="messages" />
    <div id="new-asset-content">
    </div>
</div>

<script type="text/javascript">
    <g:render template="/layouts/includes/messageBreadCrumbListeners"/>
</script>

<script type="text/javascript">
    var metaFieldIdx = 1;

    <%-- Add an extra meta field filter --%>
    function addMetafieldFilter${assetFlow}() {
        metaFieldIdx ++;
        <%-- Clone the template --%>
        var template = $("#metafield-template-${assetFlow}").clone().html().replace(/_mfIdx_/g, metaFieldIdx);
        $("#mf-row-${assetFlow}-1").before(template);

        <%-- event listeners to reload results --%>
        $('#assets-filter-form-${assetFlow} :input[name=filterByMetaFieldValue'+metaFieldIdx+']').change(function () {
            $('#assets-filter-form-${assetFlow}').submit();
        });

        <%-- Show the correct widget to select a meta field value when metafield changes --%>
        $('#mf-id-${assetFlow}-'+metaFieldIdx).change(function () {
            showCorrectWidget${assetFlow}(this);
        }).change();

        <%-- Initialize the date picker --%>
        var options = $.datepicker.regional['${session.locale.language}'];
        if (options == null) options = $.datepicker.regional[''];

        options.dateFormat = "${message(code: 'datepicker.jquery.ui.format')}";
        options.buttonImage = "";

        $(".mfdate-${assetFlow}-"+metaFieldIdx).datepicker(options);
    }

    <%-- Show the correct widget to select a meta field value --%>
    function showCorrectWidget${assetFlow}(src) {
        var prefixLen = "mf-id-${assetFlow}-".length;
        var idx = $(src).prop('id').substring(prefixLen);
        var obj = $('.valuemarker-${assetFlow}-'+idx);
        obj.prop('disabled', true);
        obj.hide();

        obj = $('.valuemarker-div-${assetFlow}-'+idx);
        obj.hide();

        var baseSel = '#mf-val-'+$(src).val().split(':')[0];
        var sel = baseSel+'-${assetFlow}-'+idx;
        obj = $(sel);
        if(!obj.length) {
            baseSel = '#mf-val'
            sel = baseSel+'-${assetFlow}-'+idx;
            obj = $(sel);
        }
        obj.prop('disabled', false);
        obj.show();

        obj = $(baseSel+'-div-${assetFlow}-'+idx);
        if(obj.length) {
            obj.prop('disabled', false);
            obj.show();
        }

        $('#mf-val-${assetFlow}-'+idx).val('');
        <%-- reload the list--%>
        $('#assets-filter-form-${assetFlow}').submit();
    }

    var filterByValue${assetFlow} = '${message(code: 'assets.filter.by.default')}';

    <%-- event listeners to reload results --%>
    $('#assets-filter-form-${assetFlow} :input[name=filterBy]').blur(function () {
        if(filterByValue${assetFlow} != $('#assets-filter-form-${assetFlow} :input[name=filterBy]').val()) {
            filterByValue${assetFlow} = $('#assets-filter-form-${assetFlow} :input[name=filterBy]').val();
            $('#assets-filter-form-${assetFlow}').submit();
        }
    });
    $('#assets-filter-form-${assetFlow} :input[name=statusId]').change(function () {
        $('#assets-filter-form-${assetFlow}').submit();
    });

<g:if test="${assetMetaFields.size() > 0}" >
    <%-- event listeners to reload results for first metafield search line --%>
    $('#assets-filter-form-${assetFlow} :input[name=filterByMetaFieldValue1]').change(function () {
        $('#assets-filter-form-${assetFlow}').submit();
    });

    <%-- Show the correct widget to select a meta field value for first meta search line--%>
    $('#mf-id-${assetFlow}-1').change(function () {
       showCorrectWidget${assetFlow}(this);
    }).change();
</g:if>
$( document ).ready(function() {
	if(${assets.size() < 1}){
		$("#form-div-${assetFlow}").css("display", "none");
		$("#buttons-id-${assetFlow}").css("display", "none");
		$("#assets-table-${assetFlow}").html("${message(code: 'empty.assets.list')}");
	} else {
		$("#button-ok-${assetFlow}").css("display", "none");
	}
});

    <%-- Create a dialog to add a new asset --%>
    $( "#new-asset-dialog" ).dialog({
        autoOpen: false,
        width: 1200,
        height: 800,
        modal: true,
        dialogClass: "no-close",
        open: function () {
            if ($('#selected-assets-add > ul li').length > 1) {
                showButtonToAddProductWithAsset();
            }
        }
    });

    <%-- Close the new asset dialog. Function gets called by the close button in the dialog --%>
    function closeNewAssetDialog(event) {
        event.preventDefault();
        $( '#new-asset-dialog' ).dialog( "close" );
        $( '#new-asset-content').empty();
    }

    function openNewAssetDialog(event) {
        $( '#new-asset-dialog' ).dialog( "open" );
    }

    <%-- event called after a new asset is saved --%>
    function checkAssetSaveResponse(event) {
        <%-- If xml with a element asset is returned the save was successfull --%>
        if($('#new-asset-content > asset').length) {
            var anchor = $('#addNewAssetLink').html().replace(/_id_/g, $('#new-asset-content > asset').attr('id'));
            $( '#new-asset-dialog' ).dialog( "close" );
            $('#new-asset-content').html(anchor);
            $('#new-asset-content > a')[0].click();
            $('#new-asset-content').empty();
            showButtonToAddProductWithAsset();
        }
    }

    function showButtonToAddProductWithAsset() {
        $('#button-ok-add').hide();
        $('#buttons-id-add').show();
    }

    function cancelCreateAsset() {
        $( '#new-asset-dialog' ).dialog( "close" );
        $('#new-asset-content').empty();
    }

    $('#assets-dialog-${assetFlow}').dialog("open");
    placeholder();

    function updateSelectedAssets(element,checkedAssets) {
        var eName = "[name='" + element + "']"
        if($(eName).prop('checked')==true) {
            jAssetList.push($(eName).val());
        }
        else {
            var jAssetListAux = [];
            for(var i= 0; i<jAssetList.length; i++) {
                if(jAssetList[i]==$(eName).val()) {
                    jAssetList[i]=0;
                }
            }
            for(var i= 0, k=0; i<jAssetList.length; i++) {
                if(jAssetList[i]!=0) {
                    jAssetListAux[k++]=jAssetList[i];
                }
            }
            jAssetList=jAssetListAux;
        }
    }

    $("[name='reserve-remote-link']").click(function() {
        $.ajax({
            type: 'GET',
            url: '${createLink(controller: 'orderBuilder', action: 'edit')}',
            data: {_eventId:'reserve', userID:${params.userId}, assetsIDSList:jAssetList},
            success: function(data) {
                $("#assets-table-${assetFlow}").html(data);
                jAssetList=[]
            }
        });
    });

</script>
