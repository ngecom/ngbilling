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

<%@page import="com.sapienter.jbilling.server.util.ServerConstants; org.apache.commons.lang.StringEscapeUtils; com.sapienter.jbilling.server.order.OrderBL; com.sapienter.jbilling.server.order.validator.OrderHierarchyValidator;"%>
<%@ page import="com.sapienter.jbilling.server.metafields.DataType; com.sapienter.jbilling.server.order.db.OrderStatusDTO; com.sapienter.jbilling.server.item.db.AssetDTO; com.sapienter.jbilling.server.item.ItemTypeBL; com.sapienter.jbilling.server.util.Util" %>
<%@ page import="com.sapienter.jbilling.client.util.ClientConstants" %>
<%@ page import="com.sapienter.jbilling.server.util.ServerConstants" %>
<%@ page import="com.sapienter.jbilling.server.item.db.ItemDTO; com.sapienter.jbilling.server.item.db.ItemDAS;"%>
<%@ page import="com.sapienter.jbilling.server.user.contact.db.ContactDTO" %>
<%@ page import="com.sapienter.jbilling.server.order.OrderStatusFlag;com.sapienter.jbilling.server.user.db.CompanyDTO"%>

<g:if test="${(drawFilter == null || drawFilter) && order?.childOrders}">
    <div class="column-hold">
        <div class="sub-box">
            <g:applyLayout name="form/select">
                <content tag="label"><g:message code="order.filter.label.status"/></content>
                <content tag="label.for">filterStatusId</content>
                <g:select
                        from="${OrderStatusDTO.findAllByEntity(CompanyDTO.get(session['company_id']))}"
                        optionKey="id" optionValue="${{it?.getDescription(session['language_id'])}}"
                        name="filterStatusId"
                        noSelection="${['':'']}"
                        onchange="${remoteFunction(controller: 'order', action: 'show',id: order.id,
                                                    before: 'register(this)',
                                                    onSuccess: 'render(data, current)',
                                                    params: '\'filterStatusId=\'+' + '$(this).val()' )}"
                        value="${filterStatusId}"/>
            </g:applyLayout>
        </div>
    </div>
</g:if>

