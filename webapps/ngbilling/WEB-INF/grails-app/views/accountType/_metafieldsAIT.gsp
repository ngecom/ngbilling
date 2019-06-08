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

<%@ page import="org.apache.commons.lang.StringEscapeUtils; com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.item.db.ItemTypeDTO" %>

<%--
  Shows list of metafields available as a templates
  for creation of an account information type fields

  @author Panche Isajeski
  @since 05/24/2013
--%>

<div id="metafield-box">

    <div class="table-box tab-table">
        <div class="table-scroll">
            <table id="metafields" cellspacing="0" cellpadding="0">
                <tbody>

                <g:each var="metaField" in="${metaFields}">
                    <tr>
                        <td>
                            <g:remoteLink class="cell double" action="editAIT" id="${metaField.id}" params="[_eventId: 'addMetaField']" update="column2" method="GET"
                                          onSuccess="changeMetafieldDataType()">
                                <span>${StringEscapeUtils.escapeHtml(metaField?.name)}</span>
                                <em><g:message code="table.id.format" args="[metaField.id as String]"/></em>
                            </g:remoteLink>
                        </td>
                        <td class="small">
                            <g:remoteLink class="cell double" action="editAIT" id="${metaField.id}" params="[_eventId: 'addMetaField']" update="column2" method="GET"
                                          onSuccess="changeMetafieldDataType()">
                                <span>${StringEscapeUtils.escapeHtml(metaField?.dataType)}</span>
                            </g:remoteLink>
                        </td>
                        <td class="medium">
                            <g:remoteLink class="cell double" action="editAIT" id="${metaField.id}"
                                          params="[_eventId: 'addMetaField']" update="column2" method="GET" onSuccess="changeMetafieldDataType()">
                                <span>${metaField.mandatory ? "Mandatory" : "Not Mandatory"}</span>
                            </g:remoteLink>
                        </td>
                    </tr>
                </g:each>

                </tbody>
            </table>
        </div>
    </div>

</div>