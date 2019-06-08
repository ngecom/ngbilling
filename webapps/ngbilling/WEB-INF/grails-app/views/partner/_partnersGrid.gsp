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
  Customer table template. The customer table is used multiple times for rendering the
  main list and for rendering a separate list of sub-accounts.

  @author Nelson Secchi
  @since  01/05/14
--%>


<!-- The feature to show sub-agents has not been developed yet -->
<g:set var="csvAction" value="${actionName == 'subagents' ? 'subagentsCsv' : 'csv'}"/>
<g:set var="parentId" value="${actionName == 'subagents' ? parent.id : null}"/>
<g:set var="updateColumn" value="${actionName == 'subagents' ? 'column2' : 'column1'}"/>

<!-- table tag will hold our grid
    The updateColumn variable will allow us to identify whether this table
    is for showing entities (column1) or their children (column2)
-->

<table id="data_grid_${updateColumn}" class="scroll jqTable" cellpadding="0" cellspacing="0"></table>
<!-- pager will hold our paginator -->
<div id="data_grid_pager_${updateColumn}" class="scroll" style="text-align:center;"></div>

<div class="btn-box">
    <sec:ifAllGranted roles="CUSTOMER_10">
        <g:if test="${loggedInUser?.partner}">
            <g:if test="${!loggedInUser?.partner?.parent}">
                <g:link action='edit' params="[parentId: loggedInUser.partner.id]" class="submit add"><span><g:message code="button.create"/></span></g:link>
            </g:if>
        </g:if>
        <g:else>
            <g:link action='edit' class="submit add"><span><g:message code="button.create"/></span></g:link>
        </g:else>
    </sec:ifAllGranted>
    <g:link action='showCommissionRuns' class="submit show"><span><g:message code="button.showCommissions"/></span></g:link>
</div>

<div id="parentAndChild" style="display: none;">
    <!-- The feature to show sub-agents has not been developed yet
    < g:remoteLink action="subagents" id="_id_" before="if(!isRowSelected(_id_)) return false;register(this);" onSuccess="render(data, next);"><img
            src="$ {resource(dir: 'images', file: 'icon17.gif')}"
            alt="parent and child"/><span>_ch_</span></ g:remoteLink>
    -->
    <img src="${resource(dir: 'images', file: 'icon17.gif')}" alt="parent and child"/><span>_ch_</span>
</div>

<div id="parentOnly" style="display: none;">
    <!-- The feature to show sub-agents has not been developed yet
    < g:remoteLink action="subagents" id="_id_" before="if(!isRowSelected(_id_)) return false;register(this);" onSuccess="render(data, next);"><img
            src="$ {resource(dir: 'images', file: 'icon18.gif')}"
            alt="parent"/><span>_ch_</span></ g:remoteLink>
    -->
    <img src="${resource(dir: 'images', file: 'icon18.gif')}" alt="parent"/><span>_ch_</span>
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
        url:'<g:createLink
            action="${actionName == 'subagents' ? 'findSubagents' : 'findAgents'}"
            id="${parentId}"/>',
        datatype: "json",
        colNames:[
            '<g:message code="customer.table.th.agent.user.id"/>',
            '<g:message code="customer.table.th.name"/>',
            <g:isRoot>'<g:message code="customer.table.th.user.company.name"/>',</g:isRoot>
            '<g:message code="customer.table.th.status"/>',
            '<g:message code="customer.table.th.hierarchy"/>'
        ],
        colModel:[
            { name: 'userid', editable: false, width: 90 },
            { name: 'username', editable: false, formatter: partnerFormatter },
            <g:isRoot>{ name: 'company', editable: false }, </g:isRoot>
            { name: 'status', editable: false, width: 90, search: false, formatter: statusFormatter },
            { name: 'hierarchy', editable: false, search: false, sortable: false, formatter: hierarchyFormatter }
        ],
        sortname: 'userid',
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

function partnerFormatter (cellvalue, options, rowObject) {
    var organizationDisplay = ''
    if (rowObject.contact.organization){
        organizationDisplay = ' <em>' + rowObject.contact.organization + '</em>'
    }
    var content
    if (organizationDisplay) {
        content = '<div class="medium"><strong>_displayName_</strong></div>' + organizationDisplay
    } else{
        content = '_displayName_'
    }
    var displayName = cellvalue
    if (rowObject.contact.firstName || rowObject.contact.lastName){
        displayName = rowObject.contact.firstName + ' ' + rowObject.contact.lastName
    }
    content = content.replace(/_displayName_/g, displayName)
    return content;
}

function statusFormatter (cellvalue, options, rowObject) {
    if(cellvalue == 'suspended') {
        return '<img src="${resource(dir:"images", file:"icon16.gif")}" alt="suspended" />';
    } else if(cellvalue == 'overdue') {
        return '<img src="${resource(dir:"images", file:"icon15.gif")}" alt="overdue" />';
    }
    return '';
}

function hierarchyFormatter (cellvalue, options, rowObject) {
    var content = '';
    if(cellvalue.parent && cellvalue.child) {
        content = $('#parentAndChild').clone().html().replace(/_id_/g, rowObject.userid).replace(/_ch_/g, cellvalue.children);
    } else if(cellvalue.parent && !cellvalue.child) {
        content = $('#parentOnly').clone().html().replace(/_id_/g, rowObject.userid).replace(/_ch_/g, cellvalue.children);
    } else if(!cellvalue.parent && cellvalue.child) {
        content = $('#childOnly').clone().html();
    }
    return content;
}

function downloadFilteredCsv() {
    $(jqTableGrid).jqGrid('excelExport',{tag:'csv', url:'<g:createLink controller="partner" action="${csvAction}" id="${parentId}"/>'});
}

function isRowSelected(id) {
    //console.log("id:"+id+" gLastSel:"+gLastSel);
    return gLastSel == id;
}
// ]]></script>
