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

<%@ page import="org.apache.commons.lang.StringEscapeUtils; com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.item.db.AssetStatusDTO;  com.sapienter.jbilling.server.item.db.AssetDTO" %>

<%--
  Shows the asset list and provides some basic filtering capabilities.

  @author Gerhard Maree
  @since 24-April-2011
--%>
<g:if test="${errorMessages}">
    <div class="msg-box error">
        <ul>
            <g:each var="message" in="${errorMessages}">
                <li>${message}</li>
            </g:each>
        </ul>
    </div>
</g:if>

<g:formRemote name="add-assets-form-${assetFlow}" update="assets-table-${assetFlow}"
              url="[action: 'edit']" method="GET">
    <input type="hidden" name="_eventId" value="addAssets">
    <input type="hidden" name="partial" value="true">

<%-- asset list --%>
<div class="table-box tab-table" style="margin-top: 10px">
    <div class="table-scroll">
        <table id="assets" cellspacing="0" cellpadding="0">
            <thead>
            <tr>
                <th class="tiny narrow spacing-narrow"><input type="checkbox" id="check-all-assets"/></th>
                <th class="narrow"><g:message code="asset.detail.identifier" /></th>
                <th class="medium narrow"><g:message code="asset.detail.assetStatus" /></th>
                <th class="medium narrow"><g:message code="asset.detail.createDatetime" /></th>
            </tr>
            </thead>
            <tbody>
            <g:each var="asset" in="${assets}" status="idx">
                <tr class="${asset.isReserved()?'reserved':''}">
                    <td class="tiny narrow ${asset.isReserved()?'reserved':''}">
                            <input type="checkbox" name="asset.select.${idx}" value="${asset.id}" onchange="updateSelectedAssets('asset.select.${idx}','${params.checkedAssets}')"/>
                            <input type="hidden" name="asset.${idx}" value="${asset.id}" />
                    </td>
                    <td class="narrow ${asset.isReserved()?'reserved':''}">
                        <g:remoteLink class="cell double" action="edit" id="${asset.id}" params="[_eventId: 'addAsset']"
                                      update="assets-table-${assetFlow}" method="GET">
                            <strong>${StringEscapeUtils.escapeHtml(asset?.identifier)}</strong> (<g:message code="table.id.format" args="[asset.id as String]"/>)
                        </g:remoteLink>
                    </td>
                    <td class="medium narrow ${asset.isReserved()?'reserved':''}">
                        <g:remoteLink class="cell double" action="edit" id="${asset.id}" params="[_eventId: 'addAsset']"
                                      update="assets-table-${assetFlow}" method="GET">
                            <span>${asset.isReserved() ? g.message(code:"asset.reserved.status") : StringEscapeUtils.escapeHtml(asset?.assetStatus?.description)}</span>
                        </g:remoteLink>
                    </td>
                    <td class="medium narrow ${asset.isReserved()?'reserved':''}">
                        <g:remoteLink class="cell double" action="edit" id="${asset.id}"
                                      params="[_eventId: 'addAsset']" update="assets-table-${assetFlow}" method="GET">
                            <span>${formatDate(date: asset.createDatetime, formatName: 'date.pretty.format')}</span>
                        </g:remoteLink>
                    </td>
                </tr>
            </g:each>

            </tbody>
        </table>
    </div>
</div>
</g:formRemote>

<div class="pager-box ui-tabs-panel">
    <div class="results">
        <g:message code="pager.show.max.results"/>
        <g:each var="max" in="${[10, 20, 50]}">
            <g:if test="${maxAssetsShown == max}">
                <span>${max}</span>
            </g:if>
            <g:else>
                <g:remoteLink action="edit"
                              params="${sortableParams(params: [partial: true, max: max, _eventId: 'assets', statusId: params.statusId ?: "", filterBy: params.filterBy ?: ""])}"
                              update="assets-table-${assetFlow}"
                              method="GET">${max}</g:remoteLink>
            </g:else>
        </g:each>
    </div>

    <div class="row">
        <util:remotePaginate action="edit"
                             params="${sortableParams(params: [partial: true, _eventId: 'assets', max: maxAssetsShown, statusId: params.statusId ?: "", filterBy: params.filterBy ?: ""])}"
                             total="${assets.totalCount ?: 0}"
                             update="assets-table-${assetFlow}"
                             method="GET"/>
    </div>
</div>

<div class="btn-box row">
    <a class="submit add" onclick="$('#add-assets-form-${assetFlow}').submit()">
        <span><g:message code="button.add.checked"/></span>
    </a>
    <g:remoteLink class="submit delete" action="edit"
                  params="[_eventId: 'clearAssets']" update="assets-table-${assetFlow}" method="GET">
        <span><g:message code="button.clear.assets"/></span>
    </g:remoteLink>
    <g:remoteLink class="submit add" controller="product" action="editAsset"
                  params="[partial: 'true', add: 'true', userCompanyMandatory: 'true', prodId: productWithAsset]" update="new-asset-content" after="openNewAssetDialog(event);" method="GET">
        <span><g:message code="button.new.asset"/></span>
    </g:remoteLink>
</div>

<%-- Shows the list of selected assets. Users are able to remove assets from the list. --%>
<div class="form-columns single no-padding">
    <div id="selected-assets-${assetFlow}" class="row cloud">
        <ul class="cloud">
            <li class="invert">
                <div>
                    <strong><g:message code="assets.label.selected"/></strong>
                </div>
            </li>
            <g:each var="asset" in="${selectedAssets}">
                <li>
                    <strong>${asset.identifier}</strong>

                    <g:remoteLink class="cell double" action="edit" id="${asset.id}"
                                  params="[_eventId: 'removeAsset']" update="assets-table-${assetFlow}" method="GET">
                        <span>&#x00D7;</span>
                    </g:remoteLink>
                </li>
            </g:each>
        </ul>
    </div>
</div>

<script type="text/javascript">
    $('#check-all-assets').change(function() {
        $('#assets :checkbox').prop('checked', $(this).prop('checked'));
        $('#assets :checkbox').each(function() {
            updateSelectedAssets($(this).attr('name'),'${params.checkedAssets}');
        });
    });
</script>