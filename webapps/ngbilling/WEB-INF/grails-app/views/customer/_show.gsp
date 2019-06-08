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

<%@ page import="com.sapienter.jbilling.common.CommonConstants; com.sapienter.jbilling.common.Util; com.sapienter.jbilling.server.customer.CustomerBL"%>
<%@ page import="com.sapienter.jbilling.server.util.ServerConstants; com.sapienter.jbilling.server.user.UserBL"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils; grails.plugin.springsecurity.SpringSecurityUtils; com.sapienter.jbilling.server.invoice.db.InvoiceStatusDAS" %>

<%--
  Shows details of a selected user.

  @author Brian Cowdery
  @since  23-Nov-2010
--%>

<g:set var="customer" value="${selected.customer}"/>
<style>
	.ui-widget-content .ui-state-error{
		background-color:white;
		background: none;
	}
	.row .inp-bg{
		display: table-caption;
	}
</style>

<script>
    $(document).ready(function() {
        var noteTitle = $("#noteTitle"+${selected.id}),
                userId = $( "#userId"),
                noteContent = $("#noteContent"+${selected.id});
        allFields = $( [] ).add( noteTitle ).add( noteContent ),
                tips = $( ".validateTips" );

        $( "#customer-add-note-dialog-"+${selected.id} ).dialog({ autoOpen: false,
            height: 380,
            width: 550,
            // Workaround for modal dialog dragging jumps
            create: function(event){
                $(event.target).parent().css("position", "fixed");
            },
            modal: true ,buttons: {
                "${g.message(code:'button.add.note')}": function() {
                    var bValid = true;
                    allFields.removeClass( "ui-state-error" );
                    bValid = bValid && checkLength( noteTitle, "${message(code: 'customer.detail.note.form.title')}", 1, 50 );
                    bValid = bValid && checkLength( noteContent, "${message(code: 'customer.detail.note.form.content')}", 1, 1000 );
                    if(bValid){
                        jQuery.ajax({
                            url: "${createLink(controller: 'customer', action: 'saveCustomerNotes')}",
                            data: $("#notes-form"+${selected.id}).serialize(),
                            success: function (data) {
                                jQuery("#user-"+${selected.id}).find("#"+${selected.id}).first().trigger('click');
                            }
                        });
                        $( this ).dialog( "close" );
                    }
                },
                "${message(code: 'customer.detail.note.form.cancel.button')}": function() {
                    $( this ).dialog( "close" );
                }
            },
            close: function() {
                allFields.val( "" ).removeClass( "ui-state-error" );
            }
        });
    });

    function checkLength( o, n, min, max ) {
        if ( o.val().length > max || o.val().length < min ) {
            o.addClass( "ui-state-error" );
            updateTips( "Length of " + n + " must be between " +min + " and " + max + "." );
            return false;
        } else {
            return true;
        }
    }

    function updateTips( t ) {
        tips.text( t ).addClass( "ui-state-error" );
    }

    function openDialog(){
        $("#noteTitle"+${selected.id}).val('');
        $("#noteContent"+${selected.id}).val('');
        tips.text("${g.message(code:'customer.note.fields.required')}").removeClass( "ui-state-error" );
        $( "#customer-add-note-dialog-"+${selected.id} ).dialog("open" );
    }
</script>

<div class="column-hold">
	<!-- user notes -->
	<div id="customer-add-note-dialog-${selected?.id?:""}"
		title="${g.message(code:'button.add.note')}">
		<p id="validateTips" class="validateTips"
			style="border: 1px solid transparent; padding: 0.3em;"></p>
		<g:form id="notes-form${selected?.id?:""}" name="notes-form"
			url="[action: 'saveCustomerNotes']">
			<g:render template="customerNotesForm" />
			<g:hiddenField name="notes.customerId"
				value="${UserBL.getUserEntity(selected?.id?:"")?.getCustomer()?.getId()}" />
		</g:form>
	</div>

    <div class="heading">
        <strong>
            <g:if test="${contact?.firstName || contact?.lastName}">
                ${contact.firstName} ${contact.lastName}
            </g:if>
            <g:else>
                ${selected.userName}
            </g:else>
            <em><g:if test="${contact}">${contact.organizationName}</g:if></em>
            <g:if test="${selected.deleted}">
                <span style="color: #ff0000;"><g:message code="user.status.deleted"/></span>
            </g:if>
        </strong>
    </div>
