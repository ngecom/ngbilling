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
<%@ page import="com.sapienter.jbilling.server.item.AssetStatusBL; com.sapienter.jbilling.server.item.db.AssetStatusDTO; com.sapienter.jbilling.server.item.AssetReservationBL; com.sapienter.jbilling.server.item.db.AssetDTO"%>

<%--
  Display information on an asset including meta fields, transitions

  @author Gerhard Maree
  @since  14-Apr-2013
--%>


<div class="column-hold">
    <div class="heading">
	    <strong>
	    	${asset.identifier}
	    	<g:if test="${asset.deleted}">
                <span style="color: #ff0000;">(<g:message code="object.deleted.title"/>)</span>
            </g:if>
	    </strong>
	</div>

	<div class="box">
        <div class="sub-box">
            <%-- product info --%>
            <table class="dataTable" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td><g:message code="asset.detail.id"/></td>
                        <td class="value">${asset.id}</td>
                    </tr>
                    <tr>
                        <td>${category?.assetIdentifierLabel?: g.message([code: "asset.detail.identifier"])}</td>
                        <td class="value">${asset.identifier}</td>
                    </tr>
                    <tr>
                        <g:if test="${asset.isReserved()}">
                            <td><g:message code="asset.detail.assetStatus"/></td>
                            <td class="value"><g:message code="asset.reserved.status"/></td>
                            <tr>
                                <td><g:message code="asset.detail.reservation.period"/></td>
                                <td class="value">
                                     <g:message code="asset.detail.reservation.period.value" args="[reservation?.getStartDate(), reservation?.getEndDate()]"/>
                                </td>
                            </tr>
                        </g:if><g:else>
                            <td><g:message code="asset.detail.assetStatus"/></td>
                            <td class="value">${asset.assetStatus?.description}</td>
                        </g:else>
                    </tr>
                    <tr>
                        <td><g:message code="asset.detail.product.category"/></td>
                        <td class="value">${asset.item.internalNumber}</td>
                    </tr>
                    <tr>
                        <td><g:message code="asset.detail.order"/></td>
                        <td class="value"><g:link controller="order" action="list" id="${asset.orderLine?.purchaseOrder?.id}">${asset.orderLine?.purchaseOrder?.id}</g:link></td>
                    </tr>
                    <g:if test="${asset.group != null}" >
                        <tr>
                            <td><g:message code="asset.detail.group"/></td>
                            <td class="value"><g:link controller="product" action="showAsset" id="${asset.group.id}">${asset.group.id}</g:link> ${asset.group.identifier}</td>
                        </tr>
                    </g:if>
                    <g:if test="${asset.containedAssets.size() > 0}" >
                        <tr>
                            <td><g:message code="asset.detail.contained.assets"/></td>
                            <td class="value">
                                <g:each in="${asset.containedAssets}" var="containedAsset">
                                    <g:link controller="product" action="showAsset" id="${containedAsset.id}">${containedAsset.id}</g:link> ${containedAsset.identifier},
                                </g:each>
                            </td>
                        </tr>
                    </g:if>
                    <g:render template="/metaFields/metaFields" model="[metaFields: asset.metaFields]"  />
                </tbody>
            </table>

        </div>
    </div>

    <%-- Assignments Box --%>
    <g:set var="assignments" value="${asset?.assignments?.asList().sort{ it.startDatetime.time * -1 }}" />
    <g:render template="assignments" model="[assignments: assignments]" />

    <%-- Transitions Box --%>
    <g:set var="transitions" value="${asset?.transitions?.asList().sort{ it.createDatetime.time * -1 } }" />
    <g:render template="transitions" model="[transitions: transitions]" />


    <div class="btn-box">
    <g:if test="${!asset.deleted}">
            <g:link action="editAsset" id="${asset.id}" class="submit edit"><span><g:message code="button.edit"/></span></g:link>

            <g:if test="${asset?.entity?.id == session['company_id']}">
                <a onclick="showConfirm('deleteAsset-${asset.id}');" class="submit delete"><span><g:message code="button.delete"/></span></a>
            </g:if>

        <g:if test="${asset.isReserved()}">
                <a onclick="showConfirm('releaseAssetReservation-${asset.id}');" class="submit release">
                    <span><g:message code="button.release.reservation"/></span>
                </a>
        </g:if>

	</g:if>
    </div>

    <g:render template="/confirm"
              model="['message': 'product.asset.delete.confirm',
                      'controller': 'product',
                      'action': 'deleteAsset',
                      'id': asset.id,
                      'formParams': ['itemId': asset.item.id],
                     ]"/>

    <g:render template="/confirm"
              model="['message': 'product.asset.release.reservation.confirm',
                      'controller': 'product',
                      'action': 'releaseAssetReservation',
                      'id': asset.id,
                      'formParams': ['itemId': asset.item.id, 'partial': 'true'],
                      'ajax': true,
                      'update': 'column1',
                     ]"/>

</div>

