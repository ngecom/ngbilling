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

<%@ page import="com.sapienter.jbilling.server.item.db.ItemTypeDTO; com.sapienter.jbilling.server.metafields.MetaFieldBL; com.sapienter.jbilling.server.item.db.AssetDTO" %>

<%--
  Form for editing an asset

 @author Gerhard Maree
 @since  18-Apr-2013
--%>

<html>
<head>
    <meta name="layout" content="main"/>
</head>

<body>
<div id="new-asset-content" class="form-edit">
    <g:render template="editAssetContent" model="[ asset : asset, statuses: statuses, categoryAssetMgmt: categoryAssetMgmt, companies : companies]"/>
    </div>
<g:link elementId="listAssets" action="assets" id="${asset.item.id}" />

<script type="text/javascript">
    function checkAssetSaveResponse(event) {
        if($('#new-asset-content > asset').length) {
            $('#listAssets')[0].click();
	   	}
		}

    function cancelCreateAsset() {
        $('#listAssets')[0].click();
    }

</script>
