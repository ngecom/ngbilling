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

<%@ page import="com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.item.db.ItemTypeDTO" %>

<%--
  Shows the plans table and pager
--%>

    <!-- plans list -->
    <div class="table-box tab-table">
        <div class="table-scroll">
            <table id="swap-plan-table" cellspacing="0" cellpadding="0">
                <tbody>

                <g:each var="plan" in="${plans}">
                    <tr onclick="$('#swapPlanItemId').val('${plan.id}');">
                        <td>
                            <strong>${plan.getDescription(session['language_id'])}</strong> <g:if test="${plan?.plans?.toArray()[0]?.editable == 1}">&nbsp;(<g:message code="plan.editable.mark"/>)</g:if>
                            <em><g:message code="table.id.format" args="[plan.id as String]"/></em>
                        </td>
                        <td class="small">
                            <span>${plan.internalNumber}</span>
                        </td>
                        <td class="medium">
                            <g:if test="${plan.percentage}">
                                %<g:formatNumber number="${plan.percentage}" formatName="money.format"/>
                            </g:if>
                            <g:else>
                                <g:set var="price" value="${plan.getPrice(order.activeSince ?: order.createDate ?: new Date(), session['company_id'])}"/>
                                <g:formatNumber number="${price?.rate}" type="currency" currencySymbol="${price?.currency?.symbol}"/>
                            </g:else>
                        </td>
                    </tr>
                </g:each>

                </tbody>
            </table>
        </div>
    </div>

    <div class="pager-box">
        <div class="results">
            <g:message code="pager.show.max.results"/>
            <g:each var="max" in="${[10, 20, 50]}">
                <g:if test="${maxPlansShown == max}">
                    <span>${max}</span>
                </g:if>
                <g:else>
                    <g:remoteLink action="edit"
                                  params="${sortableParams(params: [partial: true, max: max, _eventId: 'plans', filterBy: params.filterBy ?: "", forSwapPlan: 'true'])}"
                                  update="planSwap-placeholder"
                                  method="GET">${max}</g:remoteLink>
                </g:else>
            </g:each>
        </div>
        <div class="row">
            <util:remotePaginate action="edit"
                                 params="${sortableParams(params: [partial: true, _eventId: 'plans', max: maxPlansShown, filterBy: params.filterBy ?: "", forSwapPlan: 'true'])}"
                                 total="${plans.totalCount ?: 0}"
                                 update="planSwap-placeholder"
                                 method="GET"/>
        </div>
    </div>