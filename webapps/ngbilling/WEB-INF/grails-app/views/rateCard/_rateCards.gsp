%{--
  JBILLING CONFIDENTIAL
  _____________________

  [2003] - [2012] Enterprise jBilling Software Ltd.
  All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Enterprise jBilling Software.
  The intellectual and technical concepts contained
  herein are proprietary to Enterprise jBilling Software
  and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden.
  --}%

<%@ page contentType="text/html;charset=UTF-8" %>

<%--
  Shows a list of contact types.

  @author Brian Cowdery
  @since  27-Jan-2011
--%>

<div class="table-box">
    <table id="rateCards" cellspacing="0" cellpadding="0">
        <thead>
            <tr>
                <th><g:message code="rate.card.name"/></th>
                <th class="medium"><g:message code="rate.card.table.name"/></th>
            </tr>
        </thead>

        <tbody>
            <g:each var="card" in="${cards}">
                <tr id="type-${card.id}" class="${selected?.id == card.id ? 'active' : ''}">
                    <td>
                        <g:remoteLink class="cell double" action="show" id="${card.id}" before="register(this);" onSuccess="render(data, next);">
                            <strong>${card.name}</strong>
                            <em><g:message code="table.id.format" args="[card.id as String]"/></em>
                        </g:remoteLink>
                    </td>

                    <td class="small">
                        <g:remoteLink class="cell" action="show" id="${card.id}" before="register(this);" onSuccess="render(data, next);">
                            ${card.tableName}
                        </g:remoteLink>
                    </td>
                </tr>
            </g:each>
        </tbody>
    </table>
</div>

<div class="btn-box">
    <g:remoteLink action='edit' class="submit add" before="register(this);" onSuccess="render(data, next);">
        <span><g:message code="button.create"/></span>
    </g:remoteLink>
</div>