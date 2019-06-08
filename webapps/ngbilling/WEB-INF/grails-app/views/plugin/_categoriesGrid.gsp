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

<div id="showPluginsLink" style="display: none;">
    <g:remoteLink class="cell" action="plugins" params="[template:'show']" id="_id_" before="register(this);" onSuccess="render(data, next);">

    </g:remoteLink>
</div>

<div id="execShowPluginsLink" style="display: none;">
</div>

<script type="text/javascript">// <![CDATA[
/* when the page has finished loading.. execute the follow */
var gridLastCategorySel = -1;
var jqTableGrid${updateColumn} = $('#data_grid_${updateColumn}');
var jqTablePager${updateColumn} = $('#data_grid_pager_${updateColumn}');
$(document).ready(function () {
    $(jqTableGrid${updateColumn}).jqGrid({
        url:'<g:createLink action="findCategories"/>',
        datatype: "json",
        colNames:[
            '<g:message code="plugins.category.list.id"/>',
            '<g:message code="plugins.category.list.title"/>'
        ],
        colModel:[
            { name: 'categoryId', editable: false, width: 15},
            { name: 'description', editable: false, sortable:false, formatter: pluginCategoryFormatter }
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
                var content = $('#showPluginsLink').clone().html().replace(/_id_/g, id);
                $("#execShowPluginsLink").html(content);
                $("#execShowPluginsLink > a").click();
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

function pluginCategoryFormatter (cellvalue, options, rowObject) {
    var categoryDisplay = '<em>' + rowObject.interfaceName + '</em>'
    var content = '<div class="medium">' + categoryDisplay + '</div>' ;
    if (cellvalue){
        content = '<div class="medium"><strong>' + cellvalue + '</strong></div>' + categoryDisplay;
    }
    return content
}

function isRowSelected(id) {
    //console.log("id:"+id+" gridLastCategorySel:"+gridLastCategorySel);
    return gridLastCategorySel == id;
}

// ]]></script>
