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

  @author Panche Isajeski
  @since  05/24/2013
--%>

<%@ page import="org.apache.commons.lang.StringEscapeUtils" contentType="text/html;charset=UTF-8" %>


<div class="table-box">
    <table id="periods" cellspacing="0" cellpadding="0">
        <thead>
        <tr>
        <th class="medium"><g:message code="account.information.type.title"/></th>

        </thead>

        <tbody>
        <g:each var="ait" in="${aits}">

            <tr id="period-${ait.id}" class="${selected?.id == ait?.id ? 'active' : ''}">
                <!-- ID -->
                <td>
                    <g:remoteLink class="cell double" action="showAIT" id="${ait.id}"
                                  params="[accountTypeId: accountType?.id, template: 'showAIT']" before="register(this);"
                                  onSuccess="render(data, next);">

                        <strong>${StringEscapeUtils.escapeHtml(ait?.name)}</strong>
                        <em><g:message code="table.id.format" args="[ait.id]"/></em>
                    </g:remoteLink>
                </td>

            </tr>

        </g:each>
        </tbody>
    </table>
</div>

<div class="btn-box">
    <a href="${createLink(action: 'editAIT', params:[accountTypeId : accountType?.id])}" class="submit add">
        <span><g:message code="button.create"/></span
    ></a>
</div>