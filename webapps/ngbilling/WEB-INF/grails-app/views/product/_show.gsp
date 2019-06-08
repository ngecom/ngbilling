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

<%@ page import="com.sapienter.jbilling.server.item.ItemDependencyType; com.sapienter.jbilling.server.util.Util"%>

<%--
  Product details template. This template shows a product and all the relevant product details.

  @author Brian Cowdery
  @since  16-Dec-2010
--%>

<div class="column-hold">
    <div class="heading">
	    <strong>
	    	${selectedProduct?.internalNumber}
	    	<g:if test="${selectedProduct.deleted}">
                <span style="color: #ff0000;">(<g:message code="object.deleted.title"/>)</span>
            </g:if>
	    </strong>
	</div>

	<div class="box">
        <div class="sub-box">
            <!-- product info -->
            <table class="dataTable" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td><g:message code="product.detail.id"/></td>
                        <td class="value">${selectedProduct.id}</td>
                    </tr>
                    <tr>
                        <td><g:message code="product.detail.internal.internalNumber"/></td>
                        <td class="value">${selectedProduct.number}</td>
                    </tr>
                    <tr>
                        <td><g:message code="product.detail.gl.code"/></td>
                        <td class="value">${selectedProduct.glCode}</td>
                    </tr>
                    
                    <tr>
                        <td><g:message code="product.detail.assetManagementEnabled"/></td>
                        <td class="value"><g:formatBoolean boolean="${selectedProduct.assetManagementEnabled > 0}"/></td>
                    </tr>
                    <tr>
                    	<td><g:message code="product.detail.availability.start.date"/>:</td>
	                    <td class="value">
	                        <g:formatDate date="${selectedProduct.activeSince}" formatName="date.pretty.format"/>
	                    </td>
	                </tr>
	                <tr>
	                	<td><g:message code="product.detail.availability.end.date"/>:</td>
	                    <td class="value">
	                        <g:formatDate date="${selectedProduct.activeUntil}" formatName="date.pretty.format"/>
	                    </td>
	                </tr>
	                
	                <tr>
                        	<td><g:message code="product.detail.price"/></td>
                        <td class="value">
                               ${productEx?.price}
                        </td>
                    </tr>
                </tbody>
            </table>

            <!-- flags & meta fields -->
            <table class="dataTable" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td><em><g:message code="product.detail.decimal"/></em></td>
                        <td class="value"><em><g:formatBoolean boolean="${selectedProduct.hasDecimals > 0}"/></em></td>
                    </tr>

                    <g:if test="${selectedProduct?.metaFields}">
                        <!-- empty spacer row -->
                        <tr>
                            <td colspan="2"><br/></td>
                        </tr>
                        <g:render template="/metaFields/metaFields" model="[metaFields: selectedProduct?.metaFields]"/>
                    </g:if>
                </tbody>
            </table>

            <p class="description">
                ${selectedProduct.description}
            </p>

            <!-- product categories cloud -->
            <div class="box-cards box-cards-open">
                <div class="box-cards-title">
                    <span><g:message code="product.detail.categories.title"/></span>
                </div>
                <div class="box-card-hold">
                    <div class="content">
                        <ul class="cloud">
                            <g:each var="category" in="${selectedProduct.itemTypes.sort{ it.description }}">
                                <li>
                                    <g:link action="list" id="${category.id}">${category.description + (category.allowAssetManagement == 1 ? "*" : "")}</g:link>
                                </li>
                            </g:each>
                        </ul>
                    </div>
                    <div><span class="normal">* <g:message code="product.categories.with.assetmanagement"/></span></div>
                </div>
            </div>

            <!-- product orderLineMetaFields -->
            <div class="box-cards box-cards-open">
                <div class="box-cards-title">
                    <span><g:message code="product.orderLineMetafields.description"/></span>
                </div>
                <div class="box-card-hold">
                    <div class="content">
                        <table class="dataTable" width="100%">
                            <tbody>
                            <g:each var="metaField" in="${selectedProduct.orderLineMetaFields.sort{ it.displayOrder }}">
                                <tr>
                                    <td><g:message code="metaField.label.name"/></td>
                                    <td class="value">${metaField.name}</td>
                                    <td nowrap="nowrap"><g:message code="metaField.label.dataType"/></td>
                                    <td class="value">${metaField.dataType}</td>
                                    <td><g:message code="metaField.label.mandatory"/></td>
                                    <td class="value">
                                        <g:if test="${metaField.mandatory}">
                                            <g:message code="prompt.yes"/>
                                        </g:if>
                                        <g:else>
                                            <g:message code="prompt.no"/>
                                        </g:else>
                                    </td>
                                </tr>
                            </g:each>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!-- product dependencies cloud -->
            <div class="box-cards box-cards-open">
                <div class="box-cards-title">
                    <span><g:message code="product.detail.dependencies.title"/></span>
                </div>
                <div class="box-card-hold">
                    <div class="content">
                        <g:if test="${selectedProduct.getDependenciesOfType(ItemDependencyType.ITEM).size()>0}">
                            <span><g:message code="product.detail.dependencies.products.title"/></span>
                            <table class="dataTable" cellspacing="0" cellpadding="0" width="100%">
                                <thead>
                                <tr class="dependency-th">
                                    <th><g:message code="product.detail.dependencies.id.title"/></th>
                                    <th><g:message code="product.detail.dependencies.name.title"/></th>
                                    <th><g:message code="product.detail.dependencies.min.title"/></th>
                                    <th><g:message code="product.detail.dependencies.max.title"/></th>
                                </tr>
                                </thead>
                                <tbody>
                                <%-- items --%>
                                <g:each var="dependency" in="${selectedProduct.getDependenciesOfType(ItemDependencyType.ITEM).sort{ it.dependent.description }}">
                                    <tr class="dependency-tr medium-width">
                                        <td>${dependency.dependent.id}</td>
                                        <td>${dependency.dependent.description}</td>
                                        <td>${dependency.minimum}</td>
                                        <td>${dependency.maximum}</td>
                                    </tr>
                                </g:each>
                                </tbody>
                            </table>
                        </g:if>

                        <g:if test="${selectedProduct.getDependenciesOfType(ItemDependencyType.ITEM_TYPE).size()>0}">
                            <span><g:message code="product.detail.dependencies.categories.title"/></span>
                            <table class="dataTable" cellspacing="0" cellpadding="0" width="100%">
                                <thead>
                                <tr class="dependency-th">
                                    <th><g:message code="product.detail.dependencies.id.title"/></th>
                                    <th><g:message code="product.detail.dependencies.name.title"/></th>
                                    <th><g:message code="product.detail.dependencies.min.title"/></th>
                                    <th><g:message code="product.detail.dependencies.max.title"/></th>
                                </tr>
                                </thead>
                                <tbody>
                                <%-- item types --%>
                                <g:each var="dependency" in="${selectedProduct.getDependenciesOfType(ItemDependencyType.ITEM_TYPE).sort{ it.dependent.description }}">
                                    <tr class="dependency-tr medium-width">
                                        <td>${dependency.dependent.id}</td>
                                        <td>${dependency.dependent.description}</td>
                                        <td>${dependency.minimum}</td>
                                        <td>${dependency.maximum}</td>
                                    </tr>
                                </g:each>
                                </tbody>
                            </table>
                        </g:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="btn-box">
    <g:if test="${!selectedProduct.deleted}">
            <g:link action="editProduct" id="${selectedProduct.id}" params="[copyFrom: true]" class="submit copy"><span><g:message code="button.copy.product"/></span></g:link>

            <g:link action="editProduct" id="${selectedProduct.id}" class="submit edit"><span><g:message code="button.edit"/></span></g:link>

            <g:if test="${selectedProduct?.entity?.id == session['company_id']}">
                <a onclick="showConfirm('deleteProduct-${selectedProduct.id}');" class="submit delete"><span><g:message code="button.delete"/></span></a>
            </g:if>

        <g:if test="${assetManagementPossible && (selectedProduct.assetManagementEnabled > 0)}">
            <g:link action="assets" id="${selectedProduct.id}" class="submit show"><span><g:message code="button.assets.show"/></span></g:link>
        </g:if>

            <g:if test="${assetManagementPossible && (selectedProduct.assetManagementEnabled > 0)}">
                <g:link action="editAsset" params="[add: 'true', prodId: selectedProduct.id]" class="submit add"><span><g:message code="button.assets.add"/></span></g:link>

                <g:remoteLink id="uploadAsset" class="submit add" action="showUploadAssets" params="[prodId: selectedProduct.id]" before="register(this);" onSuccess="render(data, next);">
                    <span><g:message code="button.assets.upload"/></span>
                </g:remoteLink>
            </g:if>
	</g:if>
    </div>

    <g:render template="/confirm"
              model="['message': 'product.delete.confirm',
                      'controller': 'product',
                      'action': 'deleteProduct',
                      'id': selectedProduct.id,
                      'formParams': ['category': selectedCategoryId],
                     ]"/>
</div>

