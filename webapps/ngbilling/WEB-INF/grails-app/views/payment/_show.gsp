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

<%@ page import="com.sapienter.jbilling.common.CommonConstants; org.apache.commons.lang.StringEscapeUtils; com.sapienter.jbilling.server.user.contact.db.ContactDTO" %>

<%--
  Shows details of a selected payment.

  @author Brian Cowdery
  @since 04-Jan-2011
--%>

<g:set var="customer" value="${selected.baseUser.customer}"/>
<g:set var="contact" value="${ContactDTO.findByUserId(selected.baseUser.id)}"/>

<div class="column-hold">
    <div class="heading">
        <strong>
            <g:if test="${selected.isRefund > 0}">
                <g:message code="payment.refund.title"/>
            </g:if>
            <g:else>
                <g:message code="payment.payment.title"/>
            </g:else>
            <em>${selected.id}</em>
            <g:if test="${selected.deleted}">
                <span style="color: #ff0000;">(<g:message code="object.deleted.title"/>)</span>
            </g:if>
        </strong>
    </div>

    <div class="box">
      <div class="sub-box">
        <!-- user details -->
        <table class="dataTable" cellspacing="0" cellpadding="0">
            <tbody>
                <g:if test="${contact?.firstName || contact?.lastName}">
                    <tr>
                        <td><g:message code="prompt.customer.name"/></td>
                        <td class="value">${contact.firstName} ${contact.lastName}</td>
                    </tr>
                </g:if>

                <g:if test="${contact?.organizationName}">
                    <tr>
                        <td><g:message code="prompt.organization.name"/></td>
                        <td class="value">${contact.organizationName}</td>
                    </tr>
                </g:if>
                <tr>
                    <td><g:message code="payment.user.id"/></td>
                    <td class="value">
                        <sec:access url="/customer/show">
                            <g:remoteLink controller="customer" action="show" id="${selected?.baseUser?.id}" before="register(this);" onSuccess="render(data, next);">
                                ${selected.baseUser.id}
                            </g:remoteLink>
                        </sec:access>
                        <sec:noAccess url="/customer/show">
                            ${selected.baseUser.id}
                        </sec:noAccess>
                    </td>
                </tr>
                <tr>
                    <td><g:message code="payment.label.user.name"/></td>
                    <td class="value">${selected.baseUser.userName}</td>
                </tr>
                <g:isRoot>
                    <tr>
                    	<td><g:message code="invoice.label.company.name"/></td>
                       	<td class="value">${selected?.baseUser.company.description}</td>
                	</tr>
                </g:isRoot>
            </tbody>
        </table>

        <!-- payment details -->
        <table class="dataTable" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td><g:message code="payment.date"/></td>
                    <td class="value"><g:formatDate date="${selected.createDatetime}" formatName="date.timeSecsAMPM.format"/></td>
                </tr>
                <tr>
                    <td><g:message code="payment.amount"/></td>
                    <td class="value"><g:formatNumber number="${selected.amount}" type="currency" currencySymbol="${selected.currencyDTO.symbol}"/></td>
                </tr>
                <tr>
                    <td><g:message code="payment.result"/></td>
                    <td class="value">${selected?.paymentResult.getDescription(session['language_id'])}</td>
                </tr>
            </tbody>
        </table>

        <hr/>

        <!-- payment balance & meta fields -->
        <table class="dataTable" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td><g:message code="payment.id"/></td>
                    <td class="value">${selected.id}</td>
                </tr>
                <g:if test="${selected?.isRefund != 0 }">
                	<tr>
                    <td><g:message code="refunded.payment.id"/></td>
                    <td class="value">
	                    <sec:access url="/payment/show">
	                        <g:remoteLink controller="payment" action="show" id="${selected?.paymentId}" before="register(this);" onSuccess="render(data, next);">
	                            ${selected?.paymentId}
	                        </g:remoteLink>
	                    </sec:access>
	                    <sec:noAccess url="/payment/show">
	                        ${selected?.paymentId}
	                    </sec:noAccess>
                    </td>
                </tr>
                </g:if>
                <tr>
                    <td><g:message code="payment.balance"/></td>
                    <td class="value">
                        <g:formatNumber number="${selected.balance}" type="currency" currencySymbol="${selected.currencyDTO.symbol}"/>

                        <sec:access url="/payment/link">
                            <g:if test="${selected.balance.compareTo(BigDecimal.ZERO) > 0 && selected.isRefund == 0 }">
                                &nbsp; - &nbsp;
                                <g:link controller="payment" action="link" id="${selected.id}">
                                    <g:message code="payment.link.invoice.pay" />
                                </g:link>
                            </g:if>
                        </sec:access>
                    </td>
                </tr>
                <tr>
                    <td><g:message code="payment.attempt"/></td>
                    <td class="value">${selected.attempt ?: 0}</td>
                </tr>
                <tr>
                    <td><g:message code="payment.is.preauth"/></td>
                    <td class="value"><em><g:formatBoolean boolean="${selected.isPreauth > 0}"/></em></td>
                </tr>

                <g:if test="${selected?.metaFields}">
                    <!-- empty spacer row -->
                    <tr>
                        <td colspan="2"><br/></td>
                    </tr>
                    <g:render template="/metaFields/metaFields" model="[metaFields: selected?.metaFields]"/>
                </g:if>
            </tbody>
        </table>

        <!-- list of linked invoices -->
        <g:if test="${selected.invoicesMap}">
            <g:hiddenField name="unlink_invoice_id" value="-1"/>
            <table cellpadding="0" cellspacing="0" class="innerTable">
                <thead class="innerHeader">
                    <tr>
                        <th><g:message code="payment.invoice.payment"/></th>
                        <th><g:message code="payment.invoice.payment.amount"/></th>
                        <th><g:message code="payment.invoice.payment.date"/></th>
                        <th><!-- action --> &nbsp;</th>
                    </tr>
                </thead>
                <tbody>
                    <g:each var="invoicePayment" in="${selected.invoicesMap}">
                    <tr>
                        <td class="innerContent">
                            <sec:access url="/invoice/show">
                                <g:remoteLink controller="invoice" action="show" id="${invoicePayment.invoiceEntity.id}" before="register(this);" onSuccess="render(data, next);">
                                    <g:message code="payment.link.invoice" args="[StringEscapeUtils.escapeHtml(invoicePayment?.invoiceEntity?.number)]"/>
                                </g:remoteLink>
                            </sec:access>
                            <sec:noAccess url="/invoice/show">
                                <g:message code="payment.link.invoice" args="[invoicePayment.invoiceEntity.number]"/>
                            </sec:noAccess>
                        </td>
                        <td class="innerContent">
                            <g:formatNumber number="${invoicePayment.amount}" type="currency" currencySymbol="${selected.currencyDTO.symbol}"/>
                        </td>
                        <td class="innerContent">
                            <g:formatDate date="${invoicePayment.createDatetime}"/>
                        </td>
                        <td class="innerContent">
                            <sec:access url="/payment/unlink">
                                <a onclick="setUnlinkInvoiceId(${selected.id}, ${invoicePayment.invoiceEntity.id});">
                                    <span><g:message code="payment.link.unlink"/></span>
                                </a>
                            </sec:access>
                        </td>
                    </tr>
                    </g:each>
                </tbody>
            </table>
        </g:if>
     </div>
    </div>

    <!-- payment notes -->
    <g:if test="${selected.paymentNotes}">
        <div class="heading">
            <strong><g:message code="payment.notes"/></strong>
        </div>
        <div class="box">
            <div class="sub-box"><p>${selected.paymentNotes}</p></div>
        </div>
    </g:if>

    <!-- payment authorization -->
    <g:if test="${selected.paymentAuthorizations}">
        <g:set var="authorization" value="${selected.paymentAuthorizations.sort { it.createDate }?.first()}"/>

        <div class="heading">
            <strong><g:message code="payment.authorization.title" /></strong>
        </div>
        <div class="box">
            <div class="sub-box">
			  <table class="dataTable" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td><g:message code="payment.authorization.date" /></td>
                        <td class="value"><g:formatDate date="${authorization.createDate}"/></td>
                    </tr>
                    <tr>
                        <td><g:message code="payment.processor" /></td>
                        <td class="value">${authorization.processor}</td>
                    </tr>
                    <g:if test="${authorization.code1}">
                        <tr>
                            <td><g:message code="payment.code.1" /></td>
                            <td class="value">${authorization.code1}</td>
                        </tr>
                    </g:if>
                    <g:if test="${authorization.code2}">
                        <tr>
                            <td><g:message code="payment.code.2" /></td>
                            <td class="value">${authorization.code2}</td>
                        </tr>
                    </g:if>
                    <g:if test="${authorization.code3}">
                        <tr>
                            <td><g:message code="payment.code.3" /></td>
                            <td class="value">${authorization.code3}</td>
                        </tr>
                    </g:if>
                    <tr>
                        <td><g:message code="payment.approval.code" /></td>
                        <td class="value">${authorization.approvalCode}</td>
                    </tr>
                    <g:if test="${authorization.avs}">
                        <tr>
                            <td><g:message code="payment.avs.code" /></td>
                            <td class="value">${authorization.avs}</td>
                        </tr>
                    </g:if>
                    <g:if test="${authorization.cardCode}">
                        <tr>
                            <td><g:message code="payment.card.code" /></td>
                            <td class="value">${authorization.cardCode}</td>
                        </tr>
                    </g:if>
                    <g:if test="${authorization.md5}">
                        <tr>
                            <td><g:message code="payment.md5.sum" /></td>
                            <td class="value">${authorization.md5}</td>
                        </tr>
                    </g:if>
                    <g:if test="${authorization.transactionId}">
                        <tr>
                            <td><g:message code="payment.transaction.id" /></td>
                            <td class="value"> ${authorization.transactionId}</td>
                        </tr>
                    </g:if>
                    <tr>
                        <td><g:message code="payment.response.message" /></td>
                        <td class="value">${authorization.responseMessage}</td>
                    </tr>
                </tbody>
            </table>
            </div>
        </div>
    </g:if>


    <!-- credit card details -->
    <g:if test="${selected?.paymentInstrumentsInfo.size()>0}">

        <div class="heading">
            <strong><g:message code="payment.instrument.list"/></strong>
        </div>
        <div class="box">
        	 <g:each var="instrumentInfo" in="${selected.paymentInstrumentsInfo}">
        	 	<g:set var="instrument" value="${instrumentInfo?.paymentInformation}"/>
		            <div class="sub-box">
		                <table class="dataTable" cellspacing="0" cellpadding="0">
		                    <tbody>
		                        <tr>
		                            <td><g:message code="payment.instrument.name"/></td>
		                            <td class="value">${instrument.paymentMethodType.methodName}</td>
		                        </tr>
		                        <tr>
		                            <td>
		                            	 <g:render template="/metaFields/metaFields" model="[metaFields: instrument.metaFields]"/>
		                            </td>
		                        </tr>
		                    </tbody>
		                </table>
		            </div>
		     </g:each>
        </div>
    </g:if>

    <div class="btn-box">
    <g:if test="${!selected.deleted}">
        <!-- edit or delete unlinked payments -->
        <div class="row">
            <g:if test="${!selected.invoicesMap}">
                    <g:if test="${selected?.paymentResult.id == CommonConstants.RESULT_ENTERED}">
                        <g:link action="edit" id="${selected.id}" class="submit edit"><span><g:message code="button.edit"/></span></g:link>
                    </g:if>
				<g:if test="${selected.isRefund == 0}">
	                   <a onclick="showConfirm('delete-${selected.id}');" class="submit delete"><span><g:message code="button.delete"/></span></a>
             	</g:if>
            </g:if>
            <g:else>
                <em><g:message code="payment.cant.edit.linked"/></em>
            </g:else>
        </div>
        
        <div class="row">
            <g:link action="emailNotify" id="${selected.id}" class="submit email">
                <span><g:message code="button.payment.notify"/></span>
            </g:link>
        </div>
	</g:if>
    </div>
</div>
<script type="text/javascript">
    function setUnlinkInvoiceId(paymentId, invoiceId) {
        $('#unlink_invoice_id').val(invoiceId);
        showConfirm("unlink-" + paymentId);
        return true;
    }
    function setInvoiceId() {
        $('#confirm-command-form-unlink-${selected.id} [name=invoiceId]').val($('#unlink_invoice_id').val());
    }
</script>

<g:render template="/confirm"
          model="[message: 'payment.prompt.confirm.remove.payment.link',
                  controller: 'payment',
                  action: 'unlink',
                  id: selected.id,
                  formParams: [ 'invoiceId': '-1' ],
                  onYes: 'setInvoiceId()',
          ]"/>

<g:render template="/confirm"
          model="[message: 'payment.delete.confirm',
                  controller: 'payment',
                  action: 'delete',
                  id: selected.id,
          ]"/>

