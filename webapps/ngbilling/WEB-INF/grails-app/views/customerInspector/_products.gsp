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

<%@page import="org.apache.commons.lang.StringEscapeUtils;"%>
<%@ page import="com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.item.db.ItemTypeDTO" %>

<%--
  Shows the product list and provides some basic filtering capabilities.

  @author Brian Cowdery
  @since 28-Feb-2011
--%>

<div class="heading">
    <strong><g:message code="builder.products.title"/></strong>
</div>

<div class="box no-buttons">
    <div class="sub-box">
      <!-- filter -->
        <div class="form-columns">
          <g:formRemote name="products-filter-form" url="[action: 'filterProducts']" update="products-column">
              <g:hiddenField name="userId" value="${user?.id ?: params.userId}"/>
  
              <g:applyLayout name="form/input">
                  <content tag="label"><g:message code="filters.title"/></content>
                  <content tag="label.for">filterBy</content>
                  <g:textField name="filterBy" class="field default" placeholder="${message(code: 'products.filter.by.default')}" value="${params.filterBy}"/>
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
              $('#filterBy').blur(function() { $('#products-filter-form').submit(); });
              $('#typeId').change(function() { $('#products-filter-form').submit(); });
              placeholder();
          </script>
      </div>
  
      <!-- product list -->
      <div class="table-box tab-table">
          <div class="table-scroll">
              <table id="products" cellspacing="0" cellpadding="0">
                  <tbody>

                  <g:each var="product" in="${products}">
                      <tr>
                          <td>
                              <g:remoteLink class="cell double" action="productPrices" id="${product.id}" params="[userId: user?.id ?: params.userId]" update="prices-column">
                                  <strong>${StringEscapeUtils.escapeHtml(product?.getDescription(session['language_id']))}</strong>
                              </g:remoteLink>
                          </td>
                          <td class="small">
                              <g:remoteLink class="cell" action="productPrices" id="${product.id}" params="[userId: user?.id ?: params.userId]" update="prices-column">
                                  <span>${StringEscapeUtils.escapeHtml(product?.internalNumber)}</span>
                              </g:remoteLink>
                          </td>
                          <td class="medium">
                              <g:remoteLink class="cell" action="productPrices" id="${product.id}" params="[userId: user?.id ?: params.userId]" update="prices-column">
                                 <g:set var = "price" value="${product.getPrice(new Date(), session['company_id'] as Integer) }" />
                                 <g:formatPriceForDisplay price="${price}" />	
                              </g:remoteLink>
                          </td>
                      </tr>
                  </g:each>

                  </tbody>
              </table>
          </div>
          <div class="pager-box">
            <div class="results">
                <g:message code="pager.show.max.results"/>
                <g:each var="max" in="${[10, 20, 50]}">
                    <g:if test="${params.max == max}">
                        <span>${max}</span>
                    </g:if>
                    <g:else>
                        <g:remoteLink action="filterProducts"
                                      params="${sortableParams(params: [partial: true, userId: user?.id ?: params.userId, max: max, typeId: params.typeId ?: "", filterBy: params.filterBy ?: "" ])}"
                                      update="products-column"
                                      method="GET">${max}</g:remoteLink>
                    </g:else>
                </g:each>
            </div>
            <div class="row">
                <util:remotePaginate action="filterProducts"
                                     params="${sortableParams(params: [partial: true, userId: user?.id ?: params.userId, max: params.max, typeId: params.typeId ?: "", filterBy: params.filterBy ?: ""])}"
                                     total="${products.totalCount ?: 0}"
                                     update="products-column"
                                     method="GET"/>
            </div>
          </div>
      </div>
    </div>
</div>
