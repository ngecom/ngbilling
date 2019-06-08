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

<g:set var="updateColumn" value="${actionName == 'allProducts' || selectedProduct ? 'column1' : 'column2'}"/>
<g:set var="updateColumn" value="${params.applyFilter ? 'column2' : updateColumn}"/>
<g:set var="selectedCategoryId" value="${selectedCategory?.id}"/>
<!-- table tag will hold our grid
    The updateColumn variable will allow us to identify whether this table
    is for showing product categories (column1) or products (column2)
-->

<%-- no products to show --%>
<div id="grid_messages" style="display: none;">
    <div class="heading"><strong><em><g:message code="product.category.no.products.title"/></em></strong></div>
    <div class="box">
        <div class="sub-box">
            <g:if test="${selectedCategoryId}">
                <em><g:message code="product.category.no.products.warning"/></em>
            </g:if>
            <g:else>
                <em><g:message code="product.category.not.selected.message"/></em>
            </g:else>
        </div>
    </div>
</div>

<div id ="jqGridContainer_${updateColumn}">

    <table id="data_grid_${updateColumn}" class="scroll jqTable" cellpadding="0" cellspacing="0"></table>
    <!-- pager will hold our paginator -->
    <div id="data_grid_pager_${updateColumn}" class="scroll" style="text-align:center;"></div>

</div>

<div class="btn-box">
    <g:if test="${selectedCategoryId}">
        <sec:ifAllGranted roles="PRODUCT_40">
            <g:link action="editProduct" params="['category': selectedCategoryId]" class="submit add"><span><g:message code="button.create.product"/></span></g:link>
        </sec:ifAllGranted>

        <span id="grid_delete_category" style="display: none;">
            <sec:ifAllGranted roles="PRODUCT_CATEGORY_52">
                <a onclick="showConfirm('deleteCategory-${selectedCategoryId}');" class="submit delete"><span><g:message code="button.delete.category"/></span></a>
            </sec:ifAllGranted>
        </span>
    </g:if>
    <g:elseif test="${!params.action.equals("allProducts")}">
        <em><g:message code="product.category.not.selected.message"/></em>
    </g:elseif>
    <sec:access url="/product/allProducts">
        <g:remoteLink action="allProducts" update="column1" class="submit show" onSuccess="\$('.submit.show').hide(); closePanel(\'#column2\');" ><span><g:message code="button.show.all"/></span></g:remoteLink>
    </sec:access>
</div>

<g:render template="/confirm"
          model="['message':'product.category.delete.confirm',
                  'controller':'product',
                  'action':'deleteCategory',
                  'id':selectedCategoryId,
                  'ajax':true,
                  'update':'column1',
                  'onYes': 'closePanel(\'#column2\')'
          ]"/>

<div id="showLink${updateColumn}" style="display: none;">
    <g:remoteLink class="cell" action="show" params="['template': 'show', 'category': selectedCategoryId]" id="_id_" before="register(this);" onSuccess="render(data, next);">

    </g:remoteLink>
</div>

<div id="execShowLink${updateColumn}" style="display: none;">
</div>

<script type="text/javascript">// <![CDATA[
/* when the page has finished loading.. execute the follow */
var gLastSel = -1;
var search;
var jqTableGrid${updateColumn} = $('#' + '${updateColumn}' + ' #data_grid_${updateColumn}');
var jqTablePager${updateColumn} = $('#' + '${updateColumn}' + ' #data_grid_pager_${updateColumn}');

$(document).ready(function () {
    loadJQGrid();
});

