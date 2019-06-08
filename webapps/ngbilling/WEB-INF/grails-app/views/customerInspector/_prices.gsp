
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
  Shows a list of item pricing strategies and attributes.

  @author Brian Cowdery
  @since 28-Feb-2011
--%>
<g:if test="${product}">
    <div class="heading">
        <strong><g:message code="customer.inspect.default.price.title"/></strong>
    </div>
    <div class="box">
        <div class="sub-box">
            <table class="dataTable" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td><g:message code="product.internal.number"/></td>
                        <td class="value" colspan="3">
                            <g:link controller="product" action="show" id="${product.id}">
                                ${product.internalNumber}
                            </g:link>
                        </td>
                    </tr>

                    <tr>
                        <td><g:message code="product.description"/></td>
                        <td class="value" colspan="3">
                            ${product.getDescription(session['language_id'])}
                        </td>
                    </tr>

                    <!-- price model -->
                    <tr><td colspan="4">&nbsp;</td></tr>
                </tbody>
            </table>
        </div>
    </div>
</g:if>

<div class="heading">
    <g:if test="${product}">
        <strong>
            <g:message code="customer.inspect.customer.prices.title"/>
        </strong>
    </g:if>
    <g:else>
        <strong><g:message code="customer.inspect.prices.all.title"/></strong>
    </g:else>
</div>

<div class="box">
    <div class="sub-box">
        <g:if test="${prices}">
    
            <table class="dataTable" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
    
                <g:each var="price" status="index" in="${prices?.sort{ it.precedence }}">
                    <tr>
                        <td><g:message code="product.internal.number"/></td>
                        <td class="value" colspan="2">
                            <g:link controller="product" action="list" id="${price.item.id}">
                                ${price.item.internalNumber}
                            </g:link>
                        </td>
                        <td class="right">
                            <g:if test="${!price.plan}">
                                <!-- edit customer-specific price -->
                                <g:link action="editCustomerPrice" id="${price.id}" params="[userId: user?.id ?: userId, itemId: price.item.id]">
                                    <img src="${resource(dir:'images', file:'icon21.gif')}" alt="edit"/>
                                </g:link>
                            </g:if>
                        </td>
                        <td class="right">
                            <g:if test="${!price.plan}">
                                <!-- delete customer-specific price -->
                                <g:remoteLink action="deleteCustomerPrice" id="${price.id}" params="[userId: user?.id ?: userId, itemId: price.item.id]" update="prices-column">
                                    <img src="${resource(dir:'images', file:'cross.png')}" alt="remove"/>
                                </g:remoteLink>
                            </g:if>
                        </td>
                    </tr>
    
                    <tr>
                        <td><g:message code="product.description"/></td>
                        <td class="value" colspan="3">
                            ${price.item.getDescription(session['language_id'])}
                        </td>
                    </tr>
    
                    <tr>
                        <td><g:message code="plan.item.precedence"/></td>
                        <td class="value" colspan="3">
                            ${price.precedence}
                        </td>
                    </tr>

                    <tr>
                        <td><g:message code="plan.item.price.expiry.date"/></td>
                        <td class="value" colspan="3">
                            ${priceExpiryMap[price?.id]? formatDate(date: priceExpiryMap[price?.id], formatName: 'datepicker.format') : ""}
                        </td>
                    </tr>

                    <!-- price model -->
                    <tr><td colspan="4">&nbsp;</td></tr>
                    <g:render template="/plan/priceModel" model="[model: PriceModelBL.getPriceForDate(price.models, new Date())]"/>
    
                    <!-- separator line -->
                    <g:if test="${index < prices.size()-1}">
                        <tr><td colspan="4"><hr/></td></tr>
                    </g:if>
                </g:each>
    
                </tbody>
            </table>
    
        </g:if>
        <g:else>
            <em><g:message code="customer.inspect.no.prices"/></em>
        </g:else>
    </div>
</div>

<div class="btn-box">
    <g:if test="${product}">
        <g:link class="submit add" action="editCustomerPrice" params="[userId: user?.id ?: userId, itemId: product.id]">
            <span><g:message code="button.add.customer.price"/></span>
        </g:link>

        <g:remoteLink action="allProductPrices" update="prices-column" params="[userId: user?.id ?: userId]" class="submit show">
            <span><g:message code="button.show.all"/></span>
        </g:remoteLink>
    </g:if>
</div>
