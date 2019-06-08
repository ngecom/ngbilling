<%@ page import="com.sapienter.jbilling.server.payment.PaymentInformationBL; com.sapienter.jbilling.client.util.ClientConstants" %>

<g:if test="${paymentInstr.paymentMethodType.paymentMethodTemplate.templateName.equals("Payment Card")}">
    <table class="dataTable" cellspacing="0" cellpadding="0">
        <tbody>
        <tr>
            <td><g:message code="customer.detail.payment.credit.card"/></td>
            <td class="value">
                <g:set var="expireDate" value="${paymentInstr.metaFields.grep{it.field.name.equals('cc.expiry.date')}?.value?.join()}"/>
                <g:set var="card" value="${paymentInstr.metaFields.grep{it.field.name.equals('cc.number')}}"/>
                <g:if test="${card?.value}">
                %{-- obscure credit card by default, or if the preference is explicitly set --}%
                    <g:set var="creditCardNumber" value="${card?.value.join()}"/>
                    <g:set var="creditCardNumber" value="${creditCardNumber.replaceAll('^\\d{12}', PaymentInformationBL.OBSCURED_NUMBER_FORMAT)}"/>
                    ${creditCardNumber}
                </g:if>
            </td>
        </tr>

        <tr>
            <td><g:message code="customer.detail.payment.credit.card.expiry"/></td>
            <td class="value">${expireDate}</td>
        </tr>
        </tbody>
    </table>
</g:if>