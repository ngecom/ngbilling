<%@ page import="com.sapienter.jbilling.server.util.db.EnumerationDTO; com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.metafields.DataType;com.sapienter.jbilling.server.metafields.MetaFieldType;com.sapienter.jbilling.server.metafields.EntityType" %>
<%@page import="java.lang.System"%>
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

<html>
<head>
    <meta name="layout" content="main" />
    <r:require module="errors" />
    <r:script disposition="head">
        $(document).ready(function() {
            $('#metaField\\.dataType').change(function() {
                if ($(this).val() == '${DataType.ENUMERATION}' || $(this).val() == '${DataType.LIST}') {
                    $('.field-name').hide().find('input').prop('disabled', 'true');
                    $('.field-enumeration').show().find('select').prop('disabled', '');
                    $('.field-filename').hide().find('input').prop('disabled', 'true')
                } else if ($(this).val() == '${DataType.SCRIPT}'){
                    $('.field-name').show().find('input').prop('disabled', '');
                    $('.field-enumeration').hide().find('select').prop('disabled', 'true');
                    $('.field-filename').show().find('input').prop('disabled', '')
                } else {
                    $('.field-name').show().find('input').prop('disabled', '');
                    $('.field-enumeration').hide().find('select').prop('disabled', 'true');
                    $('.field-filename').hide().find('input').prop('disabled', 'true')
                }
            }).change();
        });
    </r:script>
</head>
<body>
<div class="form-edit">
	<g:set var="inUse" value="${inUse > 0}"/>
    <g:set var="isNew" value="${!metaField || !metaField?.id || metaField?.id == 0}"/>
    <div class="heading">
        <strong>
            <g:if test="${isNew}">
                <g:message code="metaField.add.title"/>
            </g:if>
            <g:else>
                <g:message code="metaField.edit.title"/>
            </g:else>
        </strong>	
    </div>

    <div class="form-hold">
        <g:form name="metaField-edit-form" action="save">
            <fieldset>
                <g:render template="/metaFields/editMetafield" model="[metaField: metaField, entityType: params.entityType, parentId: 'metaField-edit-form', displayMetaFieldType: false ]"/>
                <!-- spacer -->
                <div>
                    &nbsp;<br/>
                </div>

                <div class="buttons">
                    <ul>
                        <li>
                            <a onclick="$('#metaField-edit-form').submit()" class="submit save">
                                <span><g:message code="button.save"/></span>
                            </a>
                        </li>
                        <li>
                            <g:link action="listCategories" class="submit cancel">
                                <span><g:message code="button.cancel"/></span>
                            </g:link>
                        </li>
                    </ul>
                </div>

            </fieldset>
        </g:form>
    </div>
</div>
</body>
</html>