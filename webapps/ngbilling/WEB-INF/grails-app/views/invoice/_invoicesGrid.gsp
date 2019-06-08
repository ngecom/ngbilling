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

<g:set var="processId" value="${actionName == 'byProcess' ? params.id : null}"/>
<g:set var="csvAction" value="${actionName == 'byProcess' ? 'csvByProcess' : 'csv'}"/>
<g:set var="updateColumn" value="column1"/>

<!-- table tag will hold our grid
    The updateColumn variable will allow us to identify whether this table
    is for showing entities (column1) or their children (column2)
-->

<table id="data_grid_${updateColumn}" class="scroll jqTable" cellpadding="0" cellspacing="0"></table>
<!-- pager will hold our paginator -->
<div id="data_grid_pager_${updateColumn}" class="scroll" style="text-align:center;"></div>

<div class="btn-box">
    <div class="row"></div>
</div>

<div id="showLink" style="display: none;">
    <g:remoteLink class="cell" action="show" id="_id_" before="register(this);" onSuccess="render(data, next);">

    </g:remoteLink>
</div>

<div id="execShowLink" style="display: none;">
</div>

<script type="text/javascript">// <![CDATA[
/* when the page has finished loading.. execute the follow */
var gLastSel = -1;
var jqTableGrid = $('#' + '${updateColumn}' + ' #data_grid_${updateColumn}');
var jqTablePager = $('#' + '${updateColumn}' + ' #data_grid_pager_${updateColumn}');
$(document).ready(function () {
    $(jqTableGrid).jqGrid({
        url:'<g:createLink action="${actionName == 'byProcess' ? 'findByProcess' : 'findInvoices'}" id="${processId}"/>',
        datatype: "json",
        colNames:[
            '<g:message code="invoice.label.id"/>',
            '<g:message code="invoice.label.customer"/>',
            <g:isRoot>'<g:message code="invoice.label.company.name"/>',</g:isRoot>
            '<g:message code="invoice.label.duedate"/>',
            '<g:message code="invoice.label.status"/>',
            '<g:message code="invoice.label.amount"/>',
            '<g:message code="invoice.label.balance"/>'
        ],
        colModel:[
            { name: 'invoiceId', editable: false, width: 90, formatter: invoiceFormatter },
            { name: 'userName', editable: false },
            <g:isRoot>{ name: 'company', editable: false }, </g:isRoot>
            { name: 'dueDate', editable: false, width: 90, search: false, formatter: 'date' , formatOption:{newFormat:'<g:message code="date.pretty.format"/>'}},
            { name: 'status', editable: false, width: 90, search: false, formatter: descriptionFormatter },
            { name: 'amount', editable: false, width: 90, search: false, formatter: balanceFormatter },
            { name: 'balance', editable: false, search: false, formatter: balanceFormatter }
        ],
        sortname: 'invoiceId',
        sortorder: 'desc',
        autowidth: true,
        height: 'auto',
        rowNum: 20,
        rowList: [10,20,50],
        pager: $(jqTablePager),
        viewrecords: true,
        gridview: true,
        onSelectRow: function(id){
            if(id && id!==gLastSel){
                var content = $('#showLink').clone().html().replace(/_id_/g, id);
                $("#execShowLink").html(content);
                $("#execShowLink > a").click();
                gLastSel=id;
            }
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
    ).jqGrid('navButtonAdd', '#data_grid_pager_${updateColumn}',
            {caption: 'csv', onClickButton: downloadFilteredCsv, title:'<g:message code="jqview.download.csv.filtered.tip" />'}
    ).jqGrid('navButtonAdd', '#data_grid_pager_${updateColumn}',
            {caption: 'pdf', onClickButton: downloadFilteredPdf, title:'<g:message code="jqview.download.pdf.filtered.tip" />'});

    $(jqTableGrid).jqGrid('filterToolbar',{autosearch:true});

});

function invoiceFormatter (cellvalue, options, rowObject) {
    var invoiceIdDisplay = '<em><g:message code="table.id.format" args="['_invoiceId_']"/></em>'
    var content = '<div class="medium"><strong>' + rowObject.invoiceNumber + '</strong></div>' + invoiceIdDisplay;
    return content.replace(/_invoiceId_/g, cellvalue)
}

function descriptionFormatter (cellvalue, options, rowObject) {
    return cellvalue.description;
}

// A simple formatter that concatenates the currency symbol with the balance
function balanceFormatter (cellvalue, options, rowObject) {
    return rowObject.currencySymbol + cellvalue.toFixed(2);
}

function downloadFilteredCsv() {
    $(jqTableGrid).jqGrid('excelExport',{tag:'csv', url:'<g:createLink controller="invoice" action="${csvAction}" id="${processId}"/>'});
}

function downloadFilteredPdf() {
    $(jqTableGrid).jqGrid('excelExport',{tag:'pdf', url:'<g:createLink controller="invoice" action="batchPdf"/>'});
}

function isRowSelected(id) {
    //console.log("id:"+id+" gLastSel:"+gLastSel);
    return gLastSel == id;
}
// ]]></script>
