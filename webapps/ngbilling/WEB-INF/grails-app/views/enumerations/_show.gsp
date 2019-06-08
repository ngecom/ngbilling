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

<%@ page contentType="text/html;charset=UTF-8" %>

<%--
  Shows an enumeration

  @author Vikas Bodani
  @since 09-Aug-2011
--%>

<div class="column-hold">
    <div class="heading">
        <strong>
            ${selected?.getName()}
            <em>- <g:message code="enumeration.type.values.value"/></em>
        </strong>
    </div>
    <!-- Enumeration Values -->
    <div class="box">
      <div class="sub-box">
        <table class="dataTable" cellspacing="0" cellpadding="0">
            <tbody>
                <g:each var="val" status="n" in="${selected?.values}">
                    <tr>
                        <td>
                            ${n+1}
                        </td>
                        <td class="value">
                            ${val.value}
                        </td>
                    </tr>
                </g:each>
            </tbody>
        </table>
      </div>
    </div>
    <div class="btn-box">
        <div class="row">
            <g:link action="edit" id="${selected?.id}"
                class="submit edit"
            >
                <span><g:message code="button.edit" />
                </span>
            </g:link>
            <a onclick="showConfirm('delete-${selected?.id}');"
                class="submit delete"><span><g:message code="button.delete" />
            </span>
            </a>
        </div>
    </div>
    <g:render template="/confirm"
          model="['message': 'enumeration.delete.confirm',
                  'controller': 'enumerations',
                  'action': 'delete',
                  'id': selected?.id,
                 ]"/>
</div>