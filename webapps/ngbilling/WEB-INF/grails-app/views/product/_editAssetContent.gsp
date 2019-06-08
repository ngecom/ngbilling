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

<%@ page import="com.sapienter.jbilling.server.item.db.ItemTypeDTO; com.sapienter.jbilling.server.metafields.MetaFieldBL; com.sapienter.jbilling.server.item.db.AssetDTO" %>

<%--
  Form for editing an asset

 @author Gerhard Maree
 @since  18-Apr-2013
--%>

    <g:set var="isNew" value="${!asset || !asset?.id || asset?.id == 0}"/>
    <g:render template="/layouts/includes/messages"/>
    <div class="heading">
        <strong>
            <g:if test="${isNew}">
                <g:message code="product.asset.add.title"/>
            </g:if>
            <g:else>
                <g:message code="product.asset.edit.title"/>
            </g:else>
        </strong>
    </div>

    <div class="form-hold">
        <g:formRemote name="save-asset-form" url="[action:'saveAsset']" update="new-asset-content"  onSuccess="checkAssetSaveResponse(event);">
            <fieldset>
                <div class="form-columns">

                    <%-- Base asset details --%>
                    <div class="column">
                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="asset.detail.id"/></content>

                            <g:if test="${isNew}"><em><g:message code="prompt.id.new"/></em></g:if>
                            <g:else>${asset?.id}</g:else>

                            <g:hiddenField name="id" value="${asset?.id}"/>
                            <g:hiddenField name="itemId" value="${asset.item.id}"/>
                            <g:hiddenField name="categoryId" value="${categoryAssetMgmt.id}"/>
                            <g:hiddenField name="partial" value="${partial}"/>
                            <g:hiddenField name="userCompanyMandatory" value="${userCompanyMandatory}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label">${categoryAssetMgmt.assetIdentifierLabel ?: g.message([code: "asset.detail.identifier"])}</content>
                            <content tag="label.for">identifier</content>
                            <g:textField class="field" name="identifier" value="${asset?.identifier}"/>
                        </g:applyLayout>

                        <g:if test="${asset.assetStatus?.isInternal == 1 || asset.assetStatus?.isOrderSaved == 1}">
                            <g:applyLayout name="form/text">
                                <content tag="label"><g:message code="asset.detail.assetStatus"/></content>
                                <g:hiddenField name="assetStatusId" value="${asset.assetStatus.id}"/>
                                ${asset.assetStatus.description}
                            </g:applyLayout>
                        </g:if>
                        <g:else>
                            <g:applyLayout name="form/select">
                                <content tag="label"><g:message code="asset.detail.assetStatus"/></content>
                                <g:select name="assetStatusId" from="${statuses}"
                                          optionKey="id" optionValue="description"
                                          value="${asset.assetStatus?.id}"/>
                            </g:applyLayout>
                        </g:else>

                        <g:applyLayout name="form/checkbox">
                            <content tag="label"><g:message code="asset.detail.isGroup"/></content>
                            <content tag="label.for">isGroup</content>
                            <g:checkBox id="asset-isGroup" class="field" name="isGroup"
                                        checked="${asset?.containedAssets.size() > 0}"
                                        class="cb checkbox" onchange="showAssetGroup()"/>
                        </g:applyLayout>
							<g:isGlobal>
                                <g:if test="${asset.item.isGlobal()}">
                                    <g:applyLayout name="form/checkbox">
                                        <content tag="label"><g:message code="product.assign.global"/></content>
                                        <content tag="label.for">asset?.global</content>
                                        <g:checkBox id="global-checkbox"
                                                    onClick="hideCompanies()"
                                                    class="cb checkbox" name="global" checked="${asset?.global}"/>
                                    </g:applyLayout>
                                </g:if>
	                        	</g:isGlobal>
	                        	<g:isNotRoot>
	                        		<g:hiddenField name="global" value="${asset?.global}"/>
	                        	</g:isNotRoot>
	                        
	                        	<div id="childCompanies">          
	                       		<g:isRoot>
	                       			<g:applyLayout name="form/select">
	                           			<content tag="label"><g:message code="product.assign.entities"/></content>
	                           			<content tag="label.for">asset.entities</content>
	                           			<g:select id="company-select" multiple="multiple" name="entities" from="${companies}"
	                                   			  optionKey="id" optionValue="${{it?.description}}"
	                           	    	    	  value="${companies*.id.size == 1 ? companies?.id : asset.entities?.id}"
	                           	    	    	  onChange="${remoteFunction(action: 'retrieveMetaFields',
	                  										  update: 'product-metafields',
	                  										  params: '\'entities=\' + getSelectValues(this)')}"/>
	                        		</g:applyLayout>
	                        	</g:isRoot>
	                        	<g:isNotRoot>     
	                        		<g:if test="${asset?.entities?.size()>0}">                   		
		                        		<g:each in="${asset?.entities}">
		                        			<g:hiddenField name="entities" value="${it}"/>
		                        		</g:each>
	                        		</g:if>
	                        		<g:else>
	                        				<g:hiddenField name="entities" value="${session['company_id']}"/>
									</g:else>
	                        	</g:isNotRoot>
	                        </div>
                        <g:if test="${!isNew}">
                            <g:applyLayout name="form/text">
                                <content tag="label"><g:message code="asset.detail.createDatetime"/></content>
                                <g:formatDate format="dd-MM-yyyy HH:mm" date="${asset.createDatetime}"/>
                            </g:applyLayout>

                            <g:applyLayout name="form/text">
                                <content tag="label"><g:message code="asset.detail.order"/></content>
                                ${asset.orderLine?.purchaseOrder?.id}
                            </g:applyLayout>
                        </g:if>

                        <g:render template="/metaFields/editMetaFields" model="[ availableFields: categoryAssetMgmt.assetMetaFields, fieldValues: MetaFieldBL.convertMetaFieldsToWS(categoryAssetMgmt.assetMetaFields, asset) ]"/>

                    </div>

                    <div class="column">
                        <g:applyLayout name="form/textarea">
                            <content tag="label"><g:message code="asset.detail.notes"/></content>
                            <content tag="label.for">notes</content>
                            <g:textArea class="narrow" name="notes" value="${asset.notes}" rows="5" cols="45"/>
                        </g:applyLayout>

                    </div>

                </div>

                <div>
                    <br/>&nbsp;
                </div>

                <%-- Assigning assets to groups --%>
                <div id="group-assets-view" class="box-cards box-cards-open">
                    <div class="box-cards-title">
                        <a class="btn-open" href="#"><span><g:message code="asset.group.member.assets"/></span></a>
                    </div>
                    <div class="box-card-hold">

                        <div class="form-columns">

                        <%-- Asset search --%>
                            <div class="column wide2">
                                <div class="heading"><strong><g:message code="asset.heading.filter"/></strong></div>
                                <div class="box narrow">
                                    <div id="group-search-holder" class="sub-box-no-pad asset-group-filters">
                                        <g:if test="${!isNew}">
                                            <input type="hidden" class="group-search-filter" name="searchAssetId" value="${asset.id}" />
                                            <input type="hidden" class="group-search-filter" name="searchIncludedAssetId" value="${asset.containedAssets.collect{it.id}.join(',')}" />
                                        </g:if>
                                        <input type="hidden" class="group-search-filter" name="searchExcludedAssetId" id="searchExcludedAssetId" value="" />
                                        <g:applyLayout name="form/input">
                                            <content tag="label"><g:message code="filters.title"/></content>
                                            <content tag="label.for">filterBy</content>
                                            <g:textField name="filterBy" class="field default group-search-filter"
                                                         placeholder="${message(code: 'assets.filter.by.default')}" value="${params.filterBy}"/>
                                        </g:applyLayout>

                                        <g:applyLayout name="form/select">
                                            <content tag="label"><g:message code="asset.label.category"/></content>
                                            <content tag="label.for">categoryId</content>
                                            <g:select name="searchCategoryId" from="${availableCategories}" class="group-search-filter"
                                                      noSelection="['': message(code: 'filters.asset.status.empty')]"
                                                      optionKey="id" optionValue="description"
                                                      onchange="loadCategoryFilters(this);"
                                                      value="${params.categoryId}"/>
                                        </g:applyLayout>

                                        <div id="category-filters">
                                            <g:render template="groupSearchFilter" model="[products: [], assetStatuses: [], metaFields: []]" />
                                        </div>
                                    </div>

                                    <%-- Search results --%>
                                </div>
                                <div id="asset-search-results"></div>
                            </div>

                            <%-- Chosen assets --%>
                            <div class="column">
                                <div id="" class="">
                                    <div class="heading">
                                        <span><g:message code="asset.group.chosen.assets"/></span>
                                    </div>

                                    <div class="box">

                                        <div class="table-box">
                                            <table cellspacing="0" cellpadding="0">
                                                <tbody id="group-selected-assets">
                                                <g:each in="${asset.containedAssets}" var="containedAsset" >
                                                    <tr id="group-asset-${containedAsset.id}" class="${selected?.id == asset.id ? 'active' : ''}">
                                                        <td class="narrow" >
                                                            <em class="narrow">${containedAsset.identifier}</em>
                                                        </td>
                                                        <td class="narrow">
                                                            <span class="narrow"><g:formatDate format="dd-MM-yyyy HH:mm" date="${containedAsset.createDatetime}"/></span>
                                                        </td>
                                                        <td class="narrow">
                                                            <span class="narrow">${containedAsset.assetStatus.description}</span>
                                                        </td>
                                                        <td class="tiny narrow">
                                                            <a onclick="removeAssetFromGroup(this);"><span class="narrow"><img src="${resource(dir: 'images', file: 'cross.png')}" /></span></a>
                                                        </td>
                                                    </tr>
                                                </g:each>
                                                </tbody>
                                            </table>
                                        </div>

                                    </div>

                                </div>
                            </div>
                            <input id="containedAssetIds" type="hidden" name="containedAssetIds" />
                        </div>
                    </div>
                </div>
                <div class="buttons">
                    <ul>
                        <li>
                            <a onclick="$('#save-asset-form').submit();" class="submit save"><span><g:message
                                    code="button.save"/></span></a>
                        </li>
                        <li>
                            <a onclick="cancelCreateAsset();" class="submit cancel"><span><g:message
                                    code="button.cancel"/></span></a>
                        </li>
                    </ul>
                </div>
            </fieldset>
        </g:formRemote>
    </div>