</div>

    <!-- user details -->
    <div class="heading">
        <strong><g:message code="customer.detail.user.title"/></strong>
    </div>
    <div class="box">
        <div class="sub-box">
            <table class="dataTable" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td><g:message code="customer.detail.user.user.id"/></td>
                            <td class="value">
                                <sec:access url="/customerInspector/inspect">
                                    <g:link controller="customerInspector" action="inspect" id="${selected.id}" title="${message(code: 'customer.inspect.link')}">
                                        ${selected.id}
                                        <img src="${resource(dir: 'images', file: 'magnifier.png')}" alt="inspect customer"/>
                                    </g:link>
                                </sec:access>
                                <sec:noAccess url="/customerInspector/inspect">
                                    ${selected.id}
                                </sec:noAccess>
                            </td>
                        </tr>
                        <tr>
                            <td><g:message code="customer.detail.user.username"/></td>
                            <td class="value">

                                <g:if test="${!SpringSecurityUtils.isSwitched() && selected.id != session['user_id']}">
                                        <form id="switch-user-form" action="${request.contextPath}/j_spring_security_switch_user" method="POST">
                                            <g:hiddenField name="j_username" value="${selected.userName};${session['company_id']}"/>
                                        </form>
                                        <a onclick="$('#switch-user-form').submit()" title="${message(code: 'switch.user.link')}">
                                            ${selected.userName} <img src="${resource(dir: 'images', file: 'user_go.png')}" alt="switch user"/>
                                        </a>
                                </g:if>
                                <g:else>
                                    ${selected.userName}
                                </g:else>

                            </td>
                        </tr>
                        <g:if test="${customer.partner}">
                            <tr>
                                <td><g:message code="customer.related.agent"/></td>
                                <td class="value">
                                    <g:remoteLink controller="partner" action="show" id="${customer.partner.id}" before="register(this);" onSuccess="render(data, next);">
                                        ${StringEscapeUtils.escapeHtml(customer?.partner?.user?.userName)}
                                    </g:remoteLink>
                                </td>
                            </tr>
                        </g:if>
                        <g:isRoot>
                        	<tr>
                            	<td><g:message code="customer.detail.user.company"/></td>
                            	<td class="value">${selected?.company?.description}</td>
                        	</tr>
                        </g:isRoot>
                        <tr>
							<td><g:message code="customer.detail.user.status" /></td>
							<g:if test='${!selected.deleted}'>
								<td class="value">
									${selected.userStatus.description}
								</td>
							</g:if>
							<g:else>
								<td class="value"><g:message code="user.userstatus.deleted" />
								</td>
							</g:else>
						</tr>
                        <tr>
                            <td><g:message code="user.locked"/></td>
                            <td class="value"><g:formatBoolean boolean="${selected.isAccountLocked()}" true="Yes" false="No"/></td>
                        </tr>
                        <tr>
                            <td><g:message code="customer.detail.user.created.date"/></td>
                            <td class="value"><g:formatDate date="${selected.createDatetime}" formatName="date.pretty.format"/></td>
                        </tr>
                        <tr>
                            <td><g:message code="customer.detail.userCodes"/></td>
                            <g:if test="${userCodes}">
                                <td class="value">
                                    <g:set var="ucLength" value="${userCodes.size()-1}" />
                                    <g:each in="${userCodes}" var="uc" status="ucIdx">
                                        <g:remoteLink controller="user" action="show" params="[userCode: uc]"
                                                      before="register(this);" onSuccess="render(data, next);"
                                                      method="GET">${uc}</g:remoteLink><g:if test="${ucIdx < ucLength}">,</g:if>
                                    </g:each>
                                </td>
                            </g:if>
                        </tr>

                        <g:if test="${metaFields}">
                            <!-- empty spacer row -->
                            <tr>
                                <td colspan="2"><br/></td>
                            </tr>
                            <g:render template="/metaFields/metaFields" model="[metaFields: metaFields]"/>
                        </g:if>

                        <g:if test="${customer?.parent}">
                            <!-- empty spacer row -->
                            <tr>
                                <td colspan="2"><br/></td>
                            </tr>
                            <tr>
                                <td><g:message code="prompt.parent.id"/></td>
                                <td class="value">
                                    <g:remoteLink action="show" id="${customer.parent.baseUser.id}" before="register(this);" onSuccess="render(data, next);">
                                        ${customer.parent.baseUser.id} - ${StringEscapeUtils.escapeHtml(customer?.parent?.baseUser?.userName)}
                                    </g:remoteLink>
                                </td>
                            </tr>
                            <tr>
                                <td><g:message code="customer.invoice.if.child.label"/></td>
                                <td class="value">
                                    <g:if test="${customer.invoiceChild > 0}">
                                        <g:message code="customer.invoice.if.child.true"/>
                                    </g:if>
                                    <g:else>
                                        <g:set var="parent" value="${new CustomerBL(customer.id).getInvoicableParent()}"/>
                                        <g:remoteLink action="show" id="${parent.baseUser.id}" before="register(this);" onSuccess="render(data, next);">
                                            <g:message code="customer.invoice.if.child.false" args="[ parent.baseUser.id ]"/>
                                        </g:remoteLink>
                                    </g:else>
                                </td>
                            </tr>
                            <tr>
                                <td><g:message code="prompt.use.parent.pricing"/></td>
                                <td class="value">
                                    <g:formatBoolean boolean="${customer.useParentPricing}"/>
                                </td>
                            </tr>
                        </g:if>

                        <g:if test="${customer?.children}">
                            <!-- empty spacer row -->
                            <tr>
                                <td colspan="2"><br/></td>
                            </tr>

                            <!-- direct sub-accounts -->
                            <g:each var="account" in="${customer.children.findAll{ it.baseUser.deleted == 0 }}">
                                <tr>
                                    <td><g:message code="customer.subaccount.title" args="[ account.baseUser.id ]"/></td>
                                    <td class="value">
                                        <g:remoteLink action="show" id="${account.baseUser.id}" before="register(this);" onSuccess="render(data, next);">
                                            ${StringEscapeUtils.escapeHtml(account.baseUser.userName)}
                                        </g:remoteLink>
                                    </td>
                                </tr>
                            </g:each>
                        </g:if>
                    </tbody>
                </table>
            </div>
    </div>

    <!-- user payment details -->
    <div class="heading">
        <strong><g:message code="customer.detail.payment.title"/></strong>
    </div>
    <div class="box">

        <div class="sub-box"><!-- show most recent order, invoice and payment -->
            <table class="dataTable" cellspacing="0" cellpadding="0">
                <tbody>
                <tr>
                    <td><g:message code="customer.detail.payment.order.date"/></td>

                    <td class="value">
                        <sec:access url="/order/show">
                            <g:remoteLink controller="order" action="show" id="${latestOrder?.id}" before="register(this);" onSuccess="render(data, next);">
                                <g:formatDate date="${latestOrder?.createDate}" formatName="date.pretty.format"/>
                            </g:remoteLink>
                        </sec:access>
                        <sec:noAccess url="/order/show">
                            <g:formatDate date="${latestOrder?.createDate}" formatName="date.pretty.format"/>
                        </sec:noAccess>
                    </td>
                    <td class="value">
                        <sec:access url="/order/list">
                            <g:link controller="order" action="user" id="${selected.id}">
                                <g:message code="customer.show.all.orders"/>
                            </g:link>
                        </sec:access>
                    </td>
                </tr>
                    <tr>
                        <td><g:message code="customer.detail.payment.invoiced.date"/></td>
                        <td class="value">
                            <sec:access url="/invoice/show">
                                <g:remoteLink controller="invoice" action="show" id="${latestInvoice?.id}" before="register(this);" onSuccess="render(data, next);">
                                    <g:formatDate date="${latestInvoice?.createDateTime}" formatName="date.pretty.format"/>
                                </g:remoteLink>
                            </sec:access>
                            <sec:noAccess url="/invoice/show">
                                <g:formatDate date="${latestInvoice?.createDateTime}" formatName="date.pretty.format"/>
                            </sec:noAccess>
                        </td>
                        <td class="value">
                            <sec:access url="/invoice/list">
                                <g:link controller="invoice" action="user" id="${selected.id}">
                                    <g:message code="customer.show.all.invoices"/>
                                </g:link>
                            </sec:access>
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="customer.detail.payment.paid.date"/></td>
                        <td class="value">
                            <sec:access url="/payment/show">
                                <g:remoteLink controller="payment" action="show" id="${latestPayment?.id}" before="register(this);" onSuccess="render(data, next);">
                                    <g:formatDate date="${latestPayment?.paymentDate ?: latestPayment?.createDatetime}" formatName="date.pretty.format"/>
                                </g:remoteLink>
                            </sec:access>
                            <sec:noAccess url="/payment/show">
                                <g:formatDate date="${latestPayment?.paymentDate ?: latestPayment?.createDatetime}" formatName="date.pretty.format"/>
                            </sec:noAccess>
                        </td>
                        <td class="value">
                            <sec:access url="/payment/list">
                                <g:link controller="payment" action="user" id="${selected.id}">
                                    <g:message code="customer.show.all.payments"/>
                                </g:link>
                            </sec:access>
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="customer.detail.user.next.invoice.date"/></td>
                        <td class="value">
                            <g:set var="nextInvoiceDate" value="${customer.nextInvoiceDate}"/>

                            <g:if test="${nextInvoiceDate}">
                                <span><g:formatDate date="${nextInvoiceDate}" formatName="date.pretty.format"/></span>
                            </g:if>
                            <g:else>
                                <g:message code="prompt.no.active.orders"/>
                            </g:else>
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="customer.detail.billing.cycle"/></td>
                        <td class="value">
                            <g:set var="subscriptionPeriod" value="${customer?.mainSubscription?.subscriptionPeriod}"/>
                            <g:set var="nextInvoiceDayOfPeriod" value="${customer?.mainSubscription?.nextInvoiceDayOfPeriod}"/>
                            <span>${Util.mapOrderPeriods(subscriptionPeriod.periodUnit.id.intValue(), nextInvoiceDayOfPeriod ?: '',subscriptionPeriod?.getDescription() ?: '',nextInvoiceDate)} </span>
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="customer.detail.payment.due.date"/></td>
                        <td class="value"><g:formatDate date="${latestInvoice?.dueDate}" formatName="date.pretty.format"/></td>
                    </tr>
                    <tr>
                        <td><g:message code="customer.detail.payment.invoiced.amount"/></td>
                        <td class="value"><g:formatNumber number="${latestInvoice?.totalAsDecimal}" type="currency" currencySymbol="${selected.currency.symbol}"/></td>
                    </tr>
                    <tr>
                        <td><g:message code="invoice.label.status"/></td>
                        <td class="value">
                            <g:if test="${latestInvoice}">
                                <g:set var="invoiceStatus" value="${new InvoiceStatusDAS().find(latestInvoice?.statusId)}"/>
                                <g:if test="${latestInvoice?.statusId == CommonConstants.INVOICE_STATUS_UNPAID && isCurrentCompanyOwning}">
                                    <g:link controller="payment" action="edit" params="[userId: selected.id, invoiceId: latestInvoice.id]" title="${message(code: 'invoice.pay.link')}">
                                        ${invoiceStatus.getDescription(session['language_id'])}
                                    </g:link>
                                </g:if>
                                <g:else>
                                    ${invoiceStatus?.getDescription(session['language_id'])}
                                </g:else>
                            </g:if>
                        </td>
                    </tr>
                <tr>
                    <td><g:message code="customer.detail.payment.amount.owed"/></td>
                    <td class="value"><g:formatNumber number="${UserBL.getBalance(selected.id)}" type="currency"  currencySymbol="${selected.currency.symbol}"/></td>
                    <td class="value">
                        <g:if test="${enableTotalOwnedPayment && isCurrentCompanyOwning}">
                            <g:link controller="payment" action="edit" params="[payOwned:true, userId:selected.id]">
                                <g:message code="customer.pay.total.owed"/>
                            </g:link>
                        </g:if>
                    </td>
                </tr>
                    <tr>
                        <td><g:message code="customer.detail.payment.lifetime.revenue"/></td>
                        <td class="value"><g:formatNumber number="${revenue}" type="currency"  currencySymbol="${selected.currency.symbol}"/></td>
                    </tr>
                </tbody>
                
                
            </table>

            <hr/>

            <g:each in="${selected.paymentInstruments}" var="paymentInstr">
                <g:render template="creditCard" model="[paymentInstr: paymentInstr]"/>
            </g:each>
        </div>
    </div>
