<%@ page import="com.sapienter.jbilling.common.CommonConstants; com.sapienter.jbilling.server.item.db.ItemTypeDTO" %>
%{--
  JBILLING CONFIDENTIAL
  _____________________

  [2003] - [2014] Enterprise jBilling Software Ltd.
  All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Enterprise jBilling Software.
  The intellectual and technical concepts contained
  herein are proprietary to Enterprise jBilling Software
  and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden.
  --}%

<%--
  Shows order change type.
--%>

<div class="column-hold">
    <div class="heading">
        <strong>
            ${selected.name}
        </strong>
    </div>

    <div class="box">
        <div class="sub-box">
            <table class="dataTable" cellspacing="0" cellpadding="0">
                <tbody>
                <tr>
                    <td><g:message code="orderChangeType.id"/></td>
                    <td class="value">${selected.id}</td>
                </tr>
                <tr>
                    <td><g:message code="orderChangeType.name"/></td>
                    <td class="value">${selected.name}</td>
                </tr>
                <tr>
                    <td><g:message code="orderChangeType.allowOrderStatusChange"/></td>
                    <td class="value">
                        <g:if test="${selected?.allowOrderStatusChange}">
                            <g:message code="prompt.yes"/>
                        </g:if>
                        <g:else>
                            <g:message code="prompt.no"/>
                        </g:else>
                    </td>
                </tr>
                <tr>
                    <td><g:message code="orderChangeType.productCategory"/></td>
                    <td class="value">
                        <g:if test="${selected?.defaultType}">
                            <g:message code="orderChangeType.productCategory.all"/>
                        </g:if>
                        <g:elseif test="${selected?.itemTypes}">
                            <g:each in="${selected.itemTypes}" var="itemTypeId" status="stat">
                                ${ItemTypeDTO.get(itemTypeId).description}<g:if
                                    test="${stat < selected.itemTypes.size() - 1}">,&nbsp;</g:if>
                            </g:each>
                        </g:elseif>
                    </td>
                </tr>
                </tbody>
            </table>
            <g:if test="${selected.orderChangeTypeMetaFields}">
                <div class="box-cards box-cards-no-margin">
                    <div class="box-cards-title">
                        <span><g:message code="orderChangeType.orderChangeMetafields"/></span>
                    </div>

                    <div class="box-card-hold">
                        <div class="content">
                            <table class="dataTable" width="100%">
                                <tbody>
                                <g:each var="metaField"
                                        in="${selected.orderChangeTypeMetaFields.sort { it.displayOrder }}">
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
            </g:if>
        </div>
    </div>

    <g:if test="${selected.id != CommonConstants.ORDER_CHANGE_TYPE_DEFAULT}">
        <div class="btn-box">
            <div class="row">
                <a href="${createLink(controller: 'orderChangeType', action: 'edit', params: [id: selected?.id])}"
                   class="submit edit">
                    <span><g:message code="button.edit"/></span>
                </a>
                <a onclick="showConfirm('delete-${selected.id}');" class="submit delete"><span><g:message
                        code="button.delete"/></span></a>
            </div>
        </div>
    </g:if>

    <g:render template="/confirm"
              model="['message': 'config.orderChangeTypes.delete.confirm',
                      'controller': 'orderChangeType',
                      'action': 'delete',
                      'id': selected.id,
                      'ajax': true,
                      'update': 'column1',
              ]"/>
</div>