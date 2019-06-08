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
<%@ page import="com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.item.db.AssetStatusDTO;  com.sapienter.jbilling.server.item.db.AssetDTO" %>

<%--
  Shows the list of selected assets. Users are able to remove assets from the list.

  @author Gerhard Maree
  @since 24-April-2011
--%>
<ul class="cloud">
    <li style="background: white">
        <div style="font-size: 14px; color: #000000">
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