<!-- Assets start  -->

    
        <div class="box-cards box-cards-no-margin">
        <div class="box-cards-title">
            <span><g:message
                    code="order.label.assets"/></span>
        </div>

        <div class="box-card-hold">

                    <table class="innerTable" >
                        <thead class="innerHeader">
                        <tr>
                            <th style="min-width: 75px;"><g:message code="asset.detail.id"/></th>
                            <th><g:message code="asset.detail.identifier"/>
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <g:each var="asset" in="${customerAssets}">
                            
                            <tr>
                                <td class="innerContent">
                                    <sec:access url="/product/showAsset">
                                        <g:remoteLink controller="product" action="showAsset" id="${asset.id}" params="['template': 'show']" before="register(this);" onSuccess="render(data, next);">
                                            ${asset.id}
                                        </g:remoteLink>
                                    </sec:access>
                                    <sec:noAccess url="/product/showAsset">
                                        ${asset.id}
                                    </sec:noAccess>
                                </td>
                                <td class="innerContent">
                                    ${asset.identifier}
                                </td>

                            </tr>
                        </g:each>
                        </tbody>
                    </table>
               
            

        </div>
        </div>
 <br/>
<!-- Assets end -->
    <div class="btn-box">
        <g:if test="${!selected.deleted}">
            <div class="row">
                    <g:link controller="orderBuilder" action="edit" params="[userId: selected.id]" class="submit order"><span><g:message code="button.create.order"/></span></g:link>

                    <g:link controller="payment" action="edit" params="[userId: selected.id]" class="submit payment"><span><g:message code="button.make.payment"/></span></g:link>
            </div>
            <div class="row">
                    <g:link action="edit" id="${selected.id}" class="submit edit"><span><g:message code="button.edit"/></span></g:link>

                    <a onclick="showConfirm('delete-${selected.id}');" class="submit delete"><span><g:message code="button.delete"/></span></a>

                    <g:if test="${customer?.isParent > 0}">
                        <g:link action="edit" params="[parentId: selected.id]" class="submit add"><span><g:message code="customer.add.subaccount.button"/></span></g:link>
                    </g:if>
            </div>
        </g:if>
    </div>

    <g:render template="/confirm"
              model="['message': 'customer.delete.confirm',
                      'controller': 'customer',
                      'action': 'delete',
                      'id': selected.id,
                     ]"/>

</div>
