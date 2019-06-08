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

<%@ page import="com.sapienter.jbilling.common.CommonConstants; com.sapienter.jbilling.server.metafields.db.MetaField; com.sapienter.jbilling.server.item.db.AssetDTO; org.apache.commons.lang.WordUtils; com.sapienter.jbilling.server.item.db.ItemDTO" %>

<%--
  Renders an OrderChangeWS as an editable row for the order builder editOrderChange pane.
--%>
<g:set var="changeId" value="${orderChange.change.id}"/>
<g:set var="changeDependencies" value="${productDependencies["change_" + changeId]}" />
<g:set var="mandatoryNotMet" value="${changeDependencies?.any{it.type == 'mandatory' && !it.met}}"/>
<g:set var="optionalNotMet" value="${changeDependencies?.any{it.type == 'optional' && !it.met}}"/>

<tr class="change_header ${mandatoryNotMet ? 'mandatory-dependency' : (optionalNotMet ? 'optional-dependency' : '')}" id="edit_change_header_${changeId}"
    onclick="showEditChangeDetails(this);">
    <td>
        <strong>${orderChange.productDescription}</strong>
        <em><g:message code="table.id.format" args="[orderChange.change.itemId as String]"/></em>
    </td>
    <td class="small">
        <span><g:formatDate date="${orderChange.change.startDate}"
                            formatName="date.format"/></span>
    </td>
    <td class="medium">
        <span>${orderChange.change.userAssignedStatus}</span>
    </td>
