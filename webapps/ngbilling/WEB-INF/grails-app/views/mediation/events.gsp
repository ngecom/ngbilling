%{--
  JBILLING CONFIDENTIAL
  _____________________

  [2003] - [2012] Enterprise jBilling Software Ltd.
  All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Enterprise jBilling Software.
  The intellectual and technical concepts contained
  herein are proprietary to Enterprise jBilling Software
  and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden.
  --}%

<html>
<head>
	<meta name="layout" content="main"/>
</head>
<body>
    <g:set var="currency" value="${invoice?.currency ?: order?.currency}"/>

    %{-- Invoice summary if invoice set --}%
    <g:if test="${invoice}">
        <div class="table-info" >
            <em>
                <g:message code="event.summary.invoice.id"/>
                <strong>${invoice.id}</strong>
            </em>
            <em>
                <g:message code="event.summary.invoice.due.date"/>
                <strong><g:formatDate date="${invoice.dueDate}" formatName="date.pretty.format"/></strong>
            </em>
            <em>
                <g:message code="event.summary.invoice.total"/>
                <strong><g:formatNumber number="${invoice.total}" type="currency" currencySymbol="${currency.symbol}"/></strong>
            </em>
        </div>
    </g:if>

    %{-- Order summary if order set --}%
    <g:if test="${order}">
        <div class="table-info" >
            <em>
                <g:message code="event.summary.order.id"/>
                <strong>${order.id}</strong>
            </em>
            <em>
                <g:message code="event.summary.order.total"/>
                <strong><g:formatNumber number="${order.total}" type="currency" currencySymbol="${currency.symbol}"/></strong>
            </em>
        </div>
    </g:if>

    <div class="table-area">
        <table>
            <thead>
                <tr>
                    <td class="first"><g:message code="event.th.id"/></td>
                    <td><g:message code="event.th.key"/></td>
                    <td><g:message code="event.th.date"/></td>
                    <td><g:message code="event.th.description"/></td>
                    <td><g:message code="event.th.quantity"/></td>
                    <td class="last"><g:message code="event.th.amount"/></td>
                </tr>
            </thead>
            <tbody>

                <!-- events list -->
                <g:set var="totalQuantity" value="${BigDecimal.ZERO}"/>
                <g:set var="totalAmount" value="${BigDecimal.ZERO}"/>

            <g:each var="recordLine" in="${records}">
                <g:set var="totalQuantity" value="${totalQuantity.add(recordLine.quantity)}"/>
                <g:set var="totalAmount" value="${totalAmount.add(recordLine.amount)}"/>

                <tr>
                    <td class="col02">
                        ${recordLine.id}
                    </td>
                    <td>
                        ${recordLine.record.key}
                    </td>
                    <td>
                        <g:formatDate date="${recordLine.eventDate}" formatName="date.pretty.format"/>
                    </td>
                    <td class="col03">
                        ${recordLine.description ?: '-'}
                    </td>
                    <td>
                        <strong>
                            <g:formatNumber number="${recordLine.quantity}" formatName="decimal.format"/>
                        </strong>
                    </td>
                    <td>
                        <strong>
                            <g:formatNumber number="${recordLine.amount}"  type="currency" currencySymbol="${currency.symbol}"/>
                        </strong>
                    </td>
                </tr>
            </g:each>

                <!-- subtotals -->
                <tr class="bg">
                    <td class="col02"></td>
                    <td></td>
                    <td></td>
                    <td></td>

                    <td>
                        <strong><g:formatNumber number="${totalQuantity}" formatName="decimal.format"/></strong>
                    </td>
                    <td>
                        <strong><g:formatNumber number="${totalAmount}" type="currency" currencySymbol="${currency.symbol}"/></strong>
                    </td>
                </tr>

            </tbody>
        </table>
    </div>

</body>
</html>
