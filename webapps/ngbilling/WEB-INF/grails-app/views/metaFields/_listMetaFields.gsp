<%@ page import="org.apache.commons.lang.StringEscapeUtils; org.apache.commons.lang.StringUtils" %>
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


<div class="table-box">
    <table id="roles" cellspacing="0" cellpadding="0">
        <thead>
            <tr>
                <th><g:message code="metaField.th.name"/></th>
            </tr>
        </thead>

        <tbody>
            <g:each var="metaField" in="${lstByCategory}">

                <tr id="metaField-${metaField.id}" class="${selected?.id == metaField.id ? 'active' : ''}">
                    <td>
                        <g:remoteLink class="cell double" action="show" id="${metaField.id}" before="register(this);" onSuccess="render(data, next);">
                            <strong>${StringUtils.abbreviate(StringEscapeUtils.escapeHtml(metaField?.name), 50)}</strong>
                            <em><g:message code="table.id.format" args="[metaField.id]"/></em>
                        </g:remoteLink>
                    </td>
                </tr>

            </g:each>
        </tbody>
    </table>
</div>

<div class="btn-box">
    <g:link action="edit" class="submit add" params="[entityType: params.id]">
        <span><g:message code="button.create"/></span>
    </g:link>
</div>
