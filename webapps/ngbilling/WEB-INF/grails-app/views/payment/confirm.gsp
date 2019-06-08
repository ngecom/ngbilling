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

<%@ page import="com.sapienter.jbilling.server.metafields.DataType; com.sapienter.jbilling.common.CommonConstants" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
</head>
<body>
<div class="form-edit">

    <g:set var="isNew" value="${!payment || !payment?.id || payment?.id == 0}"/>

    <div class="heading">
        <strong>
            <g:if test="${payment.isRefund > 0}">
                <g:message code="payment.confirm.refund.title"/>
            </g:if>
            <g:else>
                <g:message code="payment.confirm.payment.title"/>
            </g:else>
        </strong>
    </div>

    <div class="form-hold">
        <g:form name="payment-edit-form" action="save">
            <fieldset>

                <!-- invoices to pay -->
                <g:if test="${invoiceId && invoices}">
                    <table cellpadding="0" cellspacing="0" class="innerTable">
                        <thead class="innerHeader">
                        <tr>
                            <th><g:message code="invoice.label.number"/></th>
                            <th><g:message code="invoice.label.payment.attempts"/></th>
                            <th><g:message code="invoice.label.total"/></th>
                            <th><g:message code="invoice.label.balance"/></th>
                            <th><g:message code="invoice.label.duedate"/></th>
                            <th><!-- action --> &nbsp;</th>
                        </tr>
                        </thead>
                        <tbody>
                        <g:each var="invoice" in="${invoices}">
                            <g:if test="${invoiceId.toInteger() == invoice.id}">
                                <g:set var="currency" value="${currencies.find { it.id == invoice.currencyId }}"/>

                                <tr>
                                    <td class="innerContent">
                                        <g:message code= "payment.link.invoice" args="[invoice.number]"/>
                                        <g:hiddenField name="invoiceId" value="${invoice.id}"/>
                                    </td>
                                    <td class="innerContent">
                                        ${invoice.paymentAttempts}
                                    </td>
                                    <td class="innerContent">
                                        <g:formatNumber number="${invoice.getTotalAsDecimal()}" type="currency" currencySymbol="${currency?.symbol}"/>
                                    </td>
                                    <td class="innerContent">
                                        <g:formatNumber number="${invoice.getBalanceAsDecimal()}" type="currency" currencySymbol="${currency?.symbol}"/>
                                    </td>
                                    <td class="innerContent">
                                        <g:formatDate date="${invoice.dueDate}"/>
                                    </td>
                                    <td class="innerContent">
                                        <g:link controller="invoice" action="list" id="${invoice.id}">
                                            <g:message code= "payment.link.view.invoice" args="[invoice.number]"/>
                                        </g:link>
                                    </td>
                                </tr>
                            </g:if>
                        </g:each>
                        </tbody>
                    </table>

                    <!-- spacer -->
                    <div>
                        <br/>&nbsp;
                    </div>
                </g:if>

                <!-- payment details  -->
                <div class="form-columns">
                    <div class="column">
                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="payment.id"/></content>

                            <g:if test="${!isNew}"><span>${payment.id}</span></g:if>
                            <g:else><span><em><g:message code="prompt.id.new"/></em></span></g:else>

                            <g:hiddenField name="payment.id" value="${payment?.id}"/>
                        </g:applyLayout>

                        <g:if test="${!isNew}">
                            <g:applyLayout name="form/text">
                                <content tag="label"><g:message code="payment.attempt"/></content>
                                <span>${payment.attempt}</span>
                                <g:hiddenField name="payment.attempt" value="${payment?.attempt}"/>
                            </g:applyLayout>
                        </g:if>

                        <g:set var="currency" value="${currencies.find { it.id == payment?.currencyId }}"/>
                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="prompt.user.currency"/></content>
                            <span>${currency?.getDescription(session['language_id']) ?: payment.currencyId}</span>
                            <g:hiddenField name="payment.currencyId" value="${payment?.currencyId}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="payment.amount"/></content>
                            <span><g:formatNumber number="${payment.amount}" formatName="money.format"/></span>
                            <g:hiddenField class="field" name="payment.amountAsDecimal" value="${formatNumber(number: payment?.amount, formatName: 'money.format')}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="payment.date"/></content>
                            <g:set var="paymentDate" value="${payment?.paymentDate ?: new Date()}"/>
                            <span><g:formatDate date="${paymentDate}"/></span>
                            <g:hiddenField class="field" name="payment.paymentDate" value="${formatDate(date: paymentDate)}"/>
                        </g:applyLayout>

                        <!-- meta fields -->
                        <g:each var="metaField" in="${availableFields?.sort{ it.displayOrder }}">
                            <g:if test="${!metaField.disabled}">
                                <g:set var="paymentMetaField" value="${payment?.metaFields?.find{ it.fieldName == metaField.name }}"/>
                                <g:set var="fieldValue" value="${paymentMetaField?.getValue()}"/>

                                <g:if test="${metaField.getDataType() == DataType.DATE}">
                                    <g:applyLayout name="form/text">
                                        <content tag="label">${metaField.name}</content>
                                        <span><g:formatDate date="${fieldValue}"/></span>
                                        <g:hiddenField class="field" name="metaField_${metaField.id}.value" value="${formatDate(date: fieldValue)}"/>
                                    </g:applyLayout>
                                </g:if>
                                <g:elseif test="${metaField.getDataType() == DataType.LIST}">
                                    <g:applyLayout name="form/text">
                                        <content tag="label">${metaField.name}</content>
                                        <span>${fieldValue?.join(', ')}</span>
                                        <g:hiddenField class="field" name="metaField_${metaField.id}.value" value="${fieldValue}"/>
                                    </g:applyLayout>
                                </g:elseif>
                                <g:else>
                                    <g:applyLayout name="form/text">
                                        <content tag="label">${metaField.name}</content>
                                        <span>${fieldValue}</span>
                                        <g:hiddenField class="field" name="metaField_${metaField.id}.value" value="${fieldValue}"/>
                                    </g:applyLayout>
                                </g:else>
                            </g:if>

                        </g:each>

                    </div>

                    <div class="column">
                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="payment.user.id"/></content>
                            <span><g:link controller="customer" action="list" id="${user.userId}">${user.userId}</g:link></span>
                            <g:hiddenField name="payment.userId" value="${user.userId}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="prompt.login.name"/></content>
                            <span>${user.userName}</span>
                        </g:applyLayout>

                        <g:if test="${user.contact?.firstName || user.contact?.lastName}">
                            <g:applyLayout name="form/text">
                                <content tag="label"><g:message code="prompt.customer.name"/></content>
                                <em>${user.contact.firstName} ${user.contact.lastName}</em>
                            </g:applyLayout>
                        </g:if>

                        <g:if test="${user.contact?.organizationName}">
                            <g:applyLayout name="form/text">
                                <content tag="label"><g:message code="prompt.organization.name"/></content>
                                <em>${user.contact.organizationName}</em>
                            </g:applyLayout>
                        </g:if>


                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="payment.is.refund"/></content>
                            <g:formatBoolean boolean="${payment?.isRefund > 0}"/>
                            <g:hiddenField name="isRefund" value="${payment?.isRefund}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="payment.label.process.realtime"/></content>
                            <g:formatBoolean boolean="${processNow}"/>
                            <g:hiddenField name="processNow" value="${processNow}"/>
                        </g:applyLayout>

                        %{--show linked payment ID if present--}%
                        <g:if test="${refundPaymentId}">
                            <g:applyLayout name="form/text">
                                <content tag="label"><g:message code="prompt.linked.payment"/></content>
                                <em>${refundPaymentId} </em>
                                <g:hiddenField name="payment_id" value="${refundPaymentId}"/>
                            </g:applyLayout>
                        </g:if>

                    </div>
                </div>
				
				<!-- spacer -->
                <div>
                    <br/>&nbsp;
                </div>
				<!-- Payment Methods -->
				<div id="payment-methods" class="box-cards box-cards-open" >
                   	    <div class="box-cards-title">
                       	    <a class="btn-open"><span>
                           	    <label><g:message code="promt.payment.methods"/></label>
                           	</span></a>
                       	</div>
                       	<div id= "payment-method-main" class="box-card-hold">
							<g:render template="/customer/paymentMethods" model="[ paymentMethods: paymentMethods, paymentInstruments : paymentInstruments ]"/>
						</div>
           		</div>
           		
                <!-- box text -->
                <div class="box-text">
                    <label for="payment.paymentNotes"><g:message code="payment.notes"/></label>
                    <g:textArea name="payment.paymentNotes" value="${payment?.paymentNotes}" rows="5" cols="60" readonly="true"/>
                </div>

                <div class="buttons">
                    <ul>
                        <li>
                            <a onclick="$('#payment-edit-form').submit()" class="submit payment">
                                <g:if test="${isNew}"><span><g:message code="button.make.payment"/></span></g:if>
                                <g:if test="${!isNew}"><span><g:message code="button.save"/></span></g:if>
                            </a>
                        </li>
                        <li>
                            <g:link action="list" class="submit cancel"><span><g:message code="button.cancel"/></span></g:link>
                        </li>
                    </ul>
                </div>

            </fieldset>
        </g:form>
    </div>
	<script type="text/javascript">
    	$(document).ready(function() {
    		disablePaymentMethodFields();
    	});
    	
    	function disablePaymentMethodFields(){
			var inputEles = $("#payment-method-main").find("input");
			for(var j=0;j<inputEles.length;j++) {
				inputEles[j].setAttribute("disabled", true);
			}
			
			var selectEles = $("#payment-method-main").find("select");
			for(var j=0;j<selectEles.length;j++) {
				selectEles[j].setAttribute("disabled", true);
			}

			$("#payment-method-add").hide();
		}
    </script>
</div>
</body>
</html>