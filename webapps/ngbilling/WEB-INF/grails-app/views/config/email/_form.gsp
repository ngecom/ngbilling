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

<%@ page import="com.sapienter.jbilling.server.util.ServerConstants" %>
 <script>
     function validateIsNumber(evt) {

         var theEvent = evt || window.event;
         var key = theEvent.keyCode || theEvent.which;
         var keyChar = String.fromCharCode(key);
         var regex = /[0-9\b]/;
         if (!(key == 8 || key == 27 || key == 46 || key == 37 || key == 39)) {
         if (!regex.test(key)) {
            theEvent.returnValue = false;
            if (theEvent.preventDefault) theEvent.preventDefault();
         }
     }
 </script>
<div class="form-edit">
    <div class="heading">
        <strong><g:message code="email.config.title"/></strong>
    </div>
    <div class="form-hold">
        <g:uploadForm name="save-email-form" url="[action: 'saveEmail']">
            <fieldset>
                <div class="form-columns">
                    <div class="column single">

                        <g:applyLayout name="form/checkbox">
                            <content tag="label"><g:message code="email.config.label.self.deliver"/></content>
                            <content tag="label.for">selfDeliver</content>
                            <g:checkBox class="cb" name="selfDeliver" checked="${selfDeliver.value == '1'}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/checkbox">
                            <content tag="label"><g:message code="email.config.label.customer.notes"/></content>
                            <content tag="label.for">customerNotes</content>
                            <g:checkBox class="cb" name="customerNotes" checked="${customerNotes.value == '1'}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="email.config.label.days.for.notification.1"/><span id="mandatory-meta-field">*</span></content>
                            <content tag="label.for">daysForNotification1</content>
                            <g:textField name="daysForNotification1" class="field" value="${daysForNotification1.value}" onkeypress="validateIsNumber(event)"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="email.config.label.days.for.notification.2"/><span id="mandatory-meta-field">*</span></content>
                            <content tag="label.for">daysForNotification2</content>
                            <g:textField name="daysForNotification2" class="field" value="${daysForNotification2.value}" onkeypress="validateIsNumber(event)"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="email.config.label.days.for.notification.3"/></content>
                            <content tag="label.for">daysForNotification3</content>
                            <g:textField name="daysForNotification3" class="field" value="${daysForNotification3.value}" onkeypress="validateIsNumber(event)"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/checkbox">
                            <content tag="label"><g:message code="email.config.label.use.invoice.reminder"/></content>
                            <content tag="label.for">useInvoiceReminders</content>
                            <g:checkBox class="cb" name="useInvoiceReminders" checked="${useInvoiceReminders.value == '1'}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="email.config.label.first.invoice.reminder"/></content>
                            <content tag="label.for">firstReminder</content>
                            <g:textField name="firstReminder" class="field" value="${firstReminder.value}" onkeypress="validateIsNumber(event)"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="email.config.label.next.invoice.reminder"/><span id="mandatory-meta-field">*</span></content>
                            <content tag="label.for">nextReminder</content>
                            <g:textField name="nextReminder" class="field" value="${nextReminder.value}" onkeypress="validateIsNumber(event)"/>
                        </g:applyLayout>

                        <!-- spacer -->
                        <div>
                            <br/>&nbsp;
                        </div>
                   </div>
                </div>
            </fieldset>
        </g:uploadForm>
    </div>

    <div class="btn-box">
        <a onclick="$('#save-email-form').submit();" class="submit save"><span><g:message code="button.save"/></span></a>
        <g:link controller="config" action="index" class="submit cancel"><span><g:message code="button.cancel"/></span></g:link>
    </div>
</div>