<g:if test="${(!filterStatusId || order.statusId == filterStatusId) && !order.deleted}">
<div class="column-hold">

    <g:set var="currency" value="${currencies.find{ it.id == order.currencyId}}"/>

    <div class="heading">
        <strong>
        	<g:message code="order.label.details"/>&nbsp;<em>${order?.id}</em>
        	<g:if test="${order.deleted}">
                <span style="color: #ff0000;">(<g:message code="object.deleted.title"/>)</span>
            </g:if>
        </strong>
    </div>

    <!-- Order Details -->
    <div class="box">
        <div class="sub-box">
            <table class="dataTable">
                <tr>
                    <td colspan="2">
                        <strong>
                            <g:if test="${user?.contact?.firstName || user?.contact?.lastName}">
                                ${user.contact.firstName}&nbsp;${user.contact.lastName}
                            </g:if>
                            <g:else>
                                ${user?.userName}
                            </g:else>
                        </strong><br>
                        <em>${user?.contact?.organizationName}</em>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td><td></td>
                </tr>
                <tr>
                    <td><g:message code="order.label.user.id"/>:</td>
                    <td class="value">
                        <sec:access url="/customer/show">
                            <g:remoteLink controller="customer" action="show" id="${user?.id}" before="register(this);" onSuccess="render(data, next);">
                                ${user?.id}
                            </g:remoteLink>
                        </sec:access>
                        <sec:noAccess url="/customer/show">
                            ${user?.id}
                        </sec:noAccess>
                    </td>
                </tr>
                <tr>
                    <td><g:message code="order.label.user.name" />:</td>
                    <td class="value">${user?.userName}</td>
                </tr>
                <g:isRoot>
                	<tr>
                    	<td><g:message code="order.label.company"/></td>
                        <td class="value">${user?.companyName}</td>
                    </tr>
                </g:isRoot>
            </table>
    
            <table class="dataTable">
                <g:if test="${order?.parentOrder?.id > 0}">
                    <tr>
                        <td><g:message code="order.label.parentOrder"/>:</td>
                        <td class="value">
                            <g:remoteLink action="show" params="['template': 'show', 'singleOrder': 'true']" before="register(this);" onSuccess="render(data, next);" id="${order?.parentOrder?.id}" method="GET">
                                <span>${order?.parentOrder?.id}</span>
                            </g:remoteLink>
                        </td>
                    </tr>
                </g:if>
                <tr><td><g:message code="order.label.create.date"/>:</td>
                    <td class="value">
                        <g:formatDate date="${order?.createDate}" formatName="date.pretty.format"/>
                    </td>
                </tr>
                <tr><td><g:message code="order.label.active.since"/>:</td>
                    <td class="value">
                        <g:formatDate date="${order?.activeSince}" formatName="date.pretty.format"/>
                    </td>
                </tr>
                <tr><td><g:message code="order.label.active.until"/>:</td>
                    <td class="value">
                        <g:formatDate date="${order?.activeUntil}" formatName="date.pretty.format"/>
                    </td>
                </tr>               
            	<tr><td><g:message code="order.label.due.date"/>:</td>
                	<td class="value">
	                    <g:if test="${order != null && order.dueDateValue != null && periodUnit != null}">
	                        ${order?.dueDateValue + ' ' +  periodUnit?.getDescription(session['language_id'])}
	                    </g:if>
                	</td>
            	</tr>                
                <tr><td><g:message code="order.label.next.billable"/>:</td>
                    <td class="value">
                        <g:if test="${order?.nextBillableDay}">
                            <g:formatDate date="${order?.nextBillableDay}"  formatName="date.pretty.format"/>
                        </g:if>
                        <g:elseif test="${!(OrderStatusFlag.FINISHED == order?.orderStatusWS?.orderStatusFlag)}">
                            <g:formatDate date="${order?.activeSince ?: order?.createDate}"  formatName="date.pretty.format"/>
                        </g:elseif>
                    </td>
                </tr>

                <tr>
                    <td><g:message code="order.label.period"/>:</td><td class="value">${order.periodStr}</td>
                </tr>
                <tr>
                    <td><g:message code="order.label.total"/>:</td>
                    <td class="value">
                        <g:formatNumber number="${order.totalAsDecimal}" type="currency" currencySymbol="${currency?.symbol}"/>
                    </td>
                </tr>
                <tr>
                    <td><g:message code="order.label.status"/>:</td>
                    <td class="value">${order?.orderStatusWS?.description}</td>
                </tr>
                <tr>
                    <td><g:message code="order.label.billing.type"/>:</td>
                    <td class="value">${order?.billingTypeStr}</td>
                </tr>
                <tr>
                    <td><g:message code="order.label.cancellation.minimum.period"/>:</td>
                    <td class="value">${order?.cancellationMinimumPeriod}</td>
                </tr>
                <tr>
                    <td><g:message code="order.label.cancellation.fee.type"/>:</td>
                   	<td class="value">${order?.cancellationFeeType}</td>
               	 </tr>
                <g:if test="${order.cancellationFeeType=='ZERO'}">
                	<tr>
                    	<td><g:message code="order.label.cancellation.fee"/>:</td>
                    	<td class="value"><g:formatNumber number="${order.cancellationFee}" type="currency" currencySymbol="${currency?.symbol}"/></td>
                	</tr>
                </g:if>
                
                <g:else>
                	<tr>
                    	<td><g:message code="order.label.cancellation.fee.percentage"/>:</td>
                    	<g:if test="${(order.cancellationFeePercentage)}">
                    	<td class="value">${order?.cancellationFeePercentage}%</td></g:if>
               		 </tr>
               		 <tr>
               		
                    <td><g:message code="order.label.cancellation.fee.maximum"/>:</td>
                    <g:if test="${order.cancellationMaximumFee}"> 
                    <td class="value"><g:formatNumber number="${order.cancellationMaximumFee}" type="currency" currencySymbol="${currency?.symbol}"/></td>
                    </g:if>
                </tr>	
                </g:else>
                <tr>
                    <td><g:message code="order.label.userCodes"/>:</td>
                    <g:if test="${order.userCode}">
                        <td class="value">
                            <g:remoteLink controller="user" action="show" params="[userCode: order.userCode]"
                                          before="register(this);" onSuccess="render(data, next);"
                                          method="GET">${StringEscapeUtils.escapeHtml(order?.userCode)}</g:remoteLink>
                        </td>
                    </g:if>
                </tr>
                    <td><g:message code="order.label.prorating.flag"/>:</td>
                    <td class="value">
	                    <g:if test="${order?.prorateFlag == true}">
	                    	<g:message code="order.label.prorating.flag.true"/>
	                    </g:if>
	                    <g:else>
	                    	<g:message code="order.label.prorating.flag.false"/>
	                    </g:else>
                    </td>
                </tr>
    
                <g:if test="${order?.metaFields}">
                    <!-- empty spacer row -->
                    <tr>
                        <td colspan="2"><br/></td>
                    </tr>
                    <g:render template="/metaFields/metaFieldsWS" model="[metaFields: order?.metaFields]"/>
                </g:if>
            </table>
        </div>
    </div>

    <div class="heading">
        <strong><g:message code="order.label.notes"/></strong>
    </div>

    <!-- Order Notes -->
    <div class="box">
        <div class="sub-box">
            <g:if test="${order?.notes}">
                <p>${order?.notes}</p>
            </g:if>
            <g:else>
                <p><em><g:message code="order.prompt.no.notes"/></em></p>
            </g:else>
        </div>
    </div>

    <div class="heading">
        <strong><g:message code="order.label.lines"/></strong>
    </div>

    <!-- Order Lines -->
    <div class="box">
        <div class="sub-box">
            <g:if test="${order?.orderLines}">
                <g:set var="hasMetaFields" value="${false}" />
                <table class="innerTable" >
                    <thead class="innerHeader">
                         <tr>
                            <th style="min-width: 75px;"><g:message code="order.label.line.item"/></th>
                            <th><g:message code="order.label.line.descr"/></th>
                            <th><g:message code="order.label.line.qty"/></th>
                            <th><g:message code="order.label.line.price"/></th>
                            <th><g:message code="order.label.line.total"/></th>
                         </tr>
                    </thead>
                    <tbody>
                         <g:each var="line" in="${order.orderLines}" status="idx">
                             <tr>
                                <td class="innerContent">
                                    <g:set var="itemDto" value="${new ItemDAS().find(line?.itemId)}"/>
                                        <sec:access url="/product/show">
                                           <g:remoteLink controller="product" action="show" id="${line?.itemId}" params="['template': 'show']" before="register(this);" onSuccess="render(data, next);">
                                                ${line?.itemId}
                                           </g:remoteLink>
                                        </sec:access>
                                        <sec:noAccess url="/product/show">
                                            ${line?.itemId}
                                        </sec:noAccess>
                                </td>
                                <td class="innerContent">
                                    ${line.description}
                                </td>
                                <td class="innerContent">
                                    <g:formatNumber number="${line.quantityAsDecimal ?: BigDecimal.ZERO}" formatName="decimal.format"/>
                                </td>
                                <td class="innerContent">
                                    <g:set var="product" value="${ItemDTO.get(line.itemId)}"/>
                                    <g:formatNumber number="${line.priceAsDecimal ?: BigDecimal.ZERO}" type="currency" currencySymbol="${currency?.symbol}" maxFractionDigits="4"/>
                                </td>
                                <td class="innerContent">
                                    <g:formatNumber number="${line.amountAsDecimal ?: BigDecimal.ZERO}" type="currency" currencySymbol="${currency?.symbol}" maxFractionDigits="4"/>
                                </td>
                             </tr>

                             <%-- Display the meta fields in the next tr --%>
                             <g:if test="${line.metaFields && line.metaFields.length > 0}" >
                                 <g:set var="hasMetaFields" value="${true}" />
                                 <tr lineMetaField>
                                     <td colspan="5">
                                        <table class="dataTable narrow" >
                                            <g:render template="/metaFields/metaFieldsWS" model="[ metaFields: line.metaFields ]"/>
                                        </table>
                                     </td>
                                 </tr>
                             </g:if>

                         </g:each>
                    </tbody>
                </table>
                <g:if test="${hasMetaFields}" >
                    <div class="row">&nbsp;</div>
                    <div class="btn-box row">
                        <a href="" id="metaFieldBtnSpan" class="submit" onclick="toggleMetaFields();return false;" ><g:message code="order.button.metafields.hide"/></a>
                    </div>
                </g:if>
            </g:if>
            <g:else>
                <em><g:message code="order.prompt.no.lines"/></em>
            </g:else>
        </div>
    </div>

    <%-- Assets linked to lines --%>
    <g:if test="${order?.hasLinkedAssets()}">
        <div class="box-cards box-cards-no-margin box-cards-open">
        <div class="box-cards-title">
            <a class="btn-open" href="#"><span><g:message
                    code="order.label.assets"/></span></a>
        </div>

        <div class="box-card-hold">

            <g:each var="line" in="${order.orderLines}" status="idx">
                <g:if test="${line?.hasLinkedAssets()}">
                    <g:set var="itemDto" value="${new ItemDAS().find(line?.itemId)}"/>
                    <g:set var="itemType" value="${new ItemTypeBL().findItemTypeWithAssetManagementForItem(line.itemId)}" />
                    ${itemDto.description}
                    <table class="innerTable" >
                        <thead class="innerHeader">
                        <tr>
                            <th style="min-width: 75px;"><g:message code="asset.detail.id"/></th>
                            <th><g:if test="${itemType.assetIdentifierLabel?.length() > 0}">
                                ${itemType.assetIdentifierLabel}
                                </g:if>
                                <g:else><g:message code="asset.detail.identifier"/></g:else>
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <g:each var="assetId" in="${line.assetIds}">
                            <g:set var="asset" value="${AssetDTO.get(assetId)}" />
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
                </g:if>
            </g:each>

        </div>
        </div>
    </g:if>

    <br/>
    <!-- Invoices Generated -->
    <g:if test="${order?.generatedInvoices}">
        <div class="heading">
            <strong><g:message code="order.label.invoices.generated"/></strong>
        </div>

        <div class="box">
            <div class="sub-box">
                <table class="innerTable" >
                    <thead class="innerHeader">
                         <tr>
                            <th><g:message code="order.invoices.id"/></th>
                            <th><g:message code="order.invoices.date"/></th>
                            <th><g:message code="order.invoices.total"/></th>
                         </tr>
                    </thead>
                    <tbody>
                         <g:each var="invoice" in="${order.generatedInvoices}" status="idx">
                             <g:set var="currency" value="${currencies.find{ it.id == invoice.currencyId}}"/>
    
                             <tr>
                                <td class="innerContent">
                                    <sec:access url="/invoice/show">
                                        <g:remoteLink controller="invoice" action="show" id="${invoice.id}" before="register(this);" onSuccess="render(data, next);">
                                            ${invoice.id}
                                        </g:remoteLink>
                                    </sec:access>
                                    <sec:noAccess url="/invoice/show">
                                        ${invoice.id}
                                    </sec:noAccess>
                                </td>
                                <td class="innerContent">
                                    <g:formatDate format="dd-MMM-yyyy" date="${invoice?.createDateTime}"/>
                                </td>
                                <td class="innerContent">
                                    <g:formatNumber number="${invoice.totalAsDecimal}" type="currency" currencySymbol="${currency?.symbol}"/>
                                </td>
                             </tr>
                         </g:each>
                    </tbody>
                </table>
            </div>
        </div>
    </g:if>

    <div class="btn-box">
    <g:if test="${!order.deleted}">
        <div class="row">
                <g:if test="${OrderStatusFlag.INVOICE == order?.orderStatusWS?.orderStatusFlag}">
                    <a href="${createLink (action: 'generateInvoice', params: [id: order?.id])}" class="submit order">
                        <span><g:message code="order.button.generate"/></span>
                    </a>
                    <a href="${createLink (action: 'applyToInvoice', params: [id: order?.id, userId: user?.id])}" class="submit order">
                        <span><g:message code="order.button.apply.invoice"/></span>
                    </a>
                </g:if>

            <g:set var="lineTypeIds" value="${order.orderLines.collect {it?.typeId}.unique()}"/>
            <g:if test="${!(lineTypeIds.get(0) == ServerConstants.ORDER_LINE_TYPE_DISCOUNT)}">
                <a href="${createLink (controller: 'orderBuilder', action: 'edit', params: [id: order?.id])}" class="submit edit">
                    <span><g:message code="order.button.edit"/></span>
                </a>
             </g:if>   
        </div>
        <div class="row">
                <a onclick="showConfirm('deleteOrder-' + ${order?.id});" class="submit delete">
                    <span><g:message code="order.button.delete"/></span>
                </a>
	   </div>
	</g:if>
    </div>
