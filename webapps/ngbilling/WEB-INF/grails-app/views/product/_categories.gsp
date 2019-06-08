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

<%@ page import="org.apache.commons.lang.StringEscapeUtils; org.apache.commons.lang.StringUtils; com.sapienter.jbilling.server.order.db.OrderLineTypeDTO" %>

<%--
  Categories list

  @author Brian Cowdery
  @since  16-Dec-2010
--%>

<div class="table-box">
    <div class="table-scroll">
        <table id="categories" cellspacing="0" cellpadding="0">
            <thead>
                <tr>
                    <th><g:message code="product.category.th.name"/></th>
                    <g:isRoot><th><g:message code="product.label.available.company.name"/></th></g:isRoot>
                    <th class="small"><g:message code="product.category.th.type"/></th>
                </tr>
            </thead>
            <tbody>
            <g:each var="category" in="${categories}">
                <g:set var="lineType" value="${new OrderLineTypeDTO(category.orderLineTypeId, 0)}"/>

                    <tr id="category-${category.id}" class="${selectedCategoryId == category.id ? 'active' : ''}">
                        <td>
                            <g:remoteLink class="cell double" action="products" id="${category.id}" before="register(this);" onSuccess="render(data, next);">
                                <strong>${StringUtils.abbreviate(StringEscapeUtils.escapeHtml(category?.description), 45)}</strong>
                                <em><g:message code="table.id.format" args="[category.id as String]"/></em>
                            </g:remoteLink>
                        </td>
                        <g:isRoot>
                        <td class="small">
                        	<%
							def totalChilds = category?.entities?.size()
							def multiple = false
							if(totalChilds > 1 ) {
								multiple = true
							}
							 %>
                            <g:remoteLink class="cell" action="products" id="${category.id}" before="register(this);" onSuccess="render(data, next);">
                                <g:if test="${category?.global}">
                                	<strong><g:message code="product.label.company.global"/></strong>
                                </g:if>
                                <g:elseif test="${multiple}">
                                	<strong><g:message code="product.label.company.multiple"/></strong>
                                </g:elseif>
                                <g:else>
                                	<strong>${StringEscapeUtils.escapeHtml(category?.entities?.toArray()[0]?.description)}</strong>
                                </g:else>
                            </g:remoteLink>
                        </td>
                        </g:isRoot>
                        <td class="small">
                            <g:remoteLink class="cell" action="products" id="${category.id}" before="register(this);" onSuccess="render(data, next);">
                                <span>${StringEscapeUtils.escapeHtml(lineType?.description)}</span>
                            </g:remoteLink>
                        </td>
                    </tr>

                </g:each>
                <g:if test="${selectedCategoryId != null}">
                    <g:remoteLink class="hidden" action="products" name="categoryToClick" id="${selectedCategoryId}" before="register(this);"
                                  onSuccess="render(data, next);"/>
                    <script type="text/javascript">$("[name='categoryToClick']").click();</script>
                </g:if>
            </tbody>
        </table>
    </div>
</div>


    <div class="pager-box">
        <div class="row left">
            <g:render template="/layouts/includes/pagerShowResults" model="[steps: [10, 20, 50], action: 'categories', update: 'column1']"/>
        </div>
        <div class="row">
            <util:remotePaginate controller="product" action="categories" total="${categories.totalCount}" update="column1"/>
        </div>
    </div>


<div class="btn-box">
        <g:link action="editCategory" class="submit add" params="${[add: true]}"><span><g:message code="button.create.category"/></span></g:link>

        <a href="#" onclick="return editCategory();" class="submit edit"><span><g:message code="button.edit"/></span></a>
</div>


<!-- edit category control form -->
<g:form name="category-edit-form" controller="product" action="editCategory">
    <g:hiddenField name="id" id="editformSelectedCategoryId" value="${selectedCategoryId}"/>
</g:form>
${categoryId}

<script type="text/javascript">
    function editCategory() {
        $('#editformSelectedCategoryId').val(getSelectedId('#categories'));
        $('#category-edit-form').submit();
        return false;
    }
</script>
