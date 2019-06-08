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

<div class="heading">
    <strong><g:message code="asset.heading.assignments"/></strong>
</div>

<div class="box">
    <div class="sub-box">
        <g:if test="${assignments}">
            <table class="innerTable">
                <thead class="innerHeader">
                <tr>
                	<th><g:message code="asset.label.assign.order"/></th>
                    <th><g:message code="asset.label.assign.userId"/></th>
                    <th><g:message code="asset.label.assign.start.date"/></th>
                    <th><g:message code="asset.label.assign.end.date"/></th>
                </tr>
                </thead>
                <tbody>
                <g:each var="assignment" in="${assignments}" status="idx">
                <g:set var="userId" value="${assignment?.orderLine.purchaseOrder.userId}"/>
                    <tr>
                        <td class="innerContent">
                            <sec:access url="/order/show">
                                <g:remoteLink breadcrumb="id" controller="order" action="show"
                                              id="${assignment.orderId}" params="['template': 'order']"
                                              before="register(this);" onSuccess="render(data, next);">
                                    ${assignment.orderId}
                                </g:remoteLink>
                            </sec:access>
                            <sec:noAccess url="/order/show">
                                ${assignment.orderId}
                            </sec:noAccess>
                        </td>
                        
                        <td class="innerContent">
                            <sec:access url="/customer/show">
                                <g:remoteLink breadcrumb="id" controller="customer" action="show"
                                              id="${userId}" params="['template': 'show']"
                                              before="register(this);" onSuccess="render(data, next);">
                                    ${userId}
                                </g:remoteLink>
                            </sec:access>
                            <sec:noAccess url="/customer/show">
                                ${userId}
                            </sec:noAccess>
                        </td>
                        
                        <td class="innerContent">
                            <g:formatDate formatName="date.format" date="${assignment.startDatetime}"/>
                        </td>
                        <td class="innerContent">
                            <g:if test="${assignment.endDatetime}">
                                <g:formatDate formatName="date.format" date="${assignment.endDatetime}"/>
                            </g:if>
                            <g:else>-</g:else>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </g:if>
        <g:else>
            <em><g:message code="asset.prompt.no.assignments"/></em>
        </g:else>
    </div>
</div>