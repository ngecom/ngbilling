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

<div class="column-hold">
	<div class="heading">
	    <strong style="width:100%">
			<g:message code="prompt.notifications.preferences"/>
	    </strong>
	</div>

	<div class="box">
    <div class="sub-box">
  		<table class="dataTable">
  			<g:set var="dto" value="${subList.get(ServerConstants.PREFERENCE_TYPE_SELF_DELIVER_PAPER_INVOICES)}" />
  			<tr><td><g:message code="notification.preference.selfDeliver.prompt"/>:</td>
  			<td class="value">${ ((dto?.getIntValue() != 0) ? "Yes": "No") }</td>
              </tr>
  			<g:set var="dto" value="${subList.get(ServerConstants.PREFERENCE_TYPE_INCLUDE_CUSTOMER_NOTES)}" />
  			<tr><td><g:message code="notification.preference.showNotes.prompt"/>:</td>
  			<td class="value">${ (dto?.getIntValue() != 0)? "Yes": "No"}</td>
              </tr>
  			<g:set var="dto" value="${subList.get(ServerConstants.PREFERENCE_TYPE_DAY_BEFORE_ORDER_NOTIF_EXP)}" />
  			<tr><td><g:message code="notification.preference.orderDays1.prompt"/>:</td>
  			<td class="value">${dto?.getIntValue()}</td></tr>
  			<g:set var="dto" value="${subList.get(ServerConstants.PREFERENCE_TYPE_DAY_BEFORE_ORDER_NOTIF_EXP2)}" />
  			<tr><td><g:message code="notification.preference.orderDays2.prompt"/>:</td>
  			<td class="value">${dto?.getIntValue()}</td></tr>

  			<g:set var="dto" value="${subList.get(ServerConstants.PREFERENCE_TYPE_DAY_BEFORE_ORDER_NOTIF_EXP3)}" />
  			<tr><td><g:message code="notification.preference.orderDays3.prompt"/>:</td>
  			<td class="value">${dto?.getIntValue()}</td></tr>

  			<g:set var="dto" value="${subList.get(ServerConstants.PREFERENCE_TYPE_USE_INVOICE_REMINDERS)}" />
  			<tr><td><g:message code="notification.preference.invoiceRemiders.prompt"/>:</td>
  			<td class="value">${(dto?.getIntValue() != 0)?"Yes":"No"}</td></tr>

  			<g:set var="dto" value="${subList.get(ServerConstants.PREFERENCE_TYPE_NO_OF_DAYS_INVOICE_GEN_1_REMINDER)}"/>
  			<tr><td><g:message code="notification.preference.reminders.first"/>:</td>
  			<td class="value">${dto?.getIntValue()}</td></tr>

  			<g:set var="dto" value="${subList.get(ServerConstants.PREFERENCE_TYPE_NO_OF_DAYS_NEXT_REMINDER)}" />
  			<tr><td><g:message code="notification.preference.reminders.next"/>:</td>
  			<td class="value">${dto?.getIntValue()}</td></tr>
  		</table>
    </div>
	</div>
	<div class="btn-box">
		<a href="${createLink(action: 'editPreferences')}" class="submit edit">
	    	<span><g:message code="button.edit"/></span></a>
	</div>
</div>