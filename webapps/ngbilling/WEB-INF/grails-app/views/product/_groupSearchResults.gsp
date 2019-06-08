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
<%@ page import="com.sapienter.jbilling.client.util.SortableCriteria; java.util.regex.Pattern" %>

<%--
   Filters for searching asset which will be added to groups

  @author Gerhard Maree
  @since  18-Jul-2013
--%>
<%-- parameters the page functionality must include in URLs --%>
<g:set var="searchParams" value="${SortableCriteria.extractParameters(params, ['filterBy', Pattern.compile(/search.*/),  Pattern.compile(/filterByMetaFieldId(\d+)/), Pattern.compile(/filterByMetaFieldValue(\d+)/)])}" />

<div class="table-box">
    <table id="users" cellspacing="0" cellpadding="0">
        <thead>
        <tr>
            <th>
                    <g:message code="asset.table.th.identifier"/>
            </th>
            <th class="medium2">
                    <g:message code="asset.table.th.creationDate"/>
            </th>
            <th class="small">
                    <g:message code="asset.table.th.status"/>
            </th>
        </tr>
        </thead>

        <tbody>
        <g:each in="${assets}" var="asset">
            <tr id="group-asset-${asset.id}" class="${selected?.id == asset.id ? 'active' : ''}" >
                <td class="narrow" >
                        <em class="narrow">${asset?.identifier}</em>
                </td>
                <td class="narrow">
                        <span class="narrow"><g:formatDate format="dd-MM-yyyy HH:mm" date="${asset.createDatetime}"/></span>
                </td>
                <td class="narrow">
                        <span class="narrow">${asset.assetStatus?.description}</span>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<div class="pager-box">
    <div class="row">
        <div class="results">
            <g:render template="/layouts/includes/pagerShowResults" model="[steps: [10, 20, 50], action: 'groupAssetSearch', update: 'asset-search-results', searchParams: searchParams]" />
        </div>
    </div>

    <div class="row">
        <util:remotePaginate controller="product" action="groupAssetSearch" params="${searchParams}" total="${assets?.totalCount ?: 0}" update="asset-search-results"/>
    </div>
</div>