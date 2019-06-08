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

<%@ page import="org.apache.commons.lang.StringEscapeUtils; com.sapienter.jbilling.server.item.db.ItemTypeDTO" contentType="text/html;charset=UTF-8" %>

<%--
  Shows a list of order change types.
--%>

<div class="table-box">
    <table id="periods" cellspacing="0" cellpadding="0">
        <thead>
            <tr>
                <th class="medium"><g:message code="orderChangeType.name"/></th>
                <th class="medium"><g:message code="orderChangeType.productCategory"/></th>
                <th class="large"><g:message code="orderChangeType.allowOrderStatusChange"/></th>
            </tr>
        </thead>

        <tbody>
            <g:each var="changeType" in="${orderChangeTypes}">

                <tr id="changeType-${changeType.id}" class="${selected?.id == changeType.id ? 'active' : ''}">

                    <td>
                        <g:remoteLink class="cell double" action="show" id="${changeType.id}" before="register(this);" onSuccess="render(data, next);">
                            <strong>${StringEscapeUtils.escapeHtml(changeType?.name)}</strong>
                            <em><g:message code="table.id.format" args="[changeType.id]"/></em>
                        </g:remoteLink>
                    </td>

                    <td>
                        <g:remoteLink class="cell double" action="show" id="${changeType.id}" before="register(this);" onSuccess="render(data, next);">
                            <g:if test="${changeType?.defaultType}">
                                <g:message code="orderChangeType.productCategory.all"/>
                            </g:if>
                            <g:elseif test="${changeType?.itemTypes}">
                                <g:each in="${changeType.itemTypes}" var="itemTypeId" status="stat">
                                    ${StringEscapeUtils.escapeHtml(ItemTypeDTO.get(itemTypeId)?.description)}<g:if test="${stat < changeType.itemTypes.size() - 1}">,&nbsp;</g:if>
                                </g:each>
                            </g:elseif>
                        </g:remoteLink>
                    </td>

                    <td>
                        <g:remoteLink class="cell double" action="show" id="${changeType.id}" before="register(this);" onSuccess="render(data, next);">
                            <g:if test="${changeType.allowOrderStatusChange}">
                                <g:message code="prompt.yes"/>
                            </g:if>
                            <g:else>
                                <g:message code="prompt.no"/>
                            </g:else>
                        </g:remoteLink>
                    </td>

                </tr>

            </g:each>
        </tbody>
    </table>
</div>

<div class="btn-box">
    <g:link class="submit add" action="edit">
        <span><g:message code="button.create"/></span>
    </g:link>
</div>