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

<%@ page import="com.sapienter.jbilling.common.CommonConstants" %>

<html>
<head>
    <meta name="layout" content="panels" /> 

    <g:preferenceEquals preferenceId="${CommonConstants.PREFERENCE_USE_JQGRID}" value="1">
        <link type="text/css" href="${resource(file: '/css/ui.jqgrid.css')}" rel="stylesheet" media="screen, projection" />
        <g:javascript src="jquery.jqGrid.min.js"  />
        <g:javascript src="jqGrid/i18n/grid.locale-${session.locale.language}.js"  />
    </g:preferenceEquals>
    <r:script disposition="head">
        var selected;

        // todo: should be attached to the ajax "success" event.
        // row should only be highlighted when it really is selected.
        $(document).ready(function() {
            $('.table-box li').bind('click', function() {
                if (selected) selected.attr("class", "");
                selected = $(this);
                selected.attr("class", "active");
            })
        });
    </r:script>
</head>

<body>

    <!-- selected configuration menu item -->
    <content tag="menu.item">notification</content>

    <g:if test="${!selectedNotification}">
        <content tag="column1">
            <g:render template="categoriesTemplate" model="['lst': lst]"/>
        </content>

        <content tag="column2">
            <g:if test="${selected}">
                <g:render template="notificationsTemplate" model="['lstByCategory': lstByCategory, categoryId: categoryId]"/>
            </g:if>
        </content>
    </g:if>
    <g:else>
        <!-- show product list and selected product -->
        <content tag="column1">
            <g:render template="notificationsTemplate" model="['lstByCategory': lstByCategory, categoryId: categoryId]"/>
        </content>

        <content tag="column2">
            <g:render template="show" model="['typeDto': typeDto, dto: dto, 'messageTypeId': messageTypeId, 'languageDto': languageDto, 'entityId': entityId]"/>
        </content>
    </g:else>

</body>
</html>
