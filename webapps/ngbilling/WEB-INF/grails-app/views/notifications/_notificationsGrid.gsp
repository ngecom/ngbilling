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

<g:set var="updateColumn" value="column2" />
<g:set var="categoryId" value="${selected ? selected : categoryId}" />

<!-- table tag will hold our grid
    The updateColumn variable will allow us to identify whether this table
    is for showing entities (column1) or their children (column2)
-->

<table id="data_grid_${updateColumn}" class="scroll jqTable" cellpadding="0" cellspacing="0"></table>
<!-- pager will hold our paginator -->
<div id="data_grid_pager_${updateColumn}" class="scroll" style="text-align:center;"></div>

<div class="btn-box">
    <g:remoteLink action="editNotification" class="submit add"
                  before="register(this);"
                  onSuccess="render(data, next);" params="['categoryId':categoryId]">
        <span><g:message code="button.create.notification"/></span>
    </g:remoteLink>
</div>

<div id="showLink" style="display: none;">
    <g:remoteLink class="cell" action="show" params="['template': 'show']" id="_id_" before="register(this);" onSuccess="render(data, next); animateToTheTop();">

    </g:remoteLink>
</div>

<div id="execShowLink" style="display: none;">
</div>

<script type="text/javascript">// <![CDATA[
/* when the page has finished loading.. execute the follow */
var gLastSelNotif = -1;
var jqTableGridNotif = $('#data_grid_${updateColumn}');
var jqTablePagerNotif = $('#data_grid_pager_${updateColumn}');
$(document).ready(function () {
    $(jqTableGridNotif).jqGrid({
        url:'<g:createLink action="findNotifications" id="${categoryId}"/>',
        datatype: "json",
        colNames:[
            '<g:message code="title.notification"/>',
            '<g:message code="title.notification.active"/>'
        ],
        colModel:[
            { name: 'notificationId', editable: false, width: 150, formatter: notificationFormatter },
            { name: 'active', editable: false, search: false, sortable: false, width: 30, formatter: activeFormatter }
        ],
        sortname: 'notificationId',
        sortorder: 'desc',
        autowidth: true,
        height: 'auto',
        rowNum: 20,
        rowList: [10,20,50],
        pager: $(jqTablePagerNotif),
        viewrecords: true,
        gridview: true,
        onSelectRow: function(id){
            if(id && id!==gLastSelNotif){
                var content = $('#showLink').clone().html().replace(/_id_/g, id);
                $("#execShowLink").html(content);
                $("#execShowLink > a").click();
                gLastSelNotif=id;
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

    $(jqTableGridNotif).jqGrid('filterToolbar',{autosearch:true});

});

function notificationFormatter (cellvalue, options, rowObject) {
    var notificationIdDisplay = '<em><g:message code="table.id.format" args="['_notificationId_']"/></em>'
    var content = '<div class="medium">' + rowObject.description + '</div>' + notificationIdDisplay;
    return content.replace(/_notificationId_/g, cellvalue)
}

function activeFormatter (cellvalue, options, rowObject) {
    if(cellvalue == true) {
        return '<g:message code="prompt.yes"/>';
    } else {
        return '<g:message code="prompt.no"/>';
    }
}

function isRowSelected(id) {
    //console.log("id:"+id+" gLastSelNotif:"+gLastSelNotif);
    return gLastSelNotif == id;
}

function animateToTheTop(){
    $('html, body').animate({ scrollTop: 0 }, 'fast');
}
// ]]></script>
