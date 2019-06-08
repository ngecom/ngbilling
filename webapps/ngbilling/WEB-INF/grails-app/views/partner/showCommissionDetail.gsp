<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
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

<html>
<head>
	<meta name="layout" content="main"/>
</head>

<body>

    <div class="table-info">
        <em><strong><g:message code="label.commission.partner"/> ${commission.partner.baseUser.userName}</strong></em>
        <em><strong><g:message code="label.commission.amount"/> <g:formatNumber number="${commission.amount}" formatName="money.format"/></strong></em>

    </div>

    <div class="table-area">
        <table>
            <thead>
                <tr>
                    <td class="first"><g:message code="label.InvoiceCommission.partner"/></td>
                    <td class="first"><g:message code="label.InvoiceCommission.source"/></td>
                    <td class="first"><g:message code="label.InvoiceCommission.standardAmount"/></td>
                    <td class="first"><g:message code="label.InvoiceCommission.masterAmount"/></td>
                    <td class="first"><g:message code="label.InvoiceCommission.exceptionAmount"/></td>
                    <td class="last"><g:message code="label.InvoiceCommission.referralAmount"/></td>
                </tr>
            </thead>
            <tbody>

            <g:each var="invoiceCommission" status="i" in="${invoiceCommissions}">
                <tr class="${i % 2 == 0 ? 'even' : 'odd'}">
                    <td class="col02">
                        ${invoiceCommission.partner.baseUser.userName}
                    </td>
                    <td>
                        <g:if test="${!invoiceCommission.referralPartner}">
                            <g:message code="label.InvoiceCommission.invoice"/>
                            <sec:access url="/invoice/list">
                                <g:remoteLink controller="invoice" action="list" id="${invoiceCommission.invoice.id}"
                                               before="register(this);" onSuccess="render(data, next);">
                                    ${invoiceCommission.invoice.id}
                                </g:remoteLink>
                            </sec:access>
                        </g:if>
                        <g:else>
                            <g:message code="label.InvoiceCommission.referral"/>
                            <sec:access url="/partner/list">
                                <g:remoteLink controller="partner" action="list" id="${invoiceCommission.referralPartner.id}"
                                              before="register(this);" onSuccess="render(data, next);">
                                    ${StringEscapeUtils.escapeHtml(invoiceCommission?.referralPartner?.baseUser?.userName)}
                                </g:remoteLink>
                            </sec:access>
                        </g:else>
                    </td>
                    <td>
                        <g:formatNumber number="${invoiceCommission.standardAmount}" type="currency" currencySymbol="${invoiceCommission.commission.currency.symbol}"/>
                    </td>
                    <td>
                        <g:formatNumber number="${invoiceCommission.masterAmount}" type="currency" currencySymbol="${invoiceCommission.commission.currency.symbol}"/>
                    </td>
                    <td>
                        <g:formatNumber number="${invoiceCommission.exceptionAmount}" type="currency" currencySymbol="${invoiceCommission.commission.currency.symbol}"/>
                    </td>
                    <td>
                        <g:formatNumber number="${invoiceCommission.referralAmount}" type="currency" currencySymbol="${invoiceCommission.commission.currency.symbol}"/>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>

</body>