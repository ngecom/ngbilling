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

<%@ page import="com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.util.ServerConstants" %>
<%@page import="org.apache.commons.lang.StringEscapeUtils; com.sapienter.jbilling.server.item.db.ItemTypeDTO"%>

<%--
  Shows the plans list and provides some basic filtering capabilities.

  @author Brian Cowdery
  @since 02-Feb-2011
--%>

<div id="product-box">

    <!-- filter -->
    <div class="form-columns">
        <g:formRemote name="plans-filter-form" url="[action: 'edit']" update="ui-tabs-plans" method="GET">
            <g:hiddenField name="_eventId" value="plans"/>
            <g:hiddenField name="execution" value="${flowExecutionKey}"/>

            <g:applyLayout name="form/input">
                <content tag="label"><g:message code="filters.title"/></content>
                <content tag="label.for">filterBy</content>
                <g:textField name="filterBy" class="field default" placeholder="${message(code: 'products.filter.by.default')}" value="${params.filterBy}"/>
            </g:applyLayout>
        </g:formRemote>

        <script type="text/javascript">
            $('#plans-filter-form :input[name=filterBy]').blur(function() { $('#plans-filter-form').submit(); });
            placeholder();
        </script>
    </div>

    <!-- product list -->
    <div class="table-box tab-table">
        <div class="table-scroll">
            <table id="plans" cellspacing="0" cellpadding="0">
                <tbody>

                <g:each var="plan" in="${plans}">

                    <g:set var="itemId" value="${g.hasAssetProduct(plan: plan)}"/>
                    <g:set var="hasAssetProduct" value="${itemId ? true : false}"/>
                    <g:set var="isSubsProd" value="${g.isSubsProd(plan: plan)}" />
                    <tr>
                        <td>
                            <g:remoteLink class="cell double" action="edit" id="${plan.id}" params="[_eventId:(hasAssetProduct? 'initAssets' :'addPlan'), isPlan : true, isAssetMgmt : hasAssetProduct, itemId:itemId]" update="${(hasAssetProduct? 'assets-box-add' : 'ui-tabs-edit-changes')}" method="GET" >
                                <strong>${StringEscapeUtils.escapeHtml(plan?.getDescription(session['language_id']))}</strong> <g:if test="${plan?.plans?.toArray()[0]?.editable == 1}">&nbsp;(<g:message code="plan.editable.mark"/>)</g:if>
                                <em><g:message code="table.id.format" args="[plan.id as String]"/></em>
                            </g:remoteLink>
                        </td>
                        <td class="medium">
                            <g:remoteLink class="cell double" action="edit" id="${plan.id}"
                                          params="[_eventId: (isSubsProd) ? 'subscription' : (hasAssetProduct? 'initAssets' :'addPlan'), isPlan : true, isAssetMgmt : hasAssetProduct, itemId:itemId]"
                                          update="${(isSubsProd) ? 'subscription-box-add' : (hasAssetProduct ? 'assets-box-add' : 'ui-tabs-edit-changes')}" method="GET" >
                                <span>${StringEscapeUtils.escapeHtml(plan?.internalNumber)}</span>
                            </g:remoteLink>
                        </td>
                        <td class="medium">
                            <g:remoteLink class="cell double" action="edit" id="${plan.id}" params="[_eventId: 'addPlan']" update="column2" method="GET">
                                <span>${StringEscapeUtils.escapeHtml(planPeriod?.period?.getDescription(session['language_id']))}</span>
                            </g:remoteLink>
                        </td>
                        
                        <td class="medium">
                            <g:remoteLink class="cell double" action="edit" id="${plan.id}" params="[_eventId: (isSubsProd) ? 'subscription' : (hasAssetProduct? 'initAssets' :'addPlan'), isPlan : true, isAssetMgmt : hasAssetProduct, itemId:itemId]" update="${(isSubsProd) ? 'subscription-box-add' :(hasAssetProduct ? 'assets-box-add' : 'ui-tabs-edit-changes')}" method="GET" >
                                    <g:set var="price" value="${plan.getPrice(order.activeSince ?: order.createDate ?: new Date(), session['company_id'])}"/>
                                    <g:formatNumber number="${price?.rate}" type="currency" formatName="price.format" currencySymbol="${price?.currency?.symbol}"/>
                            </g:remoteLink>
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
                                  params="${sortableParams(params: [partial: true, max: max, _eventId: 'plans', filterBy: params.filterBy ])}"
                                  update="ui-tabs-3"
                                  method="GET">${max}</g:remoteLink>
                </g:else>
            </g:each>
        </div>
        <div class="row">
            <util:remotePaginate action="edit"
                                 params="${sortableParams(params: [partial: true, _eventId: 'plans', max: maxPlansShown, filterBy: params.filterBy ?: ""])}"
                                 total="${plans.totalCount ?: 0}"
                                 update="ui-tabs-3"
                                 method="GET"/>
        </div>
    </div>
</div>

<g:render template="assetDialogs"/>
<g:render template="subscriptionDialog"/>
