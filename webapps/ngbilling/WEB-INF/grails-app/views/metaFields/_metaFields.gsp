<%@ page import="com.sapienter.jbilling.server.metafields.DataType; com.sapienter.jbilling.common.CommonConstants" %>

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
  View template to render a formatted list of meta-fields to be printed as part of a data table..

  <g:render template="/metaFields/metaFields" model="[ metaFields: object.metaFields ]"/>

  @author Brian Cowdery
  @since 25-Oct-2011
--%>

<g:each var="metaField" in="${metaFields?.sort{ it.field.displayOrder }}">
    <g:if test="${!metaField.field.disabled}">
        <g:set var="fieldValue" value="${metaField.getValue()}"/>

        <tr>
            <td>
                <g:message code="${metaField.field.name}"/>
            </td>
            <td class="value">
        
                <g:if test="${ metaField.field.fieldUsage == com.sapienter.jbilling.server.metafields.MetaFieldType.PAYMENT_CARD_NUMBER }">
                    <g:set var="creditCardNumber" value="${fieldValue.replaceAll('^\\d{12}','************')}"/>
                    ${creditCardNumber}
                </g:if>
                <g:else>
                    <g:if test="${metaField.field.getDataType() == DataType.DECIMAL}">
                        <g:formatNumber number="${fieldValue}" formatName="decimal.format"/>
                    </g:if>
                    <g:else>
                        ${fieldValue}
                    </g:else>
                </g:else>
            </td>
        </tr>
    </g:if>

</g:each>