function loadJQGrid(){
    $(jqTableGrid${updateColumn}).jqGrid({
        url:'<g:createLink action="${actionName == 'allProducts' ? 'findAllProducts' : 'findProducts'}" id="${selectedCategoryId}"/>',
        datatype: "json",
        colNames:[
            '<g:message code="product.detail.id"/>',
            <g:isRoot>'<g:message code="product.label.company.name"/>',</g:isRoot>
            '<g:message code="product.th.internal.number"/>'
        ],
        colModel:[
            { name: 'productId', editable: false, width: 150, formatter: productNameFormatter},
                <g:isRoot>{ name: 'company', editable: false, formatter: companyFormatter }, </g:isRoot>
            { name: 'number', editable: false}
        ],
        sortname: 'productId',
        sortorder: 'desc',
        autowidth: true,
        height: 'auto',
        rowNum: 20,
        rowList: [10,20,50],
        pager: $(jqTablePager${updateColumn}),
        viewrecords: true,
        gridview: true,
        onSelectRow: function(id){
            if(id && id!==gLastSel){
                var content = $('#showLink${updateColumn}').clone().html().replace(/_id_/g, id);
                $("#execShowLink${updateColumn}").html(content);
                $("#execShowLink${updateColumn} > a").click();
                gLastSel=id;
            }
        },
        loadComplete: function(data) {
            processRows();
        },
        loadError: function(){
            processRows();
        }
    }).navGrid('#data_grid_pager_${updateColumn}',
            {   add:false,edit:false,del:false,search:false,refresh:true,csv:true
            }, // which buttons to show?
            // edit options
            {},
            // add options
            {},
            // delete options
            {}
    ).jqGrid('navButtonAdd', '#data_grid_pager_${updateColumn}', {caption: 'csv', onClickButton: downloadFilteredCsv, title:'<g:message code="jqview.download.csv.filtered.tip" />' });

    $(jqTableGrid${updateColumn}).jqGrid('filterToolbar',{autosearch:true, beforeSearch:beforeSearch});
}

function beforeSearch () {
    search = true;
}

function companyFormatter (cellvalue, options, rowObject) {
    var content;
    if (rowObject.global){
        content = '<strong><g:message code="product.label.company.global"/></strong>'
    }else if (rowObject.multiple){
        content = '<strong><g:message code="product.label.company.multiple"/></strong>'
    }else {
        content = cellvalue
    }
    return content
}

function productNameFormatter (cellvalue, options, rowObject) {
    var maxSize = 45;
    var productName = rowObject.name
    if (!productName){
        productName = ''
    }
    productName = productName.length>maxSize ? productName.substr(0,maxSize-1)+'&hellip;' : productName;
    var productIdDisplay = '<em><g:message code="table.id.format" args="['_productId_']"/></em>'
    var content = '<div class="medium"><strong>' + productName + '</strong></div>' + productIdDisplay;
    return content.replace(/_productId_/g, cellvalue)
}

function downloadFilteredCsv() {
    $(jqTableGrid${updateColumn}).jqGrid('excelExport',{tag:'csv', url:'<g:createLink controller="product" action="csv" id="${selectedCategoryId}"/>'});
}

function processRows() {
    var rowCount = $(jqTableGrid${updateColumn}).getGridParam("reccount")
    var categorySelected = '${selectedCategoryId}'
    var showingAllProducts = "${actionName == 'allProducts' ? 'yes':''}"
    if (!categorySelected && !showingAllProducts){
        $("#grid_messages").show();
        $("#grid_delete_category").hide();
        hideJQGrid()
        return
    }
    if (rowCount == 0 && !search){
        $("#grid_messages").show();
        $("#grid_delete_category").show();
        hideJQGrid()
    } else {
        $("#grid_messages").hide();
        $("#grid_delete_category").hide();
        showJQGrid()
    }
}

function hideJQGrid() {
    $('#jqGridContainer_${updateColumn}').hide();
}

function showJQGrid() {
    $('#jqGridContainer_${updateColumn}').show();
}

function isRowSelected(id) {
    //console.log("id:"+id+" gLastSel:"+gLastSel);
    return gLastSel == id;
}

function editCategory() {
    $("#execEditLink > a")[0].click();
    return false;
}

// ]]></script>
