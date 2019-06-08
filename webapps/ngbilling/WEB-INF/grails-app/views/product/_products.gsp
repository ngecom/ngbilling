<%@ page import="org.apache.commons.lang.StringEscapeUtils; org.apache.commons.lang.StringUtils" %>

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
  Products list

  @author Brian Cowdery
  @since  16-Dec-2010
--%>

<g:set var="paginateAction" value="${actionName == 'products' || actionName == 'list' || actionName == 'show' ? 'products' : 'allProducts'}"/>
<g:set var="selectedCategoryId" value="${selectedCategory?.id}"/>
<%-- list of products --%>
<g:if test="${products}">
    <div class="table-box">
        <div class="table-scroll">
            <table id="products" cellspacing="0" cellpadding="0">
                <thead>
                <tr>
                    <th>
                        <g:remoteSort action="${paginateAction}" id="${selectedCategoryId}" sort="id" update="column2">
                            <g:message code="product.th.name"/>
                        </g:remoteSort>
                    </th>
                    <g:isRoot>
                    <th class="medium">
                        <g:remoteSort action="${paginateAction}" id="${selectedCategoryId}" sort="internalNumber" update="column2">
                            <g:message code="product.label.available.company.name"/>
                        </g:remoteSort>
                    </th>
                    </g:isRoot>
                    <th class="medium">
                        <g:remoteSort action="${paginateAction}" id="${selectedCategoryId}" sort="internalNumber" update="column2">
                            <g:message code="product.th.internal.number"/>
                        </g:remoteSort>
                    </th>
                    <g:isNotRoot>
                    	<th class="medium">
                    	</th>
                    </g:isNotRoot>
                </tr>
                </thead>
                <tbody>

                <g:each var="product" in="${products}">

                    <tr id="product-${product.id}" class="${selectedProduct?.id == product.id ? 'active' : ''}">
                        <td>
                            <g:remoteLink class="cell double" action="show" id="${product.id}" params="['template': 'show', 'category': selectedCategoryId]" before="register(this);" onSuccess="render(data, next);">
                                <strong>${StringUtils.abbreviate(StringEscapeUtils.escapeHtml(product?.getDescription(session['language_id'])), 45)}</strong>
                                <em><g:message code="table.id.format" args="[product.id as String]"/></em>
                            </g:remoteLink>
                        </td>
                        <g:isRoot>
                            <td class="medium">
                                <%
                                def totalChilds = product?.entities?.size()
                                def prodId = product?.entities
                                def multiple = false
                                if(totalChilds > 1 ) {
                                    multiple = true
                                }
                                %>
                                <g:remoteLink class="cell" action="show" id="${product.id}" params="['template': 'show', 'category': selectedCategoryId]" before="register(this);" onSuccess="render(data, next);">
                                    <g:if test="${product?.global}">
                                        <strong><g:message code="product.label.company.global"/></strong>
                                    </g:if>
                                    <g:elseif test="${multiple}">
                                        <strong><g:message code="product.label.company.multiple"/></strong>
                                    </g:elseif>
                                    <g:elseif test="${totalChilds==1}">
                                        <strong>${StringEscapeUtils.escapeHtml(product?.entities?.toArray()[0]?.description)}</strong>
                                    </g:elseif>
                                    <g:else>
                                        <strong>-</strong>
                                    </g:else>
                                </g:remoteLink>
                            </td>
                        </g:isRoot>
                        <td class="medium">
                            <g:remoteLink class="cell" action="show" id="${product.id}" params="['template': 'show', 'category': selectedCategoryId]" before="register(this);" onSuccess="render(data, next);">
                                <span>${StringEscapeUtils.escapeHtml(product?.internalNumber)}</span>
                            </g:remoteLink>
                        </td>
                    </tr>

                </g:each>

                </tbody>
            </table>
        </div>
    </div>
</g:if>

<%-- no products to show --%>
<g:if test="${!products}">
    <div class="heading"><strong><em><g:message code="product.category.no.products.title"/></em></strong></div>
    <div class="box">
      <div class="sub-box">
        <g:if test="${selectedCategoryId}">
            <em><g:message code="product.category.no.products.warning"/></em>
        </g:if>
        <g:else>
            <em><g:message code="product.category.not.selected.message"/></em>
        </g:else>
      </div>
    </div>
</g:if>

<div class="pager-box">
    <div class="row">
        <div class="results">
            <g:render template="/layouts/includes/pagerShowResults" model="[steps: [10, 20, 50], action: paginateAction, update: 'column1',id:selectedCategoryId]"/>
        </div>
        <div class="download">
            <sec:access url="/product/csv">
                <g:link action="csv" id="${selectedCategoryId}">
                    <g:message code="download.csv.link"/>
                </g:link>
            </sec:access>
        </div>
    </div>

    <div class="row">
        <util:remotePaginate controller="product" action="${paginateAction}" id="${selectedCategoryId}" params="${sortableParams(params: [partial: true])}" total="${products?.totalCount ?: 0}" update="column1" onSuccess="closePanel(\'#column2\');"/>
    </div>
</div>

<div class="btn-box">
    <g:if test="${selectedCategoryId}">
            <g:link action="editProduct" params="['category': selectedCategoryId]" class="submit add"><span><g:message code="button.create.product"/></span></g:link>

        <g:if test="${!products && selectedCategory?.entity?.id == session['company_id']}">
                <a onclick="showConfirm('deleteCategory-${selectedCategoryId}');" class="submit delete"><span><g:message code="button.delete.category"/></span></a>
        </g:if>
    </g:if>
    <g:elseif test="${!params.action.equals("allProducts")}">
        <em><g:message code="product.category.not.selected.message"/></em>
    </g:elseif>
    <sec:access url="/product/allProducts">
        <g:remoteLink action="allProducts" update="column1" class="submit show" onSuccess="\$('.submit.show').hide(); closePanel(\'#column2\');" ><span><g:message code="button.show.all"/></span></g:remoteLink>
    </sec:access>
</div>

<g:render template="/confirm"
          model="['message':'product.category.delete.confirm',
                  'controller':'product',
                  'action':'deleteCategory',
                  'id':selectedCategoryId,
                 ]"/>

<script type="text/javascript">
$(function(){
    $('div#paginate a').click(function(){
        $('#column2').html('');
    });
});
</script>
