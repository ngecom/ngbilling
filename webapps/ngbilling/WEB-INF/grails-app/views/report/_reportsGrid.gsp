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

<g:set var="updateColumn" value="column2"/>

<!-- table tag will hold our grid
    The updateColumn variable will allow us to identify whether this table
    is for showing entities (column1) or their children (column2)
-->

<table id="data_grid_${updateColumn}" class="scroll jqTable" cellpadding="0" cellspacing="0"></table>
<!-- pager will hold our paginator -->
<div id="data_grid_pager_${updateColumn}" class="scroll" style="text-align:center;"></div>

<div class="btn-box">
    <g:remoteLink action="allReports" update="column1" class="submit show" onSuccess="cleanColumn('column2');"><span><g:message code="button.show.all"/></span></g:remoteLink>
</div>

<div id="showReportLink" style="display: none;">
    <g:remoteLink class="cell" action="show" params="[template: 'show']" id="_id_" before="register(this);" onSuccess="render(data, next); animateToTheTop();">

    </g:remoteLink>
</div>

<div id="execShowReportLink" style="display: none;">
</div>

<script type="text/javascript">// <![CDATA[
/* when the page has finished loading.. execute the follow */
var gLastSel = -1;
var jqTableGrid${updateColumn} = $('#data_grid_${updateColumn}');
var jqTablePager${updateColumn} = $('#data_grid_pager_${updateColumn}');
$(document).ready(function () {
    $(jqTableGrid${updateColumn}).jqGrid({
        url:'<g:createLink action="findReports" id="${selectedTypeId}"/>',
        datatype: "json",
        colNames:[
            '<g:message code="report.th.name"/>'
        ],
        colModel:[
            { name: 'name', editable: false, sortable:false ,formatter: reportFormatter }
        ],
        sortname: 'name',
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
                var content = $('#showReportLink').clone().html().replace(/_id_/g, id);
                $("#execShowReportLink").html(content);
                $("#execShowReportLink > a").click();
                gLastSel=id;
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

function reportFormatter (cellvalue, options, rowObject) {
    var reportNameDisplay = '<em>' + rowObject.fileName + '</em>'
    var content = '<div class="medium" style="font-weight: bold">' + cellvalue + '</div>' + reportNameDisplay;
    return content
}

function isRowSelected(id) {
    //console.log("id:"+id+" gLastSel:"+gLastSel);
    return gLastSel == id;
}

function cleanColumn(column){
    $('#' + column).html('');
}

function animateToTheTop(){
    $('html, body').animate({ scrollTop: 0 }, 'fast');
}
// ]]></script>
