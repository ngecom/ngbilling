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

<g:set var="updateColumn" value="column1"/>

<!-- table tag will hold our grid
    The updateColumn variable will allow us to identify whether this table
    is for showing users (column1) or subaccounts (column2)
-->

<table id="data_grid_${updateColumn}" class="scroll jqTable" cellpadding="0" cellspacing="0"></table>
<!-- pager will hold our paginator -->
<div id="data_grid_pager_${updateColumn}" class="scroll" style="text-align:center;"></div>

<div class="btn-box">
    <sec:ifAllGranted roles="PRODUCT_CATEGORY_50">
        <g:link action="editCategory" class="submit add" params="${[add: true]}"><span><g:message code="button.create.category"/></span></g:link>
    </sec:ifAllGranted>

    <sec:ifAllGranted roles="PRODUCT_CATEGORY_51">
        <a href="#" onclick="return editCategory();" class="submit edit"><span><g:message code="button.edit"/></span></a>
    </sec:ifAllGranted>
</div>

<div id="showLink" style="display: none;">
    <g:remoteLink class="cell" action="products" params="[categoryId:'_id_']" id="_id_" before="register(this);" onSuccess="render(data, next);">

    </g:remoteLink>
</div>

<div id="execShowLink" style="display: none;">
</div>

<div id="editLink" style="display: none;">
    <g:link class="cell" action="editCategory" params="['template': 'show', 'category': _id_]" id="_id_" onClick="a_onClick()">

    </g:link>
</div>

<div id="execEditLink" style="display: none;">
</div>
<!-- edit category control form -->
<g:form name="categoryEditFormTemplate" controller="product" action="editCategory">
    <g:hiddenField name="id" id="editformSelectedCategoryId" value="_categoryId_"/>
</g:form>

<g:form name="category-edit-form" controller="product" action="editCategory">
</g:form>

<script type="text/javascript">// <![CDATA[
/* when the page has finished loading.. execute the follow */
var gridLastCategorySel = -1;
var jqTableGrid${updateColumn} = $('#' + '${updateColumn}' + ' #data_grid_${updateColumn}');
var jqTablePager${updateColumn} = $('#' + '${updateColumn}' + ' #data_grid_pager_${updateColumn}');
$(document).ready(function () {
    $(jqTableGrid${updateColumn}).jqGrid({
        url:'<g:createLink action="findCategories"/>',
        datatype: "json",
        colNames:[
            '<g:message code="product.category.th.name"/>',
            <g:isRoot>'<g:message code="product.label.company.name"/>',</g:isRoot>
            '<g:message code="product.category.th.type"/>'
        ],
        colModel:[
            { name: 'categoryId', editable: false, width: 90, search: false, sortable:false, formatter: categoryFormatter},
            <g:isRoot>{ name: 'company', editable: false, search: false, sortable:false, formatter: companyFormatter }, </g:isRoot>
            { name: 'lineType', editable: false, search: false, sortable:false, formatter: descriptionFormatter }
        ],
        sortname: 'categoryId',
        sortorder: 'desc',
        autowidth: true,
        height: 'auto',
        rowNum: 20,
        rowList: [10,20,50],
        pager: $(jqTablePager${updateColumn}),
        viewrecords: true,
        gridview: true,
        onSelectRow: function(id){
            if(id && id!==gridLastCategorySel){
                var content = $('#showLink').clone().html().replace(/_id_/g, id);
                $("#execShowLink").html(content);
                var content = $('#editLink').clone().html().replace(/_id_/g, id);
                $("#execEditLink").html(content);
                $("#execShowLink > a").click();
                gridLastCategorySel=id;
            }
        }
    }).navGrid('#data_grid_pager_${updateColumn}',
            {   add:false,edit:false,del:false,search:false,refresh:true,csv:false
            }, // which buttons to show?
            // edit options
            {},
            // add options
            {},
            // delete options
            {}
    );

    $(jqTableGrid${updateColumn}).jqGrid('filterToolbar',{autosearch:true});

});

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

function categoryFormatter (cellvalue, options, rowObject) {
    var categoryIdDisplay = '<em><g:message code="table.id.format" args="['_categoryId_']"/></em>'
    var content = '<div class="medium"><strong>' + rowObject.name + '</strong></div>' + categoryIdDisplay;
    return content.replace(/_categoryId_/g, cellvalue)
}

function descriptionFormatter (cellvalue, options, rowObject) {
    return cellvalue.description;
}

function downloadFilteredCsv() {
    $(jqTableGrid${updateColumn}).jqGrid('excelExport',{tag:'csv', url:'<g:createLink controller="product" action="csv"/>'});
}

function isRowSelected(id) {
    //console.log("id:"+id+" gridLastCategorySel:"+gridLastCategorySel);
    return gridLastCategorySel == id;
}

function editCategory() {
    $("#execEditLink > a")[0].click();
    return false;
}
// ]]></script>
