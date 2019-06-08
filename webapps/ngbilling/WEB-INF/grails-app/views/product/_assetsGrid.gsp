<%@ page import="com.sapienter.jbilling.client.util.SortableCriteria" %>
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
<%@page import="java.lang.System"%>
<%@ page import="com.sapienter.jbilling.client.util.SortableCriteria; java.util.regex.Pattern; com.sapienter.jbilling.server.user.UserBL; com.sapienter.jbilling.server.user.contact.db.ContactDTO" %>

<g:set var="updateColumn" value="column1"/>
<g:set var="metaFieldIdxs" value="[]" />
<g:set var="metaFieldIMaxIdx" value="${new Integer(0)}" />
<g:set var="filtersUsed" value="${params.containsKey('_showDeleted')}" />
<%-- parameters the page functionality must include in URLs --%>
<g:set var="searchParams" value="${SortableCriteria.extractParameters(params, ['filterBy','statusId','showDeleted', Pattern.compile(/filterByMetaFieldId(\d+)/), Pattern.compile(/filterByMetaFieldValue(\d+)/)])}" />

<!-- table tag will hold our grid
    The updateColumn variable will allow us to identify whether this table
    is for showing entities (column1) or their children (column2)
-->
<div class="heading"><strong><g:message code="assets.for.product"/></strong></div>
<div class="box narrow">
    <div class="sub-box-no-pad">
        <!-- product info -->
        <table class="dataTable narrow" cellspacing="0" cellpadding="0">
            <tbody>
            <tr>
                <td><g:message code="product.detail.id"/></td>
                <td class="value"><g:link action="show" id="${product.id}">${product.id}</g:link></td>
                <td><g:message code="product.detail.internal.number"/></td>
                <td class="value"><g:link action="show" id="${product.id}">${product.internalNumber}</g:link></td>
            </tr>
            </tbody>
        </table>
    </div>
</div>

<div class="box-cards box-cards-no-margin ${filtersUsed ? "box-cards-open" : ""}">
    <div class="box-cards-title ${filtersUsed ? "active" : ""}">
        <a class="btn-open" href="#"><span><g:message
                code="asset.heading.filter"/></span></a>
    </div>

    <div class="box-card-hold narrow">
        <div class="form-columns asset-list-filters">
            <g:form name="asset-filter-form" id="${params.id}" action="assets">
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

                <g:applyLayout name="form/checkbox">
                    <content tag="label"><g:message code="filters.deleted.title"/></content>
                    <content tag="label.for">showDeleted</content>
                    <g:checkBox name="showDeleted" class="field default" checked="${'on' == params.showDeleted}"/>
                </g:applyLayout>

                <g:if test="${metaFields.size() > 0}">
                    <%
                        Pattern pattern = Pattern.compile(/filterByMetaFieldId(\d+)/)
                        //get all the ids in an array
                        params.each {
                            def m = pattern.matcher(it.key)
                            if (m.matches()) {
                                metaFieldIdxs << m.group(1)
                            }
                        }
                        metaFieldIMaxIdx = metaFieldIdxs.max() as Integer ?: 0
                    %>
                    <div id="mf-row-holder"></div>
                    <g:if test="${metaFieldIdxs}">
                        <g:set var="lastIdx" value="${metaFieldIdxs.last()}"/>
                        <g:each in="${metaFieldIdxs}" var="metaFieldIndex">

                            <g:render template="assetsMetaFieldFilter"
                                      model="[assetMetaFields: metaFields, metaFieldIdx: metaFieldIndex, addButton: (lastIdx == metaFieldIndex), removeButton: (lastIdx != metaFieldIndex), initDatePicker: true]"/>
                        </g:each>
                    </g:if>
                    <g:else>
                        <g:render template="assetsMetaFieldFilter"
                                  model="[assetMetaFields: metaFields, metaFieldIdx: (metaFieldIMaxIdx + 1), addButton: true, initDatePicker: true]"/>
                    </g:else>
                </g:if>
            </g:form>
        </div>
    </div>
</div>
<p/>
<g:if test="${metaFields.size() > 0}">
<%-- Template used for adding metafields to search --%>
    <div id="metafield-filter-template" style="display: none">
        <g:render template="assetsMetaFieldFilter"
                  model="[assetMetaFields: metaFields, metaFieldIdx: '_mfIdx_', removeButton: true]"/>
    </div>
</g:if>


<table id="data_grid_${updateColumn}" class="scroll jqTable" cellpadding="0" cellspacing="0"></table>
<!-- pager will hold our paginator -->
<div id="data_grid_pager_${updateColumn}" class="scroll" style="text-align:center;"></div>

<div class="btn-box">
    <div class="row"></div>
</div>

<div id="showLink" style="display: none;">
    <g:remoteLink class="cell" action="showAsset" params="['template': 'showAsset']" id="_id_" before="register(this);" onSuccess="render(data, next); animateToTheTop();">

    </g:remoteLink>
</div>

<div id="execShowLink" style="display: none;">
</div>
<div class="btn-box">
        <g:link action="editAsset" params="[add: 'true', prodId: product.id]" class="submit add"><span><g:message code="button.create"/></span></g:link>

        <g:remoteLink class="submit add" action="showUploadAssets" params="[prodId: product.id]" before="register(this);" onSuccess="render(data, next);">
            <span><g:message code="button.assets.upload"/></span>
        </g:remoteLink>
