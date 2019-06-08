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

<%@ page import="com.sapienter.jbilling.common.CommonConstants; com.sapienter.jbilling.server.metafields.db.MetaField; com.sapienter.jbilling.server.user.db.UserDTO; com.sapienter.jbilling.server.user.db.AccountInformationTypeDTO; com.sapienter.jbilling.server.user.db.AccountTypeDTO; com.sapienter.jbilling.server.invoice.InvoiceLineComparator; com.sapienter.jbilling.server.metafields.DataType; com.sapienter.jbilling.server.process.db.PeriodUnitDTO;	com.sapienter.jbilling.server.customer.CustomerBL; com.sapienter.jbilling.server.user.UserBL; com.sapienter.jbilling.server.util.Util; com.sapienter.jbilling.server.user.contact.db.ContactDTO"%>

<html>
<head>
    <meta name="layout" content="main" />
</head>
<body>
<div class="form-edit">

    <g:set var="customer" value="${user.customer}"/>

    <div class="heading">
        <strong>
            ${user.userName}
            <g:if test="${user.deleted}">
                <span style="color: #ff0000;">(<g:message code="object.deleted.title"/>)</span>
            </g:if>
        </strong>
    </div>

    <div class="form-hold">
        <fieldset>
            <!-- user details -->
            <div class="form-columns">
                <div class="column">
                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="customer.detail.user.username"/></content>
                        <span><g:link controller="customer" action="list" id="${user.id}">${user.userName}</g:link></span>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label">Last Login</content>
                        <span><g:formatDate date="${user.lastLoginDate}" formatName="date.pretty.format"/></span>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="customer.detail.user.status"/></content>
                        <span>${user.userStatus.getDescription(session['language_id'])}</span>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="customer.detail.user.subscriber.status"/></content>
                        <span>${user.subscriberStatus.getDescription(session['language_id'])}</span>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="prompt.user.language"/></content>
                        <span>${user.language.getDescription()}</span>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="prompt.user.currency"/></content>
                        <span>${user.currency.getDescription(session['language_id'])}</span>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="prompt.exclude.ageing"/></content>
                        <span><g:formatBoolean boolean="${customer?.excludeAging > 0}"/></span>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="prompt.invoice.design"/></content>
                        <span>${customer?.invoiceDesign}</span>
                    </g:applyLayout>
                </div>

                <div class="column">
                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="customer.detail.user.user.id"/></content>
                        <span><g:link controller="customer" action="list" id="${user.id}">${user.id}</g:link></span>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="customer.detail.user.type"/></content>
                        <g:set var="mainRole" value="${user.roles.asList()?.min{ it.id }}"/>
                        <span title="${mainRole?.getDescription(session['language_id'])}">${mainRole?.getTitle(session['language_id'])}</span>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="customer.detail.user.account.type"/></content>
                        <g:set var="accountType" value="${user?.customer?.accountType}"/>
                        <g:if test="${accountType?.id}">
                            <span>${accountType?.getDescription(session['language_id'])}</span>
                        </g:if><g:else>-</g:else>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="prompt.partner.id"/></content>
                        <span>${user.partner?.id}</span>
                    </g:applyLayout>


                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="prompt.credit.limit"/></content>
                        <span><g:formatNumber number="${customer?.creditLimit}" formatName="money.format"/></span>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="prompt.auto.recharge"/></content>
                        <span><g:formatNumber number="${customer?.autoRecharge}" formatName="money.format"/></span>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="prompt.dynamic.balance"/></content>
                        <span><g:formatNumber number="${customer?.dynamicBalance}" formatName="money.format"/></span>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="prompt.invoice.delivery.method"/></content>
                        <span><g:message code="customer.invoice.delivery.method.${customer?.invoiceDeliveryMethod?.id ?: 0}"/></span>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="prompt.due.date.override"/></content>
                        <g:if test="${customer?.dueDateValue}">
                            <g:set var="periodUnit" value="${PeriodUnitDTO.get(customer.dueDateUnitId)}"/>
                            <span>${customer?.dueDateValue} ${periodUnit.getDescription(session['language_id'])}</span>
                        </g:if>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="customer.detail.user.next.invoice.date"/></content>
                        <g:set var="nextInvoiceDate" value="${new UserBL(user.id).getEntity().getCustomer().getNextInvoiceDate()}"/>

                        <g:if test="${nextInvoiceDate}">
                            <span><g:formatDate date="${nextInvoiceDate}" formatName="date.pretty.format"/></span>
                        </g:if>
                        <g:else>
                            <g:message code="prompt.no.active.orders"/>
                        </g:else>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="customer.detail.payment.lifetime.revenue"/></content>
                        <span><g:formatNumber number="${revenue}" type="currency" currencySymbol="${user.currency.symbol}"/></span>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="customer.detail.payment.amount.owed"/></content>
                        <span><g:formatNumber number="${UserBL.getBalance(user.id)}" type="currency" currencySymbol="${user.currency.symbol}"/></span>
                    </g:applyLayout>

                    <g:if test="${metaFields}">
                        <!-- meta fields -->
                        <g:each var="metaFieldValue" in="${metaFields?.sort{ it.field.displayOrder }}">
                            <%
                                def display = true
                                for(AccountInformationTypeDTO ait : accountInformationTypes){
                                   for(MetaField field : ait.metaFields){
                                       if(field.id == metaFieldValue.field.id){
                                           display = false
                                       }
                                   }
                                }
                            %>
                            <g:if test="${display}">
                                <g:render template="/metaFields/displayMetaField"
                                          model="[metaField : metaFieldValue]"/>
                            </g:if>
                        </g:each>
                    </g:if>
                </div>
            </div>

			<g:if test="${!user.deleted}">
            <sec:access url="/blacklist/user">
                <div style="margin: 20px 0;">
                    <div class="btn-row">
                        <g:link controller="blacklist" action="user" id="${user.id}" class="submit add"><span><g:message code="customer.blacklist.button"/></span></g:link>
                    </div>
                </div>
            </sec:access>
            </g:if>

            <!-- separator -->
            <div class="form-columns">
                <hr/>
            </div>

            <!-- account hierarchy -->
            <div class="form-columns">
                <div class="column">
                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="prompt.parent.id"/></content>
                        <span>
                            <g:link action="inspect" id="${customer?.parent?.baseUser?.id}">${customer?.parent?.baseUser?.id}</g:link>
                        </span>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="prompt.is.parent"/></content>
                        <span><g:formatBoolean boolean="${customer?.isParent > 0}"/></span>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="prompt.invoice.if.child"/></content>
                        <span><g:formatBoolean boolean="${customer?.invoiceChild > 0}"/></span>
                    </g:applyLayout>

                    <g:if test="${customer?.parent}">
                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="customer.invoice.if.child.label"/></content>
                            <span>
                                    <g:if test="${customer.invoiceChild > 0}">
                                        <g:message code="customer.invoice.if.child.true"/>
                                    </g:if>
                                    <g:else>
                                        <g:set var="parent" value="${new CustomerBL(customer.id).getInvoicableParent()}"/>
                                        <g:link action="inspect" id="${customer.parent.baseUser.id}">
                                            <g:message code="customer.invoice.if.child.false" args="[ parent.baseUser.id ]"/>
                                        </g:link>
                                    </g:else>
                            </span>
                        </g:applyLayout>
                    </g:if>
                </div>
                <div class="column">
                    <!-- list of direct sub-accounts -->
                    <g:each var="account" in="${customer?.children}">
                        <g:applyLayout name="form/text">
	                        <g:if test="${subscriptionAccounts.contains(account.baseUser.id)}">
	                        	<content tag="label"><g:message code="customer.subaccount.internal.title" args="[ account.baseUser.id ]"/></content>
	                        </g:if>
	                        <g:else>
	                        	<content tag="label"><g:message code="customer.subaccount.title" args="[ account.baseUser.id ]"/></content>
	                        </g:else>
	                            
                            <span>
                                <g:link action="inspect" id="${account.baseUser.id}">${account.baseUser.userName}</g:link>
                            </span>
                        </g:applyLayout>
                    </g:each>
                </div>
            </div>

            <!-- buttons -->
            <div style="margin: 20px 0;">
                <div class="btn-row">
                    <g:link controller="auditLog" action="user" id="${user.id}" class="submit show"><span><g:message code="customer.view.audit.log.button"/></span></g:link>

                    <sec:access url="/invoice/user">
                        <g:link controller="invoice" action="user" id="${user.id}" class="submit show"><span><g:message code="customer.view.invoices.button"/></span></g:link>
                    </sec:access>

                    <sec:access url="/payment/user">
                        <g:link controller="payment" action="user" id="${user.id}" class="submit payment"><span><g:message code="customer.view.payments.button"/></span></g:link>
                    </sec:access>

                    <sec:access url="/order/user">
                        <g:link controller="order" action="user" id="${user.id}" class="submit order"><span><g:message code="customer.view.orders.button"/></span></g:link>
                    </sec:access>
                </div>
                <div class="btn-row">
                <g:if test="${!user.deleted}">
                        <g:link controller="customer" action="edit" id="${user.id}" class="submit edit"><span><g:message code="customer.edit.customer.button"/></span></g:link>

                        <g:link controller="payment" action="edit" params="[userId: user.id]" class="submit payment"><span><g:message code="button.make.payment"/></span></g:link>

                        <g:link controller="orderBuilder" action="edit" params="[userId: user.id]" class="submit order"><span><g:message code="button.create.order"/></span></g:link>
				</g:if>
                </div>
            </div>

            <g:if test="${accountInformationTypes && accountInformationTypes.size()>0}">
                <g:each in="${accountInformationTypes}" var="ait">
                    <div id="ait-${ait.id}" class="box-cards box-cards-open" >
                        <div class="box-cards-title">
                            <a class="btn-open"><span>
                                ${ait.name}
                            </span></a>
                        </div>
                        <div class="box-card-hold">
                            <div class="form-columns">
                                <%
                                    def aitMetaFields =  ait?.metaFields?.sort { it.displayOrder }
                                    def leftColumnFields = []
                                    def rightColumnFields = []
                                    aitMetaFields.eachWithIndex { field, index ->
                                        def fieldValue = metaFields.find {
                                            mfv -> mfv.field.id == field.id }

                                        if(fieldValue){
                                            if(index > aitMetaFields.size()/2){
                                                rightColumnFields << fieldValue
                                            } else {
                                                leftColumnFields << fieldValue
                                            }
                                        }
                                    }
                                %>
                                <div class="column">
                                    <g:if test="${leftColumnFields.size() > 0}">
                                        <g:each in="${leftColumnFields}" var="varMetaField" >
                                        <g:render template="/metaFields/displayMetaField"
                                                  model="[metaField : varMetaField]"/>
                                        </g:each>
                                    </g:if>
                                </div>
                                <div class="column">
                                    <g:if test="${rightColumnFields.size() > 0}">
                                        <g:each in="${rightColumnFields}" var="varMetaField" >
                                        <g:render template="/metaFields/displayMetaField"
                                                      model="[metaField : varMetaField]"/>
                                        </g:each>
                                    </g:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </g:each>
            </g:if>

            <!-- blacklist matches -->
            <g:if test="${blacklistMatches}">
                <div id="blacklist" class="box-cards">
                    <div class="box-cards-title">
                        <a class="btn-open"><span><g:message code="customer.inspect.blacklist.title"/></span></a>
                    </div>
                    <div class="box-card-hold">
                        <div class="form-columns">
                            <table cellpadding="0" cellspacing="0" class="dataTable">
                                <tbody>

                                    <g:each var="match" status="i" in="${blacklistMatches}">
                                        <tr>
                                            <td class="value">
                                                ${match}
                                            </td>
                                        </tr>
                                    </g:each>

                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </g:if>

            <!-- last payment -->
            <g:if test="${payment}">
                <div id="payment" class="box-cards">
                    <div class="box-cards-title">
                        <a class="btn-open"><span><g:message code="customer.inspect.last.payment.title"/></span></a>
                    </div>
                    <div class="box-card-hold">
                        <div class="form-columns">
                            <g:render template="payment" model="[payment: payment]"/>
                        </div>
                    </div>
                </div>
            </g:if>

            <!-- last invoice -->
            <g:if test="${invoice}">
                <div id="invoice" class="box-cards">
                    <div class="box-cards-title">
                        <a class="btn-open"><span><g:message code="customer.inspect.last.invoice.title"/></span></a>
                    </div>
                    <div class="box-card-hold">

                        <div class="form-columns">
                            <table cellpadding="0" cellspacing="0" class="dataTable">
                                <tbody>
                                    <tr>
                                        <td><g:message code="invoice.label.id"/></td>
                                        <td class="value"><g:link controller="invoice" action="list" id="${invoice.id}">${invoice.id}</g:link></td>

                                        <td><g:message code="invoice.label.date"/></td>
                                        <td class="value"><g:formatDate date="${invoice.createDatetime}" formatName="date.pretty.format"/></td>

                                        <td><g:message code="invoice.amount.date"/></td>
                                        <td class="value"><g:formatNumber number="${invoice.total}" type="currency" currencySymbol="${invoice.currency.symbol}"/></td>

                                        <td><g:message code="invoice.label.delegation"/></td>
                                        <td class="value">
                                            <g:each var="delegated" in="${invoice.invoices}" status="i">
                                                <g:link controller="invoice" action="list" id="${delegated.id}">${delegated.id}</g:link>
                                                <g:if test="${i < invoice.invoices.size()-1}">, </g:if>
                                            </g:each>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td><g:message code="invoice.label.status"/></td>
                                        <td class="value">
                                            <g:if test="${invoice.invoiceStatus.id == CommonConstants.INVOICE_STATUS_UNPAID}">
                                                <g:link controller="payment" action="edit" params="[userId: user.id, invoiceId: invoice.id]" title="${message(code: 'invoice.pay.link')}">
                                                    ${invoice.invoiceStatus.getDescription(session['language_id'])}
                                                </g:link>
                                            </g:if>
                                            <g:else>
                                                ${invoice.invoiceStatus.getDescription(session['language_id'])}
                                            </g:else>
                                        </td>

                                        <td><g:message code="invoice.label.duedate"/></td>
                                        <td class="value"><g:formatDate date="${invoice.dueDate}" formatName="date.pretty.format"/></td>

                                        <td><g:message code="invoice.label.balance"/></td>
                                        <td class="value"><g:formatNumber number="${invoice.balance}" type="currency" currencySymbol="${invoice.currency.symbol}"/></td>

                                        <td><g:message code="invoice.label.orders"/></td>
                                        <td class="value">
                                            <g:each var="process" in="${invoice.orderProcesses}" status="i">
                                                <g:link controller="order" action="list" id="${process.purchaseOrder.id}">${process.purchaseOrder.id}</g:link>
                                                <g:if test="${i < invoice.orderProcesses.size()-1}">, </g:if>
                                            </g:each>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td><g:message code="invoice.label.payment.attempts"/></td>
                                        <td class="value">${invoice.paymentAttempts}</td>

                                        <td><g:message code="invoice.label.gen.date"/></td>
                                        <td class="value"><g:formatDate date="${invoice.createTimestamp}" formatName="date.pretty.format"/></td>

                                        <td><g:message code="invoice.label.carried.bal"/></td>
                                        <td class="value"><g:formatNumber number="${invoice.carriedBalance}" type="currency" currencySymbol="${invoice.currency.symbol}"/></td>

                                        <!-- spacer -->
                                        <td></td><td></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <table cellpadding="0" cellspacing="0" class="innerTable">
                            <thead class="innerHeader">
                            <tr>
                                <th><g:message code="label.gui.description"/></th>
                                <th><g:message code="label.gui.quantity"/></th>
                                <th><g:message code="label.gui.price"/></th>
                                <th><g:message code="label.gui.amount"/></th>
                            </tr>
                            </thead>
                            <tbody>
                                <%
                                    def invoiceLines = new ArrayList(invoice.invoiceLines)
                                    Collections.sort(invoiceLines, new InvoiceLineComparator())
                                %>
                                <g:each var="invoiceLine" in="${invoiceLines}">
                                    <tr>
                                        <td class="innerContent">
                                            ${invoiceLine.description}
                                        </td>

                                        <td class="innerContent">
                                            <g:formatNumber number="${invoiceLine.quantity}"/>
                                        </td>
                                        <td class="innerContent">
                                            <g:formatNumber number="${invoiceLine.price}" type="currency" currencySymbol="${invoice.currency.symbol}"/>
                                        </td>
                                        <td class="innerContent">
                                            <g:formatNumber number="${invoiceLine.amount}" type="currency" currencySymbol="${invoice.currency.symbol}"/>
                                        </td>
                                    </tr>
                                </g:each>
                            </tbody>
                        </table>

                        <g:if test="${invoice.paymentMap}">
                            <div class="box-cards">
                                <div class="box-cards-title">
                                    <span><g:message code="invoice.label.payment.refunds"/></span>
                                </div>
                                <div class="box-card-hold">

                                    <g:each var="invoicePayment" in="${invoice.paymentMap}" status="i">
                                        <g:render template="payment" model="[payment: invoicePayment.payment]"/>
                                        <g:if test="${i < invoice.paymentMap.size()-1}"><hr/></g:if>
                                    </g:each>
                                </div>
                            </div>
                        </g:if>

                    </div>
                </div>
            </g:if>

            <!-- subscriptions -->
            <g:if test="${subscriptions}">
                <div id="subscriptions" class="box-cards">
                    <div class="box-cards-title">
                        <a class="btn-open"><span><g:message code="customer.inspect.subscriptions.title"/></span></a>
                    </div>
                    <div class="box-card-hold">

                        <table cellpadding="0" cellspacing="0" class="innerTable">
                            <thead class="innerHeader">
                            <tr>
                                <th><g:message code="order.label.id"/></th>
                                <th><g:message code="label.gui.description"/></th>
                                <th><g:message code="label.gui.period"/></th>
                                <th><g:message code="label.gui.quantity"/></th>
                                <th><g:message code="label.gui.price"/></th>
                                <th><g:message code="label.gui.amount"/></th>
                            </tr>
                            </thead>
                            <tbody>
                            <g:each var="order" in="${subscriptions}">
                                <g:set var="currency" value="${currencies.find { it.id == order.currencyId }}"/>

                                <g:each var="orderLine" in="${order.orderLines}">
                                    <tr>
                                        <td class="innerContent">
                                            <g:link controller="order" action="list" id="${order.id}">${order.id}</g:link>
                                        </td>
                                        <td class="innerContent">
                                            ${orderLine.description}
                                        </td>
                                        <td class="innerContent">
                                            ${order.periodStr}
                                        </td>
                                        <td class="innerContent">
                                            <g:formatNumber number="${orderLine.getQuantityAsDecimal()}" formatName="decimal.format"/>
                                        </td>
                                        <td class="innerContent">
                                            <g:formatNumber number="${orderLine.getPriceAsDecimal()}" type="currency" currencySymbol="${currency.symbol}"/>
                                        </td>
                                        <td class="innerContent">
                                            <g:formatNumber number="${orderLine.getAmountAsDecimal()}" type="currency" currencySymbol="${currency.symbol}"/>
                                        </td>
                                    </tr>
                                </g:each>
                            </g:each>
                            </tbody>
                        </table>

                    </div>
                    <div class="box-card-hold">
                        <table cellpadding="0" cellspacing="0" class="innerTable">
                            <thead class="innerHeader">
                            <tr>
                                <th><g:message code="subscription.label.id"/></th>
                                <th><g:message code="subscription.account.name"/></th>
                                <th><g:message code="label.gui.description"/></th>
                              	<th><g:message code="subscription.asset.id"/></th>
                                <th><g:message code="label.gui.period"/></th>
                                <th><g:message code="label.gui.quantity"/></th>
                                <th><g:message code="label.gui.price"/></th>
                                <th><g:message code="label.gui.amount"/></th>
                            </tr>
                            </thead>
                            <tbody>
                            <g:each var="order" in="${internalSubscriptions}">
                                <g:set var="currency" value="${currencies.find { it.id == order.currencyId }}"/>

                                <g:each var="orderLine" in="${order.orderLines}">
                                    <tr>
                                        <td class="innerContent">
                                            <g:link controller="order" action="list" id="${order.id}">${order.id}</g:link>
                                        </td>
                                        <td class="innerContent">
                                            ${UserDTO.get(order.userId).userName}
                                        </td>
                                        <td class="innerContent">
                                            ${orderLine.description}
                                        </td>
                                        <td class="innerContent">
                                        	<g:each var="asset" in="${orderLine.assetIds}">
                                        		${asset}
                                        	</g:each>
                                        </td>
                                        <td class="innerContent">
                                            ${order.periodStr}
                                        </td>
                                        <td class="innerContent">
                                            <g:formatNumber number="${orderLine.getQuantityAsDecimal()}" formatName="decimal.format"/>
                                        </td>
                                        <td class="innerContent">
                                            <g:formatNumber number="${orderLine.getPriceAsDecimal()}" type="currency" currencySymbol="${currency.symbol}"/>
                                        </td>
                                        <td class="innerContent">
                                            <g:formatNumber number="${orderLine.getAmountAsDecimal()}" type="currency" currencySymbol="${currency.symbol}"/>
                                        </td>
                                    </tr>
                                </g:each>
                            </g:each>
                            </tbody>
                        </table>

                    </div>
                </div>
            </g:if>

            <!-- credit card -->

        <div id="notes" class="box-cards">
            <div class="box-cards-title">
                <a class="btn-open" href="#"><span><g:message code="prompt.notes"/></span></a>
            </div>
            <div class="box-card-hold">
                <div id="users-contain"  style="position:relative">
                    <div id="test">
                        <g:render template="customerNotes" model="[isNew:isNew, customerNotes:customerNotes, customerNotesTotal:customerNotesTotal, user:user]" />
                    </div>
                </div>
            </div> </div>

            <!-- spacer -->
            <div>
                <br/>&nbsp;
            </div>

        </fieldset>
    </div> <!-- end form-hold -->

</div> <!-- end form-edit -->

</body>
</html>
