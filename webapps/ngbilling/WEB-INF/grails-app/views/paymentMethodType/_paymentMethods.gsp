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
<%@ page import="org.apache.commons.lang.StringEscapeUtils" contentType="text/html;charset=UTF-8" %>


<div class="table-box">
    <table id="periods" cellspacing="0" cellpadding="0">
        <thead>
        <tr>
        <th class="medium"><g:message code="accountType.description"/></th>

        </thead>

        <tbody>
        <g:each var="paymentMethod" in="${paymentMethods}">

            <tr id="payment-${paymentMethod.id}" class="${selected?.id == paymentMethod.id ? 'active' : ''}">
                <!-- ID -->
                <td>
                    <g:remoteLink class="cell double" action="show" id="${paymentMethod.id}" before="register(this);"
                                  onSuccess="render(data, next);">
                        <strong>${StringEscapeUtils.escapeHtml(paymentMethod?.methodName)}</strong>
                        <em><g:message code="table.id.format" args="[paymentMethod.id]"/></em>
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
            <g:render template="/layouts/includes/pagerShowResults"
                      model="[steps: [10, 20, 50], update: 'column1']"/>
        </div>
    </div>

    <div class="row">
        <util:remotePaginate controller="paymentMethodType" action="${action ?: 'list'}"
                             params="${sortableParams(params: [partial: true])}"
                             total="${paymentMethods?.totalCount ?: 0}" update="column1"/>
    </div>
</div>

<div class="btn-box">
    <a href="${createLink(action: 'edit')}" class="submit add"><span><g:message code="button.create"/></span></a>
</div>