</tr>
<tr id="edit_change_details_${changeId}" class="change_details"
    style="${!currentOrderChangeId?.contains(changeId) ? 'display: none;' : ''}">
    <td colspan="3">
        <g:formRemote name="change-${changeId}-update-form" url="[action: 'edit']" update="ui-tabs-edit-changes"
                      method="GET">
            <g:hiddenField name="_eventId" value="updateChange"/>
            <g:hiddenField name="execution" value="${flowExecutionKey}"/>
            <g:hiddenField name="changeId" value="${changeId}"/>
            <g:hiddenField name="change-${changeId}.optLock" value="${orderChange.change.optLock}"/>

            <div class="box">
                <div class="form-columns">

                    <g:set var="product" value="${ItemDTO.get(orderChange.change.itemId)}"/>

                    <g:applyLayout name="form/select">
                        <content tag="label"><g:message code="orderChange.label.orderChangeType"/></content>
                        <content tag="label.for">change-${changeId}.orderChangeTypeId</content>
                        <g:select name="change-${changeId}.orderChangeTypeId"
                                  from="${orderChangeTypes.findAll { cht ->
                                              return cht.defaultType || cht.itemTypes.any { typeId -> return product.itemTypes.collect { it2 -> it2.id }.contains( typeId ) }
                                          }.sort { it.id != CommonConstants.ORDER_CHANGE_TYPE_DEFAULT } }"
                                  optionKey="${{it.id}}" optionValue="${{it.name}}"
                                  onchange="${remoteFunction(controller: 'orderBuilder',
                                                              action: 'edit',
                                                              update: 'ui-tabs-edit-changes',
                                                              method: 'GET',
                                                              params: '\'changeTypeId=\'+' + '$(this).val()' + ' + \'&_eventId=updateChangeType&changeId=' + orderChange.change.id +'\'')}"
                                  value="${orderChange.change.orderChangeTypeId}"/>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="orderChange.label.purchase.order.period"/></content>
                        <content tag="label.for">change-${changeId}.order</content>
                        ${order.periodStr}
                    </g:applyLayout>

                    <g:applyLayout name="form/date">
                        <content tag="label"><g:message code="orderChange.label.effectiveDate"/></content>
                        <content tag="label.for">change-${changeId}.startDate</content>
                        <g:textField class="field" name="change-${changeId}.startDate"
                                     value="${formatDate(date: orderChange.change?.startDate, formatName: 'datepicker.format')}"/>
                        <content tag="onClose">
                            function() {
                            // do nothing
                            }
                        </content>
                    </g:applyLayout>
                    <g:applyLayout name="form/checkbox">
                        <content tag="label"><g:message code="orderChange.label.apply"/></content>
                        <content tag="label.for">change-${changeId}.appliedManually</content>
                        <g:checkBox name="change-${changeId}.appliedManually"
                                    class="cb check" value="${orderChange.change.appliedManually}" />
                    </g:applyLayout>

                    <g:applyLayout name="form/select">
                        <content tag="label"><g:message code="orderChange.label.status"/></content>
                        <content tag="label.for">change-${changeId}.userAssignedStatusId</content>
                        <g:select name="change-${changeId}.userAssignedStatusId"
                                  from="${orderChangeUserStatuses}"
                                  noSelection="['': '']"
                                  optionKey="id" optionValue="${{it.getDescription(session['language_id']).content}}"
                                  value="${orderChange.change.userAssignedStatusId}"/>
                    </g:applyLayout>


                    <g:set var="product" value="${ItemDTO.get(orderChange.change.itemId)}"/>
                    <g:set var="existedLineForChange" value="${orderChange.change.orderLineId > 0 && orderChange.change.orderId > 0 ?
                            persistedOrderOrderLinesMap.get(orderChange.change.orderId)?.find{it.id == orderChange.change.orderLineId}
                            : null}"/>
                    <g:set var="disableEditItemFields" value="${existedLineForChange != null && existedLineForChange.useItem}"/>
                    <g:set var="quantityNumberFormat" value="${product?.hasDecimals ? 'money.format' : 'default.number.format'}"/>

                    <g:if test="${product.assetManagementEnabled == 1}">
                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="orderChange.label.quantity"/></content>
                            <content tag="label.for">change-${changeId}.quantityAsDecimal</content>
                            ${formatNumber(number: orderChange.change.getQuantityAsDecimal(), formatName: quantityNumberFormat)}
                        </g:applyLayout>
                    </g:if>
                    <g:else>
                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="orderChange.label.quantity"/></content>
                            <content tag="label.for">change-${changeId}.quantityAsDecimal</content>
                            <g:textField name="change-${changeId}.quantityAsDecimal" class="field quantity"
                                         value="${formatNumber(number: orderChange.change.getQuantityAsDecimal() != null ? orderChange.change.getQuantityAsDecimal() : BigDecimal.ONE, formatName: quantityNumberFormat)}"/>
                        </g:applyLayout>
                    </g:else>

                        <g:applyLayout name="form/${disableEditItemFields ? "text" : "input"}">
                            <content tag="label"><g:message code="order.label.line.price"/></content>
                            <content tag="label.for">change-${changeId}.priceAsDecimal</content>
                            <g:if test="${disableEditItemFields}">
                                ${formatNumber(number: existedLineForChange.getPriceAsDecimal() ?: BigDecimal.ZERO, formatName: 'price.format', maxFractionDigits: 4)}
                            </g:if>
                            <g:else>
                                <g:textField name="change-${changeId}.priceAsDecimal" class="field price"
                                         value="${formatNumber(number: orderChange.change.getPriceAsDecimal() ?: BigDecimal.ZERO, formatName: 'price.format.edit', maxFractionDigits: 4)}"
                                         disabled="${orderChange.change.useItem > 0}"/>
                            </g:else>
                        </g:applyLayout>

                        <g:applyLayout name="form/${disableEditItemFields ? "text" : "input"}">
                            <content tag="label"><g:message code="orderChange.label.description"/></content>
                            <content tag="label.for">change-${changeId}.description</content>
                            <g:if test="${disableEditItemFields}">
                                ${existedLineForChange?.description}
                            </g:if>
                            <g:else>
                                <g:textField name="change-${changeId}.description" class="field description"
                                         value="${orderChange.change.description}"
                                         disabled="${orderChange.change.useItem > 0}"/>
                            </g:else>
                        </g:applyLayout>

                    %{-- edit useItem only for new line changes--}%
                    <g:if test="${!orderChange.change.orderLineId || orderChange.change.orderLineId <= 0}">
                            <g:applyLayout name="form/checkbox">
                                <content tag="label">
                                   <%-- <sec:ifNotGranted roles="ORDER_26">
                                        <g:message code="order.label.line.use.item.description"/>
                                    </sec:ifNotGranted>

                                    <sec:ifNotGranted roles="ORDER_27">
                                        <g:message code="order.label.line.use.item.price"/>
                                    </sec:ifNotGranted> --%>

                                        <g:message code="order.label.line.use.item"/>
                                </content>
                                <content tag="label.for">change-${changeId}.useItem</content>
                                <g:checkBox name="change-${changeId}.useItem" changeId="${changeId}"
                                            class="cb check" value="${orderChange.change.useItem > 0}"/>

                                <script type="text/javascript">
                                    $('#change-${changeId}\\.useItem').change(
                                            function () {
                                                var changeId = $(this).attr('changeId');
                                                if ($(this).is(':checked')) {
                                                    $('#change-' + changeId + '\\.priceAsDecimal').prop('disabled', 'true');
                                                    $('#change-' + changeId + '\\.description').prop('disabled', 'true');
                                                } else {
                                                    $('#change-' + changeId + '\\.priceAsDecimal').prop('disabled', '');
                                                    $('#change-' + changeId + '\\.description').prop('disabled', '');
                                                }
                                            }
                                    ).change();
                                </script>
                            </g:applyLayout>
                    </g:if>

                    %{-- Display the 'order line metafields' for the order change --}%
                    <g:if test="${product.orderLineMetaFields}" ><div class="row">&nbsp;</div></g:if>
                    <g:render template="/metaFields/editMetaFields" model="[availableFields: product.orderLineMetaFields, fieldValues: orderChange.change.metaFields]"/>

                    <g:if test="${orderChange.change.assetIds}">
                        <g:each var="assetId" in="${orderChange.change.assetIds}" status="assetIdx">
                            <g:set var="assetObj" value="${AssetDTO.get(assetId)}" />

                            <div title="${assetObj.identifier}" >
                                <g:applyLayout name="form/checkbox">
                                    <content tag="label">
                                        <jB:truncateLabel label="${assetObj.identifier}" max="${15}" suffix="..." />
                                    </content>
                                    <content tag="label.for">change-${changeId}.asset.${assetIdx}</content>
                                    <g:if test="${assetIdx == 0}">
                                        <content tag="group.label"><g:message code="order.label.assets"/></content>
                                    </g:if>
                                    <g:checkBox name="change-${changeId}.asset.${assetIdx}.status"
                                                line="${changeId}" class="cb check" value="${assetId}" checked="true"/>
                                    <g:hiddenField name="change-${changeId}.asset.${assetIdx}.id" value="${assetId}"/>
                                </g:applyLayout>
                            </div>

                        </g:each>
                    </g:if>

                    <g:set var="currentChangeType" value="${orderChangeTypes.find { return it.id == orderChange.change.orderChangeTypeId } }"/>
                    <g:if test="${currentChangeType?.allowOrderStatusChange}">
                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="orderChange.label.orderStatusIdToApply"/></content>
                            <content tag="label.for">change-${changeId}.orderStatusIdToApply</content>
                            <g:select name="change-${changeId}.orderStatusIdToApply"
                                      from="${orderStatuses}"
                                      noSelection="['': '']"
                                      optionKey="${{it.getId()}}" optionValue="${{it.getDescription(session['language_id'])}}"
                                      value="${orderChange.change.orderStatusIdToApply}"/>
                        </g:applyLayout>
                    </g:if>

                     %{-- Display the 'order change type metafields' for the order change --}%
                    <g:if test="${currentChangeType?.orderChangeTypeMetaFields}" >
                        <g:set var="availableOrderChangeMetaFields" value="${currentChangeType?.orderChangeTypeMetaFields.collect {it.getDTO( session['company_id'] )} }"/>
                        <g:render template="/metaFields/editMetaFields" model="[availableFields: availableOrderChangeMetaFields , fieldValues: orderChange.change.metaFields]"/>
                    </g:if>
                </div>
            </div>

            <div class="btn-box">
                <a class="submit save" onclick="$('#change-${changeId}-update-form').submit();"><span><g:message
                        code="button.update"/></span></a>
                <g:remoteLink class="submit cancel" action="edit"
                              params="[_eventId: 'removeChange', changeId: changeId]"
                              update="ui-tabs-edit-changes" method="GET">
                    <span><g:message code="button.remove"/></span>
                </g:remoteLink>
                <g:if test="${product.assetManagementEnabled == 1}">
                    <g:remoteLink class="submit add" action="edit" id="${changeId}"
                                  params="[_eventId: 'initUpdateAssets']" update="assets-box-update" method="GET">
                        <span><g:message code="button.add.assets"/></span>
                    </g:remoteLink>
                    <g:if test="${product.assetManagementEnabled == 1 && orderChange.change.assetIds.length == 0 && orderChange?.change?.removal == 0}">
                        <script> $("#" + ${changeId}).click(); </script>
                    </g:if>
                </g:if>
                <g:if test="${changeDependencies}">
                    <a onclick="showDependencies_change('change_${changeId}');" class="submit add">
                        <span><g:message code="button.show.dependencies"/></span>
                    </a>
                </g:if>
            </div>
        </g:formRemote>
        <g:if test="${changeDependencies}">
            <g:render template="dependencies" model="[ change: orderChange.change, type: 'change' ]" />
        </g:if>
    </td>
</tr>