<div style="display: none;" >
    <g:formRemote name="loadFilters" url="[action:'loadAssetGroupFilters']" update="category-filters" method="GET">
        <g:hiddenField id="loadFilters-categoryId" name="categoryId" />
    </g:formRemote>

    <g:formRemote name="group-asset-search" url="[action: 'groupAssetSearch']" update="asset-search-results">
    </g:formRemote>
</div>

<script type="text/javascript">

	$(document).ready(function() {
		if ($("#global-checkbox").is(":checked")) {
	    	$("#company-select").attr('disabled', true);
	   	}
	});
	
	function hideCompanies() {
		if ($("#global-checkbox").is(":checked")) {
			$("#company-select").attr('disabled', true);
		} else {
			$("#company-select").removeAttr('disabled');
		}
	}

    <%-- Load the statuses, products and meta fields for the chosen category--%>
    function loadCategoryFilters(obj) {
        $('#loadFilters-categoryId').val($(obj).val());
        $('#loadFilters').submit();
    }

    <%-- Do asset search --%>
    function searchAssetsForGroup() {
        $('#group-asset-search').empty();
        $(".group-search-filter").each(function(idx) {
            var clone = $(this).clone();
            $("#group-asset-search").append(clone);
            clone.val($(this).val())
        });
        $(".mf-input").each(function(idx) {
            var clone = $(this).clone();
            $("#group-asset-search").append(clone);
            clone.val($(this).val())
        });
        $('#group-asset-search').submit();
    }

    <%-- Add the selected asset from the search results to the list of chosen assets--%>
    function addAssetToSelected(obj) {
        var row = $(obj).closest("tr").remove();
        row.off('click');

        <%-- Check if the row is not already in the list of selected assets --%>
        if($('#group-selected-assets #'+row.attr('id')).length == 0) {
            $('#group-selected-assets').append(row);
            row.append('<td class="tiny narrow"><a onclick="removeAssetFromGroup(this);"><span class="narrow"><img src="${resource(dir: 'images', file: 'cross.png')}" /></span></a></td>');
        }

        updateContainedAssetIds();
    }

    <%-- Update the input which contains the list of group asset ids--%>
    function updateContainedAssetIds() {
        var assetIds = '';
        $('#group-selected-assets tr').each(function(idx) {
            if(idx > 0) assetIds += ',';
            var id = $(this).attr('id');
            assetIds += id.substring(id.lastIndexOf('-')+1);
        });
        $('#containedAssetIds').val(assetIds);
        $('#searchExcludedAssetId').val(assetIds);
    }

    function removeAssetFromGroup(obj) {
        var clone = $(obj).closest("tr").remove();
        clone.find("td")[3].remove();
        $("table#users tbody").append(clone);
        updateContainedAssetIds();
    }

    <%-- Display the asset group portion of the screen --%>
    function showAssetGroup() {
        var allow = $("#asset-isGroup").prop("checked");

        $("#group-assets-view").css("display", (allow?"block":"none"));
        $('#group-asset-search').submit();
    }

    <%-- event listeners to reload results --%>
    $('#group-search-holder :input[name=filterBy]').blur(function () {
        searchAssetsForGroup();
    });

    var assetSearchFunction = searchAssetsForGroup;

    updateContainedAssetIds();
    showAssetGroup();

    $(document).on('click', "table#users tbody tr", function(event) {
        addAssetToSelected(this);
    });

</script>
