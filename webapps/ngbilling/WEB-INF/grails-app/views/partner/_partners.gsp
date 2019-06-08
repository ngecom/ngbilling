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

<%@ page import="org.apache.commons.lang.StringEscapeUtils; com.sapienter.jbilling.client.util.SortableCriteria; com.sapienter.jbilling.server.user.UserBL; com.sapienter.jbilling.server.user.contact.db.ContactDTO" %>

<%--
  Customer table template. The customer table is used multiple times for rendering the
  main list and for rendering a separate list of sub-accounts. 

  @author Vikas Bodani
  @since  25-Jul-2011
--%>

<div class="table-box">
    <table id="users" cellspacing="0" cellpadding="0">
        <thead>
            <tr>
                <th>
                    <g:remoteSort action="list" sort="contact.firstName, contact.lastName, contact.organizationName" alias="${SortableCriteria.NO_ALIAS}" update="column1">
                        <g:message code="customer.table.th.name"/>
                    </g:remoteSort>
                </th>
                <th class="small">
                    <g:remoteSort action="list" sort="id" update="column1">
                        <g:message code="customer.table.th.partner.id"/>
                    </g:remoteSort>
                </th>
                <th class="tiny2">
                    <g:remoteSort action="list" sort="userStatus.id" alias="[userStatus: 'baseUser.userStatus']" update="column1">
                        <g:message code="customer.table.th.status"/>
                    </g:remoteSort>
                </th>
                <th class="tiny3">
                   <g:message code="customer.table.th.hierarchy"/>
               </th>
            </tr>
        </thead>

        <tbody>
        <g:each in="${partners}" var="partner">

            <g:set var="user" value="${partner?.baseUser}"/>
            <g:set var="customer" value="${user?.customer}"/>
            <g:set var="contactVar" value="${ContactDTO.findByUserId(user.id)}"/>

            <tr id="partner-${partner.id}" class="${selected?.id == partner.id ? 'active' : ''}">
                <td>
                    <g:remoteLink class="cell double" action="show" id="${partner.id}" before="register(this);" onSuccess="render(data, next);">
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
                <td>
                    <g:remoteLink class="cell" action="show" id="${partner.id}" before="register(this);" onSuccess="render(data, next);">
                        <span>${partner.id}</span>
                    </g:remoteLink>
                </td>
                <td class="center">
                    <g:remoteLink class="cell" action="show" id="${partner.id}" before="register(this);" onSuccess="render(data, next);">
                        <span>
                        	<g:if test="${user.userStatus.id == 1}">
                                <g:message code="customer.status.active"/>
                             </g:if>
                            <g:if test="${user.userStatus.id > 1 && user.userStatus.id < 5}">
                                <img src="${resource(dir:'images', file:'icon15.gif')}" alt="overdue" />
                            </g:if>
                            <g:elseif test="${user.userStatus.id >= 5}">
                                <img src="${resource(dir:'images', file:'icon16.gif')}" alt="suspended" />
                            </g:elseif>
                        </span>
                    </g:remoteLink>
                </td>

                <td class="center">
                    <g:if test="${user.partner}">
                        <g:if test="${user.partner.children && !user.partner.parent}">
                            <%-- is a top level parent --%>
                                <img src="${resource(dir:'images', file:'icon18.gif')}" alt="parent" />
                                <g:set var="children" value="${user.partner.children.findAll{ it.baseUser.deleted == 0 }}"/>
                                <span>${children.size()}</span>
                        </g:if>
                        <g:elseif test="${!user.partner.children && user.partner.parent}">
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
    <div class="row">
        <div class="results">
            <g:render template="/layouts/includes/pagerShowResults" model="[steps: [10, 20, 50], update: 'column1']"/>
        </div>
    </div>

    <div class="row">
        <util:remotePaginate controller="partner" action="list" params="${sortableParams(params: [partial: true])}" total="${partners?.totalCount ?: 0}" update="column1"/>
    </div>
</div>

<div class="btn-box">
        <g:if test="${loggedInUser?.partner}">
            <g:if test="${!loggedInUser?.partner?.parent}">
                <g:link action='edit' params="[parentId: loggedInUser.partner.id]" class="submit add"><span><g:message code="button.create"/></span></g:link>
            </g:if>
        </g:if>
        <g:else>
            <g:link action='edit' class="submit add"><span><g:message code="button.create"/></span></g:link>
        </g:else>
        <g:link action='showCommissionRuns' class="submit show"><span><g:message code="button.showCommissions"/></span></g:link>
</div>
