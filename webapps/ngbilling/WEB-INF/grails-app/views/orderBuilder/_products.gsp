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

<%@ page import="com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.item.db.ItemTypeDTO; com.sapienter.jbilling.server.util.ServerConstants" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>

<%--
  Shows the product list and provides some basic filtering capabilities.

  @author Brian Cowdery
  @since 23-Jan-2011
--%>

<div id="product-box">

    <!-- filter -->
    <div class="form-columns">
        <g:formRemote name="products-filter-form" url="[action: 'edit']" update="ui-tabs-products" method="GET">
            <g:hiddenField name="_eventId" value="products"/>
            <g:hiddenField name="execution" value="${flowExecutionKey}"/>

            <g:applyLayout name="form/input">
                <content tag="label"><g:message code="filters.title"/></content>
                <content tag="label.for">filterBy</content>
                <g:textField name="filterBy" class="field default" placeholder="${params.filterBy?"":message(code: 'products.filter.by.default')}" value="${params.filterBy}"/>
            </g:applyLayout>

            <g:applyLayout name="form/select">
                <content tag="label"><g:message code="order.label.products.category"/></content>
                <content tag="label.for">typeId</content>
                <g:select name="typeId" from="${itemTypes}"
                          noSelection="['': message(code: 'filters.item.type.empty')]"
                          optionKey="id" optionValue="description"
                          value="${params.typeId && !params.typeId.isEmpty() ? params.typeId as Integer : ''}"/>
            </g:applyLayout>
        </g:formRemote>

        <script type="text/javascript">
            $('#products-filter-form :input[name=filterBy]').blur(function() { $('#products-filter-form').submit(); });
            $('#products-filter-form :input[name=typeId]').change(function() { $('#products-filter-form').submit(); });
        </script>
    </div>

    <!-- product list -->
    <div class="table-box tab-table">
        <div class="table-scroll">
            <table id="products" cellspacing="0" cellpadding="0">
                <tbody>
				
				<g:set var="hasSubscriptionProduct" value="${hasSubscriptionProduct}" />
                <g:each var="product" in="${products}">
                    <g:set var="isAssetMgmt" value="${product.assetManagementEnabled == 1}" />
                    <g:set var="isSubsProd" value="${false}" />
                    <%
						for(def type : product.itemTypes) {
							if(type.orderLineTypeId == ServerConstants.ORDER_LINE_TYPE_SUBSCRIPTION.intValue()) {
								isSubsProd = true;
							}
						}
					 %>
                    
                    <tr>
                        <td>
                            <g:remoteLink class="cell double" action="edit" id="${product.id}" params="[_eventId: isAssetMgmt ? 'initAssets' : 'addLine']" update="${isAssetMgmt ? 'assets-box-add' : 'ui-tabs-edit-changes'}" method="GET" >
                                <strong>${StringEscapeUtils.escapeHtml(product?.getDescription(session['language_id']))}</strong>
                                <em><g:message code="table.id.format" args="[product.id as String]"/></em>
                            </g:remoteLink>
                        </td>
                        <td>

                            <%
                            def totalChilds = product?.entities?.size()
                            def multiple = false
                            if (totalChilds > 1 ) {
                                multiple = true
                            }
                            %>
                            <g:remoteLink class="cell double" action="edit" id="${product.id}" params="[_eventId: (hasSubscriptionProduct && isSubsProd) ? 'subscription' : (isAssetMgmt ? 'initAssets' : 'addLine'), isPlan : false, isAssetMgmt : isAssetMgmt]" update="${ (hasSubscriptionProduct && isSubsProd) ? 'subscription-box-add' : (isAssetMgmt ? 'assets-box-add' : 'ui-tabs-edit-changes')}" method="GET" >
                                <g:if test="${product?.global}">
                                    <strong><g:message code="product.label.company.global"/></strong>
                                </g:if>
                                <g:elseif test="${multiple}">
                                    <strong><g:message code="product.label.company.multiple"/></strong>
                                </g:elseif>
                                <g:elseif test="${product?.entity == null}">
                                    <strong>${StringEscapeUtils.escapeHtml(product?.entities?.toArray()[0]?.description)}</strong>
                                </g:elseif>
                                <g:else>
                                    <strong>${StringEscapeUtils.escapeHtml(product?.entity?.description)}</strong>
                                </g:else>
                            </g:remoteLink>
                        </td>
                        <td class="small">

                            <g:remoteLink class="cell double" action="edit" id="${product.id}" params="[_eventId: isAssetMgmt ? 'initAssets' : 'addLine']" update="${ isAssetMgmt ? 'assets-box-add' : 'ui-tabs-edit-changes'}" method="GET" >
                                <span>${StringEscapeUtils.escapeHtml(product?.internalNumber)}</span>
                            </g:remoteLink>
                        </td>
                        <td class="medium">
                            <g:remoteLink class="cell double" action="edit" id="${product.id}"
                                                params="[_eventId: isAssetMgmt ? 'selectProductWithAsset' : 'addLine']" update="${ isAssetMgmt ? 'assets-box-add' : 'ui-tabs-edit-changes'}" method="GET">
										<g:set var="prices" value="${product.itemPrices?.asList()?.sort{ it.currencyDTO.id }}"/>
										<!--Leaving this line intact to handle empty prices list -->
										<g:set var="price" value="${!prices.isEmpty() ? prices.first() : null}"/>
										<!-- Find the price of the default currency -->
										<g:each var="itemPriceDto" in="${product.itemPrices}">
											<g:if test="${user.currencyDTO.id==itemPriceDto.currencyDTO.id}">
												<g:set var="price" value="${itemPriceDto}"/>
											</g:if>
										</g:each>
											<g:formatNumber number="${price?.price}" type="currency" currencySymbol="${price?.currencyDTO?.symbol}"/>
                            </g:remoteLink>
                        </td>
                    </tr>
                </g:each>

                </tbody>
            </table>
        </div>
    </div>
    <div class="pager-box">
        <div class="results">
            <g:message code="pager.show.max.results"/>
            <g:each var="max" in="${[10, 20, 50]}">
                <g:if test="${maxProductsShown == max}">
                    <span>${max}</span>
                </g:if>
                <g:else>
                    <g:remoteLink action="edit"
                                  params="${sortableParams(params: [partial: true, max: max, _eventId: 'products', typeId: params.typeId ?: "", filterBy: params.filterBy ?: "" ])}"
                                  update="ui-tabs-products"
                                  method="GET">${max}</g:remoteLink>
                </g:else>
            </g:each>
        </div>
        <div class="row">
            <util:remotePaginate action="edit"
                                 params="${sortableParams(params: [partial: true, _eventId: 'products', max: maxProductsShown, typeId: params.typeId ?: "", filterBy: params.filterBy ?: ""])}"
                                 total="${products.totalCount ?: 0}"
                                 update="ui-tabs-products"
                                 method="GET"/>
        </div>
    </div>

</div>

<g:render template="assetDialogs"/>
<g:render template="subscriptionDialog"/>
