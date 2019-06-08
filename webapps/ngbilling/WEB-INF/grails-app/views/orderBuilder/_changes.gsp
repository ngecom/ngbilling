<%@ page import="com.sapienter.jbilling.server.util.ServerConstants; com.sapienter.jbilling.server.metafields.DataType" %>
<%@ page import="com.sapienter.jbilling.server.item.db.AssetDTO; com.sapienter.jbilling.server.item.db.ItemDTO" %>

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
  Shows the changes list
--%>

<div id="changes-box">
    <!-- filter -->
    <div class="form-columns">
        <g:formRemote name="changes-filter-form" url="[action: 'edit']" update="ui-tabs-changes" method="GET">
            <g:hiddenField name="_eventId" value="orderChanges"/>
            <g:hiddenField name="execution" value="${flowExecutionKey}"/>

            <g:applyLayout name="form/input">
                <content tag="label"><g:message code="filters.title"/></content>
                <content tag="label.for">filterBy</content>
                <g:textField name="filterBy" class="field default"
                             placeholder="${message(code: 'orderChanges.filter.by.product')}"
                             value="${changesFilterBy}"/>
            </g:applyLayout>

            <g:applyLayout name="form/select">
                <content tag="label"><g:message code="orderChanges.label.status.title"/></content>
                <content tag="label.for">statusId</content>
                <g:select name="statusId" from="${orderChangeStatuses}"
                          noSelection="['-1': message(code: 'filters.order.change.status.empty')]"
                          optionKey="id" optionValue="${ {it.getDescription(session['language_id']).content} }"
                          value="${changesFilterStatusId}"/>
            </g:applyLayout>
        </g:formRemote>
    </div>

    <!-- changes list -->
    <div class="table-box tab-table">
        <div class="table-scroll">
            <table id="orderChanges" cellspacing="0" cellpadding="0">
                <thead>
                <tr>
                    <th>
                        <g:remoteSort action="edit" sort="description" update="ui-tabs-changes" eventId="orderChanges" method="GET">
                            <g:message code="orderChanges.product.title"/>
                        </g:remoteSort>
                    </th>
                    <th>
                        <g:remoteSort action="edit" sort="applicationDate" update="ui-tabs-changes" eventId="orderChanges" method="GET">
                            <g:message code="orderChanges.apply.on.title"/>
                        </g:remoteSort>
                    </th>
                    <th>
                        <g:remoteSort action="edit" sort="type" update="ui-tabs-changes" eventId="orderChanges" method="GET">
                            <g:message code="orderChanges.type.title"/>
                        </g:remoteSort>
                    </th>
                    <th>
                        <g:remoteSort action="edit" sort="status" update="ui-tabs-changes" eventId="orderChanges" method="GET">
                            <g:message code="orderChanges.status.title"/>
                        </g:remoteSort>
                    </th>
                </tr>
                </thead>
                <tbody>

                <g:each var="orderChange" in="${orderChanges.data}">
                    <tr class="change_header" id="change_header_${orderChange.change.id}"
                        onclick="showChangeDetails(this);">
                        <td>
                            <strong>${orderChange.productDescription}
                            <g:if test="${orderChange.change.isRemoval()}">
                                <span class="removalOrderChange"><g:message code="orderChange.label.removal"/></span>
                            </g:if>
                            </strong>
                            <em><g:message code="table.id.format" args="[orderChange.change.itemId as String]"/></em>
                        </td>
                        <td class="small">
                            <span><g:formatDate date="${orderChange.change.applicationDate}"
                                                formatName="date.format"/></span>
                        </td>
                        <td class="small">
                            <span >
                                ${orderChange.change.type}
                            </span>
                        </td>
                        <td class="medium">
                            <span class="${orderChange.change.statusId == ServerConstants.ORDER_CHANGE_STATUS_APPLY_ERROR ? 'orderChangeApplyError' : ''}">
                                ${orderChange.change.status}
                            </span>
                        </td>
                    </tr>
                    <tr id="change_details_${orderChange.change.id}" class="change_details" style="display: none;">
                        <td colspan="3">
                            <g:if test="${orderChange.change.statusId == ServerConstants.ORDER_CHANGE_STATUS_APPLY_ERROR}">
                                <span class="orderChangeApplyError"><g:message code="${orderChange.change.errorMessageForLocalization}"/></span>
                            </g:if>

                            <g:set var="metaFields" value="${orderChange.change.metaFields?.sort{ it.displayOrder }}" />
                            <g:set var="mfMidPoint" value="${ (metaFields && metaFields.length > 0) ? (((metaFields.length+1)/2) as Integer) : -1}" />

                            <div class="dataTable">
                                <div class="column">
                                    <div>
                                        <span><g:message code="orderChanges.quantity.title"/>:</span>
                                        <span class="value">${formatNumber(number: orderChange.change.getQuantityAsDecimal(), formatName: 'default.number.format')}</span>
                                    </div>

                                    <div>
                                        <span><g:message code="orderChanges.assets.title"/>:</span>
                                        <span class="value"><g:each var="assetId" in="${orderChange.change.assetIds}">
                                            <g:set var="asset" value="${AssetDTO.get(assetId)}"/>${asset.identifier}
                                        </g:each></span>
                                    </div>

                                    <%-- Display half the meta fields in in the left hand column --%>
                                    <g:if test="${mfMidPoint > 0}" >
                                        <g:each in="${metaFields[0..(mfMidPoint-1)]}" var="metaField" >
                                            <g:if test="${!metaField.disabled}">
                                                <div>
                                                    <span><g:message code="${metaField.fieldName}"/></span>
                                                    <span class="value">
                                                        <g:if test="${metaField.getDataType() == DataType.DATE}">
                                                            <g:formatDate date="${metaField.getValue()}" formatName="date.pretty.format"/>
                                                        </g:if>
                                                        <g:else>
                                                            ${metaField.getValue()}
                                                        </g:else>
                                                    </span>
                                                </div>
                                            </g:if>
                                        </g:each>
                                    </g:if>

                                </div>

                                <div class="column">
                                    <div>
                                        <span><g:message code="orderChanges.price.title"/>:</span>
                                        <span class="value">${formatNumber(number: orderChange.change.getPriceAsDecimal(), formatName: 'money.format', maxFractionDigits: 4)}</span>
                                    </div>

                                    <div>
                                        <span><g:message code="orderChanges.startDate.title"/>:</span>
                                        <span class="value"><g:formatDate date="${orderChange.change.startDate}"
                                                                          formatName="date.format"/></span>
                                    </div>

                                    <%-- Display half the meta fields in in the left hand column --%>
                                    <g:if test="${mfMidPoint > 0 && mfMidPoint < metaFields.length}" >
                                        <g:each in="${metaFields[mfMidPoint..metaFields.length - 1]}" var="metaField" >
                                            <g:if test="${!metaField.disabled}">
                                                <div>
                                                    <span><g:message code="${metaField.fieldName}"/></span>
                                                    <span class="value">
                                                        <g:if test="${metaField.getDataType() == DataType.DATE}">
                                                            <g:formatDate date="${metaField.getValue()}" formatName="date.pretty.format"/>
                                                        </g:if>
                                                        <g:else>
                                                            ${metaField.getValue()}
                                                        </g:else>
                                                    </span>
                                                </div>
                                            </g:if>
                                        </g:each>
                                    </g:if>
                                </div>
                            </div>

                            

                            <g:if test="${!orderChange.change.isAppliedSuccessfully()}">
                                <g:remoteLink class="submit" action="edit"
                                              params="[_eventId: 'editChange', changeId: orderChange.change.id]"
                                              update="ui-tabs-edit-changes" after="updateChangesList();" method="GET">
                                    <span><g:message code="button.change"/></span>
                                </g:remoteLink>
                            </g:if>
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
                <g:if test="${maxChangesShown == max}">
                    <span>${max}</span>
                </g:if>
                <g:else>
                    <g:remoteLink action="edit"
                                  params="${sortableParams(params: [partial: true, max: max, _eventId: 'orderChanges', typeId: params.statusId ?: "", filterBy: params.filterBy ?: ""])}"
                                  update="ui-tabs-changes"
                                  method="GET">${max}</g:remoteLink>
                </g:else>
            </g:each>
        </div>

        <div class="row">
            <util:remotePaginate action="edit"
                                 params="${sortableParams(params: [partial: true, _eventId: 'orderChanges', max: maxChangesShown, typeId: params.statusId ?: "", filterBy: params.filterBy ?: ""])}"
                                 total="${orderChanges.totalCount ?: 0}"
                                 update="ui-tabs-changes"
                                 method="GET"/>
        </div>
    </div>
    <script type="text/javascript">
        $('#changes-filter-form :input[name=filterBy]').blur(function () {
            $('#changes-filter-form').submit();
        });
        $('#changes-filter-form :input[name=statusId]').change(function () {
            $('#changes-filter-form').submit();
        });

        function showChangeDetails(element) {
            var id = $(element).attr('id').substring('change_header_'.length);
            if ($('#change_details_' + id).is(':visible')) {
                $('#change_details_' + id).hide();
            } else {
                $('#change_details_' + id).show();
            }
        }

        function updateChangesList() {
            $('#changes-filter-form').submit();
        }
    </script>
</div>