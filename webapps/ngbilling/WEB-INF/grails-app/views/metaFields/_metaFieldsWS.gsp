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

<%@ page import="com.sapienter.jbilling.server.metafields.DataType" %>

<%--
  View template to render a formatted list of meta-fields to be printed as part of a data table..

  <g:render template="/metaFields/metaFields" model="[ metaFields: object.metaFields ]"/>

  @author Brian Cowdery
  @since 25-Oct-2011
--%>

<g:each var="metaField" in="${metaFields?.sort{ it.displayOrder }}">
    <g:if test="${!metaField.disabled}">
        <g:set var="fieldValue" value="${metaField.getValue()}"/>

        <tr>
            <td>
                <g:message code="${metaField.fieldName}"/>
            </td>
            <td class="value">
                <g:if test="${metaField.getDataType() == DataType.DATE}">
                    <g:formatDate date="${fieldValue}" formatName="date.pretty.format"/>
                </g:if>
                <g:else>
                    ${fieldValue}
                </g:else>
            </td>
        </tr>
    </g:if>

</g:each>
