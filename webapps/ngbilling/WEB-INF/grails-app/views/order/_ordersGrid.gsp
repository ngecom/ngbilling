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

<%-- 
    Orders list template. 
    
    @author Vikas Bodani
    @since 20-Jan-2011
 --%>

<g:set var="csvAction" value="${actionName == 'suborders' ? 'subordersCsv' : 'csv'}"/>
<g:set var="parentId" value="${actionName == 'suborders' ? parent.id : null}"/>
<g:set var="updateColumn" value="${actionName == 'suborders' ? 'column2' : 'column1'}"/>

<!-- table tag will hold our grid -->
<table id="data_grid_${updateColumn}" class="scroll jqTable" cellpadding="0" cellspacing="0"></table>
<!-- pager will hold our paginator -->
<div id="data_grid_pager_${updateColumn}" class="scroll" style="text-align:center;"></div>

<g:if test="${!parent}">
    <div class="btn-box">
        <div class="row">
            <sec:ifAllGranted roles="ROLE_CUSTOMER">
                <sec:ifAllGranted roles="ORDER_20">
                    <g:link controller="orderBuilder" action="edit" params="[userId: session['user_id']]" class="submit order"><span><g:message code="button.create.order"/></span></g:link>
                </sec:ifAllGranted>
            </sec:ifAllGranted>
        </div>
    </div>
</g:if>


<div id="parentAndChild" style="display: none;">
    <g:remoteLink action="suborders" id="_id_" before="register(this);" onSuccess="render(data, next);">
        <img src="${resource(dir:'images', file:'icon17.gif')}" alt="parent and child" />
        <span>_ch_</span>
    </g:remoteLink>
</div>

<div id="parentOnly" style="display: none;">
    <g:remoteLink action="suborders" id="_id_" before="if(!isRowSelected(_id_)) return false;register(this);" onSuccess="render(data, next);"><img
            src="${resource(dir: 'images', file: 'icon18.gif')}"
            alt="parent"/><span>_ch_</span></g:remoteLink>
</div>

<div id="childOnly" style="display: none;">
    <img src="${resource(dir: 'images', file: 'icon19.gif')}" alt="child"/>
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
        url:'<g:createLink action="${actionName == 'suborders' ? 'findSuborders' : 'findOrders'}"
            id="${parentId}"/>',
        datatype: "json",
        colNames:[
            '<g:message code="order.label.id"/>',
            '<g:message code="order.label.customer"/>',
            <g:isRoot>'<g:message code="order.label.company"/>',</g:isRoot>
            '<g:message code="order.label.date"/>',
            '<g:message code="order.label.amount"/>',
            '<g:message code="order.label.parent.child"/>'
        ],
        colModel:[
            { name: 'orderid', editable: false, width: 90 },
            { name: 'customer', editable: false },
            <g:isRoot>{ name: 'company', editable: false }, </g:isRoot>
            { name: 'date', editable: false, width: 90, search: false, formatter: 'date' , formatOption:{newFormat:'<g:message code="date.pretty.format"/>'} },
            { name: 'amount', editable: false, search: false, sortable: true, formatter: balanceFormatter},
            { name: 'hierarchy', editable: false, search: false, sortable: false, formatter: hierarchyFormatter }
        ],
        sortname: 'orderid',
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
    ).jqGrid('navButtonAdd', '#data_grid_pager_${updateColumn}', {caption: 'csv', onClickButton: downloadFilteredCsv, title:'<g:message code="jqview.download.csv.filtered.tip" />' });

    $(jqTableGrid).jqGrid('filterToolbar',{autosearch:true});
});

function hierarchyFormatter (cellvalue, options, rowObject) {
    var content = '';
    if(cellvalue.parent && cellvalue.child) {
        content = $('#parentAndChild').clone().html().replace(/_id_/g, rowObject.orderid).replace(/_ch_/g, cellvalue.children);
    } else if(cellvalue.parent && !cellvalue.child) {
        content = $('#parentOnly').clone().html().replace(/_id_/g, rowObject.orderid).replace(/_ch_/g, cellvalue.children);
    } else if(!cellvalue.parent && cellvalue.child) {
        content = $('#childOnly').clone().html();
    }
    return content;
}

function downloadFilteredCsv() {
    $(jqTableGrid).jqGrid('excelExport',{tag:'csv', url:'<g:createLink controller="order" action="${csvAction}" id="${parentId}" />'});
}

// A simple formatter that concatenates the currency symbol with the balance
function balanceFormatter (cellvalue, options, rowObject) {
    return rowObject.currencySymbol + cellvalue.toFixed(2);
}

function isRowSelected(id) {
    console.log("id:"+id+" gLastSel:"+gLastSel);
    return gLastSel == id;
}
// ]]></script>

<g:if test="${!parent}">
<div class="btn-box">
    <div class="row">
        <sec:ifAllGranted roles="ROLE_CUSTOMER">
            <sec:ifAllGranted roles="ORDER_20">
                <g:link controller="orderBuilder" action="edit" params="[userId: session['user_id']]" class="submit order"><span><g:message code="button.create.order"/></span></g:link>
            </sec:ifAllGranted>
        </sec:ifAllGranted>
    </div>
</div>
</g:if>
