<%@ page import="com.sapienter.jbilling.server.item.db.ItemDTO; com.sapienter.jbilling.server.order.OrderHelper" %>
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
    Popup dialog.
 --%>

<g:set var="parentId" value="${line ? line?.id : change?.id}"/>
<g:set var="name" value="${type}_${parentId}"/>

<div id="dependencies-dialog-${name}" class="bg-lightbox" title="<g:message code="popup.dependencies.title"/>"
     style="display:none;">

    <div class="table-scroll">
        <g:formRemote name="dependency-to-existed-order-${name}" url="[controller: 'orderBuilder', action: 'edit', _eventId: 'addLine']"
                      update="ui-tabs-edit-changes" method="GET">
            <g:hiddenField name="id" id="toExisted-productId-${name}" value=""/>
            <g:hiddenField name="objectType" value="${type}"/>
            <g:hiddenField name="orderId" id="toExisted-orderId-${name}" value="${order.id}"/>
            <g:hiddenField name="parentLineId" id="toExisted-lineId-${name}" value="${line?.id}"/>
            <g:hiddenField name="parentChangeId" id="toExisted-changeId-${name}" value="${change?.id}"/>
            <g:hiddenField name="_eventId" value="addLine"/>
            <g:hiddenField name="execution" value="${flowExecutionKey}"/>
        </g:formRemote>
        <g:form name="selected-sub-order" url="[controller: 'orderBuilder', action: 'edit', _eventId: 'changeOrder']">
            <g:hiddenField name="id" id="toSelected-orderId" value=""/>
            <g:hiddenField name="_eventId" value="changeOrder"/>
        </g:form>
        <g:form name="dependency-to-new-order-${name}" url="[controller: 'orderBuilder', action: 'edit', _eventId: 'addLineToNewOrder']" method="GET">
            <g:hiddenField name="id" id="toNew-productId-${name}" value=""/>
            <g:hiddenField name="objectType" value="${type}"/>
            <g:hiddenField name="parentLineId" id="toNew-lineId-${name}" value="${line?.id}"/>
            <g:hiddenField name="parentChangeId" id="toNew-changeId-${name}" value="${change?.id}"/>
            <g:hiddenField name="_eventId" value="addLineToNewOrder"/>
            <g:hiddenField name="execution" value="${flowExecutionKey}"/>
        </g:form>
        <table style="margin: 3px 0 0 10px; width: 100%;">
            <col width="50%"/>
            <col width="50%"/>
            <tbody>
            <tr>
                <td valign="top">
                    <div class="table-box">
                        <table id="dependencies-products-${name}" cellspacing="0" cellpadding="0">
                            <thead>
                            <tr>
                                <th><g:message code="order.label.dependent.product"/></th>
                                <th><g:message code="order.label.dependent.min"/></th>
                                <th><g:message code="order.label.dependent.max"/></th>
                            </tr>
                            </thead>
                            <tbody>
                                <g:each var="dependency" in="${productDependencies[type + '_' + parentId]}">
                                    <g:if test="${!dependency.met}">
                                        <g:set var="product" value="${products?.find{ it.id == dependency.productId }}"/>
                                        <g:if test="${!product}">
                                            <g:set var="product" value="${ItemDTO.get(dependency.productId)}"/>
                                        </g:if>
                                        <tr onclick="$('#toExisted-productId-${name}').val('${product.id}');$('#toNew-productId-${name}').val('${product.id}');">
                                            <td>
                                                <a class="cell double">
                                                    <strong>${product.getDescription(session['language_id'])}</strong>
                                                    <em><g:message code="table.id.format" args="[product.id as String]"/></em>
                                                </a>
                                            </td>
                                            <td><a class="cell"><em>${dependency.min}</em></a></td>
                                            <td><a class="cell"><em>${dependency.max}</em></a></td>
                                        </tr>
                                    </g:if>
                                </g:each>
                            </tbody>
                        </table>
                    </div>
                </td>
                <td class="col2" valign="top" style="padding-left: 7px">
%{--                    <div class="heading">
                        <strong><g:message code="builder.suborders.title"/></strong>
                    </div>--}%
                    <div class="table-box">
                        <table id="dependencies-child-orders-${name}" cellspacing="0" cellpadding="0">
                            <thead>
                            <tr>
                                <th><g:message code="builder.suborders.title"/></th>
                                <th/>
                                <th/>
                            </tr>
                            </thead>
                            <tbody>
                                <g:each var="childOrder" in="${OrderHelper.findAllChildren(order)}">
                                    <g:set var="activeSince" value="${formatDate(date: childOrder.activeSince ?: childOrder.createDate, formatName: 'date.pretty.format')}"/>
                                    <g:set var="activeUntil" value="${formatDate(date: childOrder.activeUntil, formatName: 'date.pretty.format')}"/>
                                    <tr onclick="$('#toSelected-orderId').val('${childOrder.id}');">
                                        <td>
                                            <a class="cell double">
                                                <strong>${childOrder.periodStr}</strong>
                                                <em><g:if test="${childOrder.id > 0}">
                                                    <g:message code="table.id.format" args="[childOrder.id as String ]"/>
                                                </g:if><g:else>
                                                    <g:message code="table.id.format" args="['']"/>&nbsp;<g:message code="default.new.label" args="['']"/>
                                                </g:else></em>
                                            </a>
                                        </td>
                                        <td><a class="cell"><em>${activeSince}</em></a></td>
                                        <td><a class="cell"><em>${activeUntil ? activeUntil : '-'}</em></a></td>
                                    </tr>
                                </g:each>
                            </tbody>
                        </table>
                    </div>
                </td>
            </tr></tbody>
        </table>
    </div>
</div>

<script type="text/javascript">
    $(function() {
        setTimeout(function() {
            $('#dependencies-dialog-${name}.ui-dialog-content').remove();
            $('#dependencies-dialog-${name}').dialog({
                autoOpen: false,
                height: 450,
                width: 800,
                modal: true,
                buttons:
                        [
                {
                    text: '<g:message code="add.to.label"/>:',
                    click: function() {},
                    'class': 'dialog_button_as_label'
                },
                {
                    text: '<g:message code="button.current.order"/>',
                    click: function() {
                        $("#toExisted-orderId-${name}").val('${order.id}');
                        if ($('#dependencies-products-${name} tr.active').length > 0) {
                            $("#dependency-to-existed-order-${name}").submit();
                            $(this).dialog('close');
                        }
                    }
                },
                    <g:if test="${order.childOrders}">
                {
                    text: '<g:message code="button.selected.suborder"/>',
                    click: function() {
                            if ($('#dependencies-child-orders-${name} tr.active').length > 0) {
                                $("#selected-sub-order").submit();
                                $(this).dialog('close');
                            }
                        }
                },
                    </g:if>
                    <g:if test="${!order.parentOrder?.parentOrder}">
                {
                    text: '<g:message code="button.new.suborder"/>',
                    click: function() {
                        if ($('#dependencies-products-${name} tr.active').length > 0) {
                            $("#dependency-to-new-order-${name}").submit();
                            $(this).dialog('close');
                        }
                    }
                },
                    </g:if>
                {
                    text: '<g:message code="button.close"/>',
                    click: function() {
                        $(this).dialog('close');
                    }
                }
                        ]
            });
        }, 100);
    });

    function showDependencies_${type}(name) {
        $('#dependencies-dialog-' + name).dialog('open');
    }
</script>
