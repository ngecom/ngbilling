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

<%@ page import="org.apache.commons.lang.StringEscapeUtils; com.sapienter.jbilling.server.user.UserBL; com.sapienter.jbilling.server.user.contact.db.ContactDTO" %>

<%--
  Customer table template. The customer table is used multiple times for rendering the
  main list and for rendering a separate list of sub-accounts. 

  @author Brian Cowdery
  @since  24-Nov-2010
--%>

<div class="table-box">
    <table id="users" cellspacing="0" cellpadding="0">
        <thead>
            <tr>
                <th>
                    <g:remoteSort action="list" sort="userName" update="column1">
                        <g:message code="customer.table.th.name"/>
                    </g:remoteSort>
                </th>
                <g:isRoot>
                	<th class="tiny3">
                		<g:remoteSort action="list" sort="company.description" update="column1">
                    	    <g:message code="customer.table.th.user.company.name"/>
                    	</g:remoteSort>
                	</th>
                </g:isRoot>
                <th class="small">
                    <g:remoteSort action="list" sort="id" update="column1">
                        <g:message code="customer.table.th.user.id"/>
                    </g:remoteSort>
                </th>
                <th class="tiny2">
                    <g:remoteSort action="list" sort="userStatus.id" update="column1">
                        <g:message code="customer.table.th.status"/>
                    </g:remoteSort>
                </th>
                <th class="small">
                    <g:message code="customer.table.th.balance"/>
                </th>
                <th class="tiny3">
                    <g:message code="customer.table.th.hierarchy"/>
                </th>
            </tr>
        </thead>

        <tbody>
        <g:each in="${users}" var="user">
            <g:set var="customerVar" value="${user.customer}"/>
            <g:set var="contactVar" value="${ContactDTO.findByUserId(user.id)}"/>
            <tr id="user-${user.id}" class="${selected?.id == user.id ? 'active' : ''}">
                <td>
                    <g:remoteLink class="cell double" action="show" id="${user.id}" before="register(this);" onSuccess="render(data, next);">
                        <strong>
                            <g:if test="${contactVar?.firstName || contactVar?.lastName}">
                                ${StringEscapeUtils.escapeHtml(contactVar?.firstName)} ${StringEscapeUtils.escapeHtml(contactVar?.lastName)}
                            </g:if>
                            <g:else>
                                ${StringEscapeUtils.escapeHtml(user?.userName)}
                            </g:else>
                        </strong>
                        <em>${StringEscapeUtils.escapeHtml(contactVar?.organizationName)}</em>
                    </g:remoteLink>
                </td>
                <g:isRoot>
                	<td>
                    	<g:remoteLink class="cell" action="show" id="${user.id}" before="register(this);" onSuccess="render(data, next);">
                        	<strong>${StringEscapeUtils.escapeHtml(user?.company.description)}</strong>
                   		</g:remoteLink>
                	</td>
                </g:isRoot>
                <td>
                    <g:remoteLink class="cell" action="show" id="${user.id}" before="register(this);" onSuccess="render(data, next);">
                        <span>${user.id}</span>
                    </g:remoteLink>
                </td>
                <td class="center">
                    <g:remoteLink class="cell" action="show" id="${user.id}" before="register(this);" onSuccess="render(data, next);">
                        <span>                        	
                             <g:if test="${user.deleted}">
                             	<img src="${resource(dir:'images', file:'cross.png')}" alt="deleted" />
                             </g:if>        
                            <g:elseif test="${user.userStatus.id == 1}">
                                <g:message code="customer.status.active"/>
                            </g:elseif>                       
                            <g:elseif test="${user.userStatus.id > 1 && !user.userStatus.isSuspended()}">
                                <img src="${resource(dir:'images', file:'icon15.gif')}" alt="overdue" />
                            </g:elseif>
                            <g:elseif test="${user.userStatus.id > 1 && user.userStatus.isSuspended()}">
                                <img src="${resource(dir:'images', file:'icon16.gif')}" alt="suspended" />
                            </g:elseif>
                        </span>
                    </g:remoteLink>
                </td>
                <td>
                    <g:remoteLink class="cell" action="show" id="${user.id}" before="register(this);" onSuccess="render(data, next);">
                        <span><g:formatNumber number="${UserBL.getBalance(user.id)}" type="currency"  currencySymbol="${user.currency.symbol}"/></span>
                    </g:remoteLink>
                </td>
                <td class="center">
                    <g:if test="${customerVar}">
                        <g:if test="${customerVar.isParent == 1 && customerVar.parent}">
                            <%-- is a parent, but also a child of another account --%>
                            <g:remoteLink action="subaccounts" id="${user.id}" before="register(this);" onSuccess="render(data, next);">
                                <img src="${resource(dir:'images', file:'icon17.gif')}" alt="parent and child" />
                                <g:set var="children" value="${customerVar.children.findAll{ it.baseUser.deleted == 0 }}"/>
                                <span>${children.size()}</span>
                            </g:remoteLink>
                        </g:if>
                        <g:elseif test="${customerVar.isParent == 1 && !customerVar.parent}">
                            <%-- is a top level parent --%>
                            <g:remoteLink action="subaccounts" id="${user.id}" before="register(this);" onSuccess="render(data, next);">
                                <img src="${resource(dir:'images', file:'icon18.gif')}" alt="parent" />
                                <g:set var="children" value="${customerVar.children.findAll{ it.baseUser.deleted == 0 }}"/>
                                <span>${children.size()}</span>
                            </g:remoteLink>
                        </g:elseif>
                        <g:elseif test="${customerVar.isParent == 0 && customerVar.parent}">
                            <%-- is a child account, but not a parent --%>
                            <img src="${resource(dir:'images', file:'icon19.gif')}" alt="child" />
                        </g:elseif>
                    </g:if>
                </td>
            </tr>

        </g:each>
        </tbody>
    </table>
</div>

<div class="pager-box">
    %{-- remote pager does not support "onSuccess" for panel rendering, take a guess at the update column --}%
    <g:set var="action" value="${actionName == 'subaccounts' ? 'subaccounts' : 'list'}"/>
    <g:set var="csvAction" value="${actionName == 'subaccounts' ? 'subaccountsCsv' : 'csv'}"/>
    <g:set var="id" value="${actionName == 'subaccounts' ? parent.id : null}"/>
    <g:set var="updateColumn" value="${actionName == 'subaccounts' ? 'column2' : 'column1'}"/>

    <div class="row">
        <div class="results">
            <g:render template="/layouts/includes/pagerShowResults" model="[steps: [10, 20, 50], update: updateColumn, contactFieldTypes: contactFieldTypes]" />
        </div>
        <div class="download">
            <sec:access url="/customer/csv">
                <g:link action="${csvAction}" id="${id}" params="${sortableParams(params: [partial: true, contactFieldTypes: contactFieldTypes])}" >
                    <g:message code="download.csv.link"/>
                </g:link>
            </sec:access>
        </div>
    </div>

    <div class="row">
        <util:remotePaginate controller="customer" action="${action ?: 'list'}" id="${id}" params="${sortableParams(params: [partial: true, contactFieldTypes: contactFieldTypes])}" total="${users?.totalCount ?: 0}" update="${updateColumn}"/>
    </div>
</div>

<div class="btn-box">
        <g:if test="${parent?.customer?.isParent > 0}">
                <g:link action="edit" params="[parentId: parent.id]" class="submit add"><span><g:message code="customer.add.subaccount.button"/></span></g:link>
        </g:if>
        <g:else>
                <g:link action='edit' class="submit add"><span><g:message code="button.create"/></span></g:link>
        </g:else>
</div>