</div>
</g:if>

<g:if test="${!singleOrder}">
<g:if test="${order?.childOrders}">
    <g:each var="childOrder" in="${order?.childOrders}">
        <g:render template="show" model="[order: childOrder, user: user, currencies: currencies, drawFilter: false, filterStatusId: filterStatusId]"/>
    </g:each>
</g:if>
</g:if>
<g:render template="/confirm"
     model="[message: 'order.prompt.are.you.sure',
             controller: 'order',
             action: 'deleteOrder',
             id: order.id,
            ]"/>

<script language="JavaScript" >
    <g:if test="${params.template}">
        <%-- register for the slide events if it is loaded as a template --%>
        registerSlideEvents();
    </g:if>

    <%-- toggle the text shown on the 'show order line meta fields' button--%>
    function toggleMetaFields() {
        $('[lineMetaField]').toggle();
        if($('#metaFieldBtnSpan').text() == '<g:message code="order.button.metafields.hide"/>') {
            $('#metaFieldBtnSpan').text('<g:message code="order.button.metafields.show"/>');
        } else {
            $('#metaFieldBtnSpan').text('<g:message code="order.button.metafields.hide"/>');
        }

    }

    $(function() {
        setTimeout(function() {
            $('#confirm-dialog-${name}.ui-dialog-content').remove();
            $('#dependencyDialog').dialog({
                autoOpen: false,
                height: 200,
                width: 375,
                modal: true,
                buttons: {
                    '<g:message code="prompt.yes"/>': function() {
                        <%out.println(onYes)%>;
                        showConfirm('deleteOrder-' + $(this).data("orderId"));
                        $(this).dialog('close');
                    },
                    '<g:message code="prompt.no"/>': function() {
                        <%out.println(onNo)%>;
                        $(this).dialog('close');
                    }
                }
            });
        }, 100);
    });

    function checkDependency(orderId, dependencyCount) {
        if(dependencyCount == 0) {
            showConfirm('deleteOrder-' + orderId);
        } else {
            $('#confirm-dialog-${name}.ui-dialog-content').remove();
            $('#dependencyDialog').data("orderId",orderId).dialog('open', orderId);
        }
    }
</script>
<table id="dependencyDialog" style="margin: 3px 0 0 10px">
    <tbody><tr>
        <td valign="top">
            <img src="${resource(dir:'images', file:'icon34.gif')}" alt="confirm">
        </td>
        <td class="col2" style="padding-left: 7px">

            <p id="confirm-dialog-${name }-msg">
                <g:message code="order.prompt.dependency.label"/>
            </p>

        </td>
    </tr></tbody>
</table>
