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
  form for date selection and triggering Collections process

  @author Igor Poteryaev
  @since  17-Mar-2014
--%>

<div id="collectionsRun" class="form-hold">
    <fieldset>
        <div class="form-columns single">
            <div class="column">
                 <g:applyLayout name="form/date">
                     <content tag="label"><g:message code="config.collections.run.date"/></content>
                     <content tag="label.for">collectionsRunDate</content>
                     <g:textField class="field" name="collectionsRunDate"
                            value="${formatDate(date: new Date(), formatName: 'datepicker.format')}"
                            onblur="validateDate(this)"/>
                 </g:applyLayout>
            </div>
        </div>
    </fieldset>
    <div class="btn-row">
        <g:submitButton name="run" class="submit confirm" style="float:none" value="${message(code: 'button.run.collections')}" />
    </div>
    <script type="text/javascript">
        setTimeout(
            function() {
                $("#collectionsRunDate").datepicker("option", "minDate", new Date());
            },
            $("#collectionsRunDate").is(":visible") ? 10 : 510
        );
    </script>
    <script type="text/javascript">
        $(function(){
            $('#confirm-dialog').dialog({
                autoOpen: false,
                width: 480,
                modal: true,
                resizable: false,
                title: "${message(code: 'popup.confirm.title')}",
                open: function( event, ui ) {
                    $("#btnCancel").focus();
                }
            });

            $('form input.confirm').click(function (e) {
                e.preventDefault();
                var form = $(e.target).closest("form");
                var dlg  = $('#confirm-dialog');
                var msg  = "${message(code: 'config.collections.run.confirm')}";
                var icon = "<span class='ui-icon ui-icon-alert' style='float:left; margin:0 7px 0 0;'></span>";
                dlg.html("<p>"+ icon + msg +"</p>");
                dlg.dialog("option", "buttons", [
                    {
                        text:  "${message(code: 'button.run.collections')}",
                        click: function() {form.submit();},
                        'class': 'ui-priority-secondary'
                    },
                    {
                        id:    "btnCancel",
                        text:  "${message(code: 'button.cancel')}",
                        click: function() {$(this).dialog("close");},
                    }
                ]);
                dlg.dialog('open');
            });
        });
    </script>
    <div id="confirm-dialog"></div>
</div>
