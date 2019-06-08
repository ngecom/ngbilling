<%@ page import="com.sapienter.jbilling.server.util.ServerConstants; com.sapienter.jbilling.server.item.db.AssetDTO; com.sapienter.jbilling.server.item.db.ItemDTO" %>
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
  Shows the changes list
--%>

<div id="assets-dialog-update">
    <div id="assets-box-update">
    </div>
</div>

<div id="edit-changes-box">
    <script type="text/javascript">
        var updateSuccess = ${message ? true : false};
        if(updateSuccess) {
            showTabWithoutClickIfNeeded('ui-tabs-review');
        } else {
            showTabWithoutClickIfNeeded('ui-tabs-edit-changes');
        }
    </script>

    <!-- error messages -->
    <div id="messages">
        <g:if test="${errorMessages}">
            <div class="msg-box error">
                <ul>
                    <g:each var="message" in="${errorMessages}">
                        <li>${message}</li>
                    </g:each>
                </ul>
            </div>

            <g:set var="errorMessages" value=""/>
            <ul></ul>
        </g:if>
    </div>

    <div class="table-box tab-table">
        <g:if test="${editedOrderChanges?.data}">
            <div class="table-scroll">
            <table id="editOrderChanges" cellspacing="0" cellpadding="0">
                <tbody>
                <g:each var="orderChange" in="${editedOrderChanges.data}">
                    <g:if test="${!orderChange.change.delete || orderChange.change.delete == 0}">
                        <g:render template="orderChange" model="[ orderChange: orderChange ]"/>
                    </g:if>
                </g:each>

                </tbody>
            </table>
            <script type="text/javascript">
                %{-- display or hide details for order change clicked--}%
                function showEditChangeDetails(element) {
                    var id = $(element).attr('id').substring('edit_change_header_'.length);
                    if ($('#edit_change_details_' + id).is(':visible')) {
                        $('#edit_change_details_' + id).hide();
                        $(element).removeClass('active');
                    } else {
                        $('#edit_change_details_' + id).show();
                        $(element).addClass('active');
                    }
                }

                <%-- Create a dialog --%>
                $( "#assets-dialog-update" ).dialog({
                    title: "${g.message([code: 'assets.dialog.choose.title'])}" ,
                    autoOpen: false,
                    width: 580,
                    modal: true,
                    dialogClass: "no-close"
                });

                <%-- Close the dialog. Function gets called by the close button in the dialog --%>
                function closeAssetsupdateDialog(event) {
                    event.preventDefault();
                    $( '#assets-dialog-update' ).dialog( "close" );
                    $( '#assets-box-update' ).empty();
                }

                function forceSelectAssets() {
                   <g:remoteFunction controller='orderBuilder'  action= 'edit'
                                        method= 'GET'
                                        update= 'assets-box-update'
                                        params= "['_eventId':'initUpdateAssets','id':forceDisplayAssetsDialogForChangeId]"/>
                }

                <g:if test="${forceDisplayAssetsDialogForChangeId}">
                    // force show assets dialog
                    forceSelectAssets();
                </g:if>

            </script>
        </div>
        </g:if>
    </div>
</div>