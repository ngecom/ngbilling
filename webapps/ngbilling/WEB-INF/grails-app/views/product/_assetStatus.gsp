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
  Template for editing asset statuses

 @author Gerhard Maree
 @since  18-Apr-2013
--%>

<div class="form-columns single">
    <table cellpadding="0" cellspacing="0" class="innerTable" width="100%">
        <thead class="innerHeader">
        <tr>
            <th class="left medium"><g:message code="status.edit.th.name"/></th>
            <th class="left tiny2"><g:message code="status.edit.th.isAvailable"/></th>
            <th class="left tiny2"><g:message code="status.edit.th.isDefault"/></th>
            <th class="left tiny2"><g:message code="status.edit.th.isOrderSaved"/></th>
            <th class="left tiny2"></th>
        </tr>
        </thead>
        <tbody id="statusTBody">

        <g:set var="statusIndex" value="${0}"/>
        <g:set var="readonly" value="true"/>
            <g:set var="readonly" value="false"/>

        <!-- user-defined statuses -->
        <g:each var="status" in="${statuses}">

            <tr id="statusRow${statusIndex}">
                <td class="innerContent">
                    <input type="hidden" name="assetStatus.${statusIndex}.id" value="${status.id}"/>
                    <g:textField class="field" name="assetStatus.${statusIndex}.description"
                                 value="${status.description}" readonly="${readonly}"/>
                </td>
                <td class="innerContent">
                    <g:checkBox class="field" name="assetStatus.${statusIndex}.isAvailable"
                                checked="${status.isAvailable}" onchange="currentAvailable(this);" readonly="${readonly}"/>
                </td>
                <td class="innerContent">
                    <g:checkBox class="field markerDefault" id="assetStatus.${statusIndex}.isDefault"
                                name="assetStatus.${statusIndex}.isDefault" checked="${status.isDefault}"
                                onchange="currentDefault(this);" readonly="${readonly}"/>
                </td>
                <td class="innerContent">
                    <g:checkBox class="field markerOrderSaved" id="assetStatus.${statusIndex}.isOrderSaved"
                                name="assetStatus.${statusIndex}.isOrderSaved" checked="${status.isOrderSaved}"
                                onchange="currentOrderSaved(this);" readonly="${readonly}"/>
                </td>
                <td class="innerContent">
                    <g:if test="${readonly == 'false'}">
                        <a onclick="removeModelStatus(this, ${statusIndex})">
                            <img src="${resource(dir: 'images', file: 'cross.png')}" />
                        </a>
                    </g:if>
                </td>
            </tr>
            <g:set var="statusIndex" value="${statusIndex + 1}"/>
        </g:each>

        <g:if test="${readonly == 'false'}">
            <!-- one empty row -->
            <g:set var="statusIndex" value="${statusIndex + 1}"/>
            <tr id="lastStatus">
                <td class="innerContent">
                    <input type="hidden" name="assetStatus.${statusIndex}.id" value="null"/>
                    <g:textField id="lastStatusName" class="field" name="assetStatus.${statusIndex}.description"/>
                </td>
                <td class="innerContent">
                    <g:checkBox id="lastStatusAvailable" class="field"
                                name="assetStatus.${statusIndex}.isAvailable" onchange="currentAvailable(this);"/>
                </td>
                <td class="innerContent">
                    <g:checkBox id="lastStatusDefault" class="field markerDefault"
                                name="assetStatus.${statusIndex}.isDefault" onchange="currentDefault(this);"/>
                </td>
                <td class="innerContent">
                    <g:checkBox id="lastStatusOrderSaved" class="field markerOrderSaved"
                                name="assetStatus.${statusIndex}.isOrderSaved" onchange="currentOrderSaved(this);"/>
                </td>
                <td class="innerContent">
                    <a onclick="addModelStatus()">
                        <img src="${resource(dir: 'images', file: 'add.png')}" alt="add"/>
                    </a>
                </td>
            </tr>
        </g:if>

        </tbody>

    </table>
</div>

<r:script>

var statusIdx = ${statusIndex}+1;

<%-- Removes a line from the list of statuses --%>
    function removeModelStatus(thisRef, idx) {
      $(thisRef).closest("tr").remove();
    }

<%-- Make sure only the currently selected default status is checked--%>
    function currentDefault(thisRef) {
       if(thisRef.checked == true) {
           $('input[name="'+thisRef.name.replace("isDefault","isOrderSaved")+'"]').prop("checked", false);
           $(".markerDefault").prop("checked", false);
           thisRef.checked = true;
        }
    }

<%-- Make sure only the currently selected order saved status is checked--%>
    function currentOrderSaved(thisRef) {
        if(thisRef.checked == true) {
           $('input[name="'+thisRef.name.replace("isOrderSaved","isAvailable")+'"]').prop("checked", false);
           $('input[name="'+thisRef.name.replace("isOrderSaved","isDefault")+'"]').prop("checked", false);
           $(".markerOrderSaved").prop("checked", false);
           thisRef.checked = true;
        }
    }

    function currentAvailable(thisRef) {
        if(thisRef.checked == true) {
           $('input[name="'+thisRef.name.replace("isAvailable","isOrderSaved")+'"]').prop("checked", false);
           thisRef.checked = true;
        }
    }

<%-- Add a new empty status line to the table --%>
    function addModelStatus() {
        statusIdx ++;
        var lastStatusName = $("#lastStatusName").val();
        $("#lastStatusName").val("");
        var lastStatusAvailable = $("#lastStatusAvailable").prop("checked");
        $("#lastStatusAvailable").prop("checked", false);
        var lastStatusDefault = $("#lastStatusDefault").prop("checked");
        $("#lastStatusDefault").prop("checked", false);
        var lastStatusOrderSaved = $("#lastStatusOrderSaved").prop("checked");
        $("#lastStatusOrderSaved").prop("checked", false);

        $("#lastStatus").before('<tr id="statusRow'+statusIdx+'">' +
            '<td class="innerContent">' +
            '<input type="hidden" name="assetStatus.'+statusIdx+'.id" value="null"/>' +
            '<input type="text" class="field" name="assetStatus.'+statusIdx+'.description" value="'+lastStatusName+'"/>' +
            '</td>' +
            '<td class="innerContent">' +
            '<input type="checkbox" class="field" name="assetStatus.'+statusIdx+'.isAvailable" '+(lastStatusAvailable?'checked':'')+' onchange="currentAvailable(this);" />' +
            '</td>' +
            '<td class="innerContent">' +
            '<input type="checkbox" class="field markerDefault" id="assetStatus.'+statusIdx+'.isDefault" name="assetStatus.'+statusIdx+'.isDefault" '+(lastStatusDefault?'checked':'')+' onchange="currentDefault(this);" />' +
            '</td>' +
            '<td class="innerContent">' +
            '<input type="checkbox" class="field markerOrderSaved" id="assetStatus.'+statusIdx+'.isOrderSaved" name="assetStatus.'+statusIdx+'.isOrderSaved" '+(lastStatusOrderSaved?'checked':'')+' onchange="currentOrderSaved(this);"/>' +
            '</td>' +
            '<td class="innerContent">' +
            '<a onclick="removeModelStatus(this, '+statusIdx+')">' +
            '<img src="${resource(dir: 'images', file: 'cross.png')}" alt="remove"/>' +
            '</a>' +
            '</td>' +
            '</tr>');
    }
</r:script>