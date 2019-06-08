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
  
<%@page import="org.apache.commons.lang.StringEscapeUtils; com.sapienter.jbilling.server.process.db.PeriodUnitDTO" %>
<%@page import="com.sapienter.jbilling.server.order.OrderStatusFlag" %>
<%@page import="com.sapienter.jbilling.client.util.ClientConstants" %>



<%@ page contentType="text/html;charset=UTF-8" %>

<%--
  Shows a list of order Statuses.

  @author Maruthi
  @since  20-June-2013
--%>

<div class="table-box">
    <table id="orderStatuses" cellspacing="0" cellpadding="0">
        <thead>
            <tr>
               <th class="tiny"><g:message code="orderStatus.id"/></th>
                <th class="large"><g:message code="orderStatus.flag"/></th>
                <th class="large"><g:message code="orderStatus.description"/></th>
                
            </tr>
        </thead>


        <tbody>
            <g:each var="orderStatus" in="${orderStatusList}">
                <tr id="orderStatus-${orderStatus.id}" >
                    
                    <!-- Order Status Id -->
                    <td>
                        <g:remoteLink class="cell double" action="show" id="${orderStatus.id}" before="register(this);" onSuccess="render(data, next);">
                            ${orderStatus?.id}
                        </g:remoteLink>
                    </td>
                    <!-- Flag -->
                    <td>
                        <g:remoteLink class="cell double" action="show" id="${orderStatus.id}" before="register(this);" onSuccess="render(data, next);">
                            ${orderStatus?.orderStatusFlag}
                        </g:remoteLink>
                    </td>
                     <!-- Description -->
                    <td>
                        <g:remoteLink class="cell double" action="show" id="${orderStatus.id}" before="register(this);" onSuccess="render(data, next);">
                            ${StringEscapeUtils.escapeHtml(orderStatus?.description)}
                        </g:remoteLink>
                    </td>
                </tr>
            </g:each>
        </tbody>
    </table>
</div>

<div class="btn-box">
    <g:remoteLink class="submit add" action="edit" before="register(this);" onSuccess="render(data, next);">
        <span><g:message code="button.create"/></span>
    </g:remoteLink>
</div>