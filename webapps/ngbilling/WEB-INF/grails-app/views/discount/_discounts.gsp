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

<%@ page import="org.apache.commons.lang.StringEscapeUtils; com.sapienter.jbilling.server.user.contact.db.ContactDTO" contentType="text/html;charset=UTF-8" %>

<%--
  Shows a list of discounts.

  @author Amol Gadre
  @since  27-Nov-2012
--%>

<div class="table-box">
    <table id="discounts" cellspacing="0" cellpadding="0">
        <thead>
            <tr>
                <th>
                	<g:remoteSort action="list" sort="code" update="column1" >
                		<g:message code="discounts.th.code"/>
                	</g:remoteSort>
                </th>
                <th><g:message code="discounts.th.description"/></th>
                <th>
                	<g:remoteSort action="list" sort="type" update="column1" >
                		<g:message code="discounts.th.type"/>
                	</g:remoteSort>
                </th>
            </tr>
        </thead>

        <tbody>
            <g:each var="discount" in="${discounts}">

                <tr id="discount-${discount.id}" class="${selected?.id == discount.id ? 'active' : ''}">
                    <td>
                        <g:remoteLink class="cell double" action="show" id="${discount.id}" before="register(this);" onSuccess="render(data, next);">
                            <strong>${StringEscapeUtils.escapeHtml(discount?.code)}</strong>
                            <em><g:message code="table.id.format" args="[discount.id as String]"/></em>
                        </g:remoteLink>
                    </td>

                    <td>
                        <g:remoteLink class="cell" action="show" id="${discount.id}" before="register(this);" onSuccess="render(data, next);">
                            ${StringEscapeUtils.escapeHtml(discount?.description)}
                        </g:remoteLink>
                    </td>

                    <td>
                        <g:remoteLink class="cell" action="show" id="${discount.id}" before="register(this);" onSuccess="render(data, next);">
                            <g:message code="${StringEscapeUtils.escapeHtml(discount?.type?.messageKey)}"/>
                        </g:remoteLink>
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
        <util:remotePaginate controller="discount" action="list" params="${sortableParams(params: [partial: true])}" total="${discounts?.totalCount ?: 0}" update="column1"/>
    </div>
</div>

<div class="btn-box">
	    <g:link action="edit" class="submit add">
		<span><g:message code="button.create"/></span>
	    </g:link>
</div>