</div>
<script type="text/javascript">// <![CDATA[
/* when the page has finished loading.. execute the follow */
var gLastCategorySel = '';
var jqTableGrid = $('#data_grid_${updateColumn}');
var jqTablePager = $('#data_grid_pager_${updateColumn}');
$(document).ready(function () {
    $(jqTableGrid).jqGrid({
        url:'<g:createLink action="findAssets" id="${params.id}" params="${params}"/>',
        datatype: "json",
        colNames:[
            '<g:message code="asset.table.th.identifier"/>',
            '<g:message code="asset.table.th.creationDate"/>',
            '<g:message code="asset.table.th.status"/>',
            '<g:message code="asset.table.th.entity.description"/>'
        ],
        colModel:[
            { name: 'assetId', editable: false, search:true, sortable:true,formatter: assetsFormatter},
            { name: 'createDatetime', editable: false, search:false, sortable:true,formatter: 'date', formatOption:{newFormat:'<g:message code="date.pretty.format"/>'}},
            { name: 'status', editable: false, search:false, sortable:true}<g:isRoot>,
            { name: 'company', editable: false, search:false, sortable:true, formatter: companyFormatter}</g:isRoot>

        ],
        sortname: '',
        sortorder: 'desc',
        autowidth: true,
        height: 'auto',
        rowNum: 20,
        rowList: [10,20,50],
        pager: $(jqTablePager),
        viewrecords: true,
        gridview: true,
        onSelectRow: function(id){
            if(id && id!==gLastCategorySel){
                var content = $('#showLink').clone().html().replace(/_id_/g, id);
                $("#execShowLink").html(content);
                $("#execShowLink > a").click();
                gLastCategorySel=id;
            }
        }
    }).navGrid('#data_grid_pager_${updateColumn}',
            {   add:false,edit:false,del:false,search:false,refresh:false,csv:false
            }, // which buttons to show?
            // edit options
            {},
            // add options
            {},
            // delete options
            {}
    );

    $(jqTableGrid).jqGrid('filterToolbar',{autosearch:true});

});

function isRowSelected(id) {
    //console.log("id:"+id+" gLastCategorySel:"+gLastCategorySel);
    return gLastCategorySel == id;
}

function animateToTheTop(){
    $('html, body').animate({ scrollTop: 0 }, 'fast');
}
function companyFormatter (cellvalue, options, rowObject) {
    var content;
    if (rowObject.global){
        content = '<strong><g:message code="product.label.company.global"/></strong>'
    }else if (rowObject.multiple){
        content = '<strong><g:message code="product.label.company.multiple"/></strong>'
    }else {
        content = rowObject.company
    }
    return content
}
function assetsFormatter (cellvalue, options, rowObject) {
    var assetIdDisplay = '<em><g:message code="table.id.format" args="['_assetId_']"/></em>'
    var content = '<div class="medium"><strong>' + rowObject.identifier + '</strong></div>' + assetIdDisplay;
    return content.replace(/_assetId_/g, cellvalue)
}
// ]]></script>

<script type="text/javascript">
    //required by the meta field java script included
    var metaFieldIdx = ${metaFieldIMaxIdx + 3};
    var localLang = '${session.locale.language}';
    var pickerDateFormat = "${message(code: 'datepicker.jquery.ui.format')}";
    var assetSearchFormId = 'asset-filter-form';
    <%-- function which will search for assets --%>
    var assetSearchFunction = function() {
        $('#'+assetSearchFormId).submit();
    };

</script>

<script src="${resource(dir: 'js', file:'asset-metafield-search-fields.js')}" ></script>

<script type="text/javascript">
    $('#statusId').val('${params.statusId}');
    <%-- event listeners to reload results --%>
    $('#asset-filter-form :input[name=filterBy]').blur(function () {
        $('#asset-filter-form').submit();
    });
    $('#asset-filter-form :input[name=statusId]').change(function () {
        $('#asset-filter-form').submit();
    });
    $('#asset-filter-form :input[name=showDeleted]').change(function () {
        $('#asset-filter-form').submit();
    });

    <g:if test="${metaFields.size() > 0 && metaFieldIdxs.size() == 0}" >
    <%-- event listeners to reload results for first metafield search line if there is no previous search--%>
    $('#asset-filter-form :input[name=filterByMetaFieldValue${metaFieldIMaxIdx + 1}]').change(function () {
        $('#asset-filter-form').submit();
    });

    <%-- Show the correct widget to select a meta field value for first meta search line--%>
    $('#mf-id-${metaFieldIMaxIdx + 1}').change(function () {
        showCorrectWidget(this);
    });
    showCorrectWidget($('#mf-id-${metaFieldIMaxIdx + 1}'), true);
    </g:if>

    <g:each in="${metaFieldIdxs}" var="metaFieldIndex">
    <%-- event listeners to reload results for metafield search lines after first search --%>
    $('#asset-filter-form :input[name=filterByMetaFieldValue${metaFieldIndex}]').change(function () {
        $('#asset-filter-form').submit();
    });

    <%-- Show the correct widget to select a meta field value for metafield search lines after first search --%>
    $('#mf-id-${metaFieldIndex}').change(function () {
        showCorrectWidget(this);
    });
    showCorrectWidget($('#mf-id-${metaFieldIndex}'), true);
    </g:each>

    <g:if test="${params.partial}" >
    <%-- register for the slide events if it is loaded by pagination --%>
    registerSlideEvents();
    </g:if>
    placeholder();
</script>
