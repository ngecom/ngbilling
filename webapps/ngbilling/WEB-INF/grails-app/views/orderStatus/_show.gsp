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
  Shows order status.

  @author Maruthi
  @since  20-June-2013
--%>

<%@page import="com.sapienter.jbilling.server.order.OrderStatusFlag; com.sapienter.jbilling.server.process.db.PeriodUnitDTO";
@page import="com.sapienter.jbilling.server.order.OrderStatusFlag"%>

<div class="column-hold">
    <div class="heading">
        <strong>
        <em>ORDER STATUS "${selected?.description}"</em>
        </strong>
    </div>

    <div class="box">
        <div class="sub-box">
          <table class="dataTable" cellspacing="0" cellpadding="0">
            <tbody>
            <tr>
                <td><g:message code="orderStatus.orderStatusFlag"/></td>
                <td class="value">${selected.orderStatusFlag}</td>
            </tr>
            <tr>
                <td><g:message code="orderStatus.description"/></td>
                <td class="value">${selected.description}</td>
            </tr>
            </tbody>
        </table>
      </div>
    </div>
	<g:form id="save-orderStatus-form" name="order-orderStatus-form" url="[action: 'delete']" >
		<g:hiddenField name="id" value="${selected.id}"/>
	</g:form>
	
	    <div class="btn-box">
	        <div class="row">
	            <g:remoteLink class="submit add" id="${selected.id}" action="edit" update="column2">
	                <span><g:message code="button.edit"/></span>
	            </g:remoteLink>
	        <g:if test="${selected?.orderStatusFlag?.equals(OrderStatusFlag.INVOICE) || selected?.orderStatusFlag?.equals(OrderStatusFlag.NOT_INVOICE)}">
	            <a onclick="showConfirm('delete-' + ${selected?.id});" class="submit delete"><span><g:message code="button.delete"/></span></a>
	         </g:if>
	           
	        </div>
	    </div>
</div>
<g:render template="/confirm"
     model="[message: 'Are you sure you want to delete order status "'+selected?.description+'" ?',
             controller: 'orderStatus',
             action: 'delete',
             id: selected.id,
            ]"/>