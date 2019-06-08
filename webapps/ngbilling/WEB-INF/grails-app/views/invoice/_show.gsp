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

<%@ page import="com.sapienter.jbilling.server.invoice.InvoiceLineComparator; com.sapienter.jbilling.server.util.ServerConstants"%>

<g:set var="currency" value="${selected.currency}"/>
<g:set var="user" value="${selected.baseUser}"/>

<div class="column-hold">

    <div class="heading">
        <strong>
            <g:if test="${selected.isReview == 1}">
                <g:message code="invoice.label.review.details"/>
            </g:if>
            <g:else>
                <g:message code="invoice.label.details"/>
            </g:else>
            <em>${selected.publicNumber}</em>
        </strong>
    </div>

    <!-- Invoice details -->
    <div class="box">
        <div class="sub-box">
            <table class="dataTable">
                    <tr>
                        <td colspan="2">
                            <strong>
                                <g:if test="${user.contact?.firstName || user.contact?.lastName}">
                                    ${user.contact?.firstName}&nbsp;${user.contact?.lastName}
                                </g:if>
                                <g:else>
                                    ${user.userName}
                                </g:else>
                            </strong><br>
                            <em>${user.contact?.organizationName}</em>
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="invoice.label.user.id"/></td>
                        <td class="value">
                            <sec:access url="/customer/show">
                                <g:remoteLink controller="customer" action="show" id="${user.id}" before="register(this);" onSuccess="render(data, next);">
                                    ${user.id}
                                </g:remoteLink>
                            </sec:access>
                            <sec:noAccess url="/customer/show">
                                ${user.id}
                            </sec:noAccess>
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="invoice.label.user.name"/>:</td>
                        <td class="value">${user.userName}</td>
                    </tr>
                    <g:isRoot>
                    	<tr>
                            	<td><g:message code="invoice.label.company.name"/></td>
                            	<td class="value">${user?.company.description}</td>
                        	</tr>
                    </g:isRoot>
                </table>
        
                <table class="dataTable">
                    <tr>
                        <td><g:message code="invoice.label.id"/></td>
                        <td class="value">${selected.id}</td>
                    </tr>
                    <tr>
                        <td><g:message code="invoice.label.number"/></td>
                        <td class="value">${selected.number}</td>
                    </tr>
                    <tr>
                        <td><g:message code="invoice.label.status"/></td>
                        <td class="value">
                            <g:if test="${selected.isReview == 1}">
                                <g:message code="invoice.status.review"/>
                            </g:if>
                            <g:else>
                                ${selected.invoiceStatus.getDescription(session['language_id'])}
                            </g:else>
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="invoice.label.date"/></td>
                        <td class="value">
                            <g:formatDate date="${selected?.createDatetime}" formatName="date.pretty.format"/>
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="invoice.label.duedate"/></td>
                        <td class="value">
                            <g:formatDate date="${selected?.dueDate}" formatName="date.pretty.format"/>
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="invoice.label.gen.date"/></td>
                        <td class="value">
                            <g:formatDate date="${selected?.createTimestamp}" formatName="date.pretty.format"/>
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="invoice.label.amount"/></td>
                        <td class="value">
                            <g:formatNumber number="${selected?.total ?: BigDecimal.ZERO}" type="currency" currencySymbol="${currency?.symbol}"/>
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="invoice.label.balance"/></td>
                        <td class="value">
                            <g:formatNumber number="${selected?.balance ?: BigDecimal.ZERO}" type="currency" currencySymbol="${currency?.symbol}"/>
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="invoice.label.carried.bal"/></td>
                        <td class="value">
                            <g:formatNumber number="${selected?.carriedBalance ?: BigDecimal.ZERO}" type="currency" currencySymbol="${currency?.symbol}"/>
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="invoice.label.payment.attempts"/></td>
                        <td class="value">${selected.paymentAttempts}</td></tr>
                    <tr>
                        <td><g:message code="invoice.label.orders"/></td>
                        <td class="value">
                            <g:each var="orderProcess" status="i" in="${selected.orderProcesses}">
                                <sec:access url="/order/show">
                                <g:remoteLink breadcrumb="id" controller="order" action="show" id="${orderProcess.purchaseOrder.id}" params="['template': 'order']" before="register(this);" onSuccess="render(data, next);">
                                    ${orderProcess.purchaseOrder.id}
                                </g:remoteLink>
                                </sec:access>
                                <sec:noAccess url="/order/show">
                                    ${orderProcess.purchaseOrder.id}
                                </sec:noAccess>
                                <g:if test="${i < selected.orderProcesses.size() -1}">,</g:if>
                            </g:each>
                        </td>
                    </tr>
                    <g:if test="${selected.invoice}">
                        <tr>
                            <td><g:message code="invoice.label.delegated.to"/></td>
                            <td class="value">
                                <g:remoteLink controller="invoice" action="show" id="${selected.invoice.id}" before="register(this);" onSuccess="render(data, next);">
                                    ${selected.invoice.id}
                                </g:remoteLink>
                            </td>
                        </tr>
                    </g:if>
                    <g:if test="${selected?.metaFields}">
                        <!-- empty spacer row -->
                        <tr>
                            <td colspan="2"><br/></td>
                        </tr>
                        <g:render template="/metaFields/metaFields" model="[metaFields: selected?.metaFields]"/>
                    </g:if>            
                </table>
            </div>
    </div>

    <!-- delegated invoice -->
    <g:if test="${selected.invoices}">
        <div class="heading">
            <strong><g:message code="invoice.title.delegated"/></strong>
        </div>
        <div class="box">

            <div class="sub-box">
                <g:each var="delegatedInvoice" status="i" in="${selected.invoices}">
                    <table class="dataTable">
                    <tr>
                        <td><g:message code="invoice.label.id"/></td>
                        <td class="value">
                            <g:remoteLink controller="invoice" action="show" id="${delegatedInvoice.id}" before="register(this);" onSuccess="render(data, next);">
                                ${delegatedInvoice.id}
                            </g:remoteLink>
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="invoice.label.duedate"/></td>
                        <td class="value">
                            <g:formatDate date="${delegatedInvoice.dueDate}" formatName="date.pretty.format"/>
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="invoice.label.balance"/></td>
                        <td class="value">
                            <g:formatNumber number="${delegatedInvoice.balance ?: BigDecimal.ZERO}" type="currency" currencySymbol="${currency?.symbol}"/>
                        </td>
                    </tr>
                    </table>
    
                    <g:if test="${i < selected.invoices.size() -1}">
                        <div><hr/></div>
                    </g:if>
                </g:each>
            </div>
        </div>
    </g:if>


    <!-- invoice lines -->
    <div class="heading">
        <strong><g:message code="invoice.label.lines"/></strong>
    </div>
    <div class="box">
        <div class="sub-box">
            <table class="innerTable" >
                <thead class="innerHeader">
                <tr>
                    <th><g:message code="label.gui.description"/></th>
                    <th><g:message code="label.gui.quantity"/></th>
                    <th><g:message code="label.gui.price"/></th>
                    <th><g:message code="label.gui.amount"/></th>
                </tr>
                </thead>
                <tbody>
                <g:each var="line" in="${lines}" status="idx">
                    <tr>
                        <td class="${line.id==0 ? 'strong' : ''} innerContent">
                            ${line?.description}
                            <g:if test="${line.id==0}">
                                <sec:access url="/customer/show">
                                    <g:remoteLink controller="customer" action="show" id="${user.id}" before="register(this);" onSuccess="render(data, next);">
                                        (${line?.sourceUserId})
                                    </g:remoteLink>
                                </sec:access>
                                <sec:noAccess url="/customer/show">
                                    (${line?.sourceUserId})
                                </sec:noAccess>
                            </g:if>
                        </td>
                        <td class="${line.id==0 ? 'hide' : ''} innerContent">
                        <g:if test="${((line?.item?.percentage ?: BigDecimal.ZERO).compareTo(BigDecimal.ZERO) <= 0) && (! line?.dueInvoiceLine())}">
                            <g:formatNumber number="${line?.quantity}" formatName="decimal.format"/>
                        </g:if>
                        </td>
                        <td class="${line.id==0 ? 'hide' : ''} innerContent">
                            <g:if test="${! line?.dueInvoiceLine()}">
                                <g:formatNumber number="${line?.price ?: BigDecimal.ZERO}" type="currency" currencySymbol="${currency?.symbol}" maxFractionDigits="4"/>
                            </g:if>
                        </td>
                        <td class="${line.id==0 ? 'hide' : ''} innerContent">
                            <g:formatNumber number="${line?.amount ?: BigDecimal.ZERO}" type="currency" currencySymbol="${currency?.symbol}" maxFractionDigits="4"/>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
 

    <div class="btn-box">
        <div class="row">
        <g:if test="${selected.isReview == 0}">
                <a href="${createLink (controller: 'payment', action: 'edit', params: [userId: user?.id, invoiceId: selected.id])}" class="submit payment">
                    <span><g:message code="button.invoice.pay"/></span>
                </a>

            <a href="${createLink (action: 'downloadPdf', id: selected.id)}" class="submit save">
                <span><g:message code="button.invoice.downloadPdf"/></span>
            </a>
         </g:if>
        </div>

        <div class="row">
            <g:if test="${selected.isReview == 0}">
                <sec:access url="/invoice/email">
                    <a href="${createLink(action: 'email', id: selected.id)}" class="submit email">
                        <span><g:message code="button.invoice.sendEmail"/></span>
                    </a>
                </sec:access>
            </g:if>
        </div>
    </div>

    <!-- payments -->
    <div class="heading">
        <strong><g:message code="invoice.label.payment.refunds"/></strong>
    </div>

    <div class="box">
        <div class="sub-box">
            <g:if test="${selected.paymentMap}">
                <g:hiddenField name="unlink_payment_id" value="-1"/>
                <table class="innerTable" >
                    <thead class="innerHeader">
                    <tr>
                        <th><g:message code="label.gui.payment.id"/></th>
                        <th><g:message code="label.gui.date"/></th>
                        <th><g:message code="label.gui.payment.refunds"/></th>
                        <th><g:message code="label.gui.amountPaid"/></th>
                        <th><g:message code="label.gui.method"/></th>
                        <th><g:message code="label.gui.result"/></th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:each var="paymentInvoice" in="${selected.paymentMap}" status="idx">
                        <tr>
                            <td class="innerContent">
                                <sec:access url="/payment/show">
                                    <g:remoteLink breadcrumb="id" controller="payment" action="show" id="${paymentInvoice.payment.id}" params="['template': 'show']" before="register(this);" onSuccess="render(data, next);">
                                        ${paymentInvoice.payment.id}
                                    </g:remoteLink>
                                </sec:access>
                                <sec:noAccess url="/payment/show">
                                    ${paymentInvoice.payment.id}
                                </sec:noAccess>
                            </td>
                            <td class="innerContent">
                                <g:formatDate date="${paymentInvoice.payment.paymentDate}" formatName="date.pretty.format"/>
                            </td>
                            <td class="innerContent">
                                ${paymentInvoice.payment.isRefund? "R":"P"}
                            </td>
                            <td class="innerContent">
                                <g:formatNumber number="${new BigDecimal(paymentInvoice.amount ?: 0)}" type="currency" currencySymbol="${currency?.symbol}"/>
                            </td>
                            <td class="innerContent">
                                ${paymentInvoice.payment.paymentMethod.getDescription(session['language_id'])}
                            </td>
                            <td class="innerContent">
                                ${paymentInvoice.payment.paymentResult.getDescription(session['language_id'])}
                            </td>
                            <td class="innerContent">
                                <sec:access url="/invoice/unlink">
                                    <a onclick="setUnlinkPaymentId(${selected.id}, ${paymentInvoice.payment.id});">
                                        <span><g:message code="invoice.prompt.unlink.payment"/></span>
                                    </a>
                                </sec:access>
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </g:if>
            <g:else>
                <em><g:message code="invoice.prompt.no.payments.refunds"/></em>
            </g:else>
        </div>
    </div>

    <!-- Invoice Notes -->
    <g:if test="${selected.customerNotes}">
        <div class="heading">
            <strong><g:message code="invoice.label.note"/></strong>
        </div>
        <div class="box">
           <div class="sub-box"><p>${selected.customerNotes}</p></div>
        </div>
    </g:if>

    <div class="btn-box">
            <g:preferenceIsNullOrEquals preferenceId="${ServerConstants.PREFERENCE_INVOICE_DELETE}" value="1">
                <g:if test="${selected.id && selected.isReview == 0}">
                    <a onclick="showConfirm('delete-'+${selected.id});" class="submit delete">
                        <span><g:message code="button.delete.invoice"/></span>
                    </a>
                </g:if>
            </g:preferenceIsNullOrEquals>
    </div>
</div>

<script type="text/javascript">
    function setUnlinkPaymentId(invId, pymId) {
        $('#unlink_payment_id').val(pymId);
        showConfirm("unlink-" + invId);
        return true;
    }
    function setPaymentId() {
        $('#confirm-command-form-unlink-${selected.id} [name=paymentId]').val($('#unlink_payment_id').val());
    }
</script>

<g:render template="/confirm"
          model="[message: 'invoice.prompt.confirm.remove.payment.link',
                  controller: 'invoice',
                  action: 'unlink',
                  id: selected.id,
                  formParams: [ 'paymentId': '-1' ],
                  onYes: 'setPaymentId()',
                 ]"/>

<g:render template="/confirm"
          model="[message: 'invoice.prompt.are.you.sure',
                  controller: 'invoice',
                  action: 'delete',
                  id: selected.id,
                 ]"/>
