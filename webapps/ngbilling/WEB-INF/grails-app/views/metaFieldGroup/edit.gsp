<%@ page import="com.sapienter.jbilling.server.util.db.EnumerationDTO; com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.metafields.DataType" %>
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
    <r:script disposition="head">
        $(document).ready(function() {
            $('#metaFieldGroup\\.dataType').change(function() {
                if ($(this).val() == '${DataType.ENUMERATION}' || $(this).val() == '${DataType.LIST}') {
                    $('#field-name').hide().find('input').prop('disabled', 'true');
                    $('#field-enumeration').show().find('select').prop('disabled', '');
                } else {
                    $('#field-name').show().find('input').prop('disabled', '');
                    $('#field-enumeration').hide().find('select').prop('disabled', 'true');
                }
            }).change();
        });
    </r:script>
	<r:require module="disjointlistbox"/>
</head>
<body>
<div class="form-edit">

    <g:set var="isNew" value="${!metaFieldGroup || !metaFieldGroup?.id || metaFieldGroup?.id == 0}"/>

    <div class="heading">
        <strong>
            <g:if test="${isNew}">
                <g:message code="metaFieldGroup.add.title"/>
            </g:if>
            <g:else>
                <g:message code="metaFieldGroup.edit.title"/>
            </g:else>
        </strong>
    </div>

    <div class="form-hold">
        <g:form name="metaFieldGroup-edit-form" action="save">
            <fieldset>

                <div class="form-columns">
                    <div class="column">
                        <g:hiddenField name="entityType" value="${metaFieldGroup?.entityType ?  metaFieldGroup.entityType?.name() : ""}"/>
                        
                        <g:hiddenField name="id" value="${metaFieldGroup?.id}"/>


                         <div id="field-name" >
                            <g:applyLayout name="form/select">
                                <content tag="label"><g:message code="metaFieldGroup.label.entityType"/></content>
                                
                                ${metaFieldGroup?.entityType?.name()}
                            </g:applyLayout>
                        </div>
                        <div id="field-name">
                            <g:applyLayout name="form/input">
                                <content tag="label"><g:message code="metaFieldGroup.label.name"/><span id="mandatory-meta-field">*</span></content>
                                <content tag="label.for">metaFieldGroup.name</content>
                                <g:textField class="field" name="name" value="${metaFieldGroup.getDescription()}"/>
                            </g:applyLayout>
                        </div>
                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="metaFieldGroup.label.displayOrder"/></content>
                            <content tag="label.for">metaFieldGroup.displayOrder</content>
                            <g:textField class="field" name="displayOrder" value="${metaFieldGroup?.displayOrder}"/>
                        </g:applyLayout>

                     </div>
                </div>

                <jB:disjointListbox id="vis-cols-multi-sel"
                  left="${availableMetafields}" right="${selectedMetafields}"
                  left-input="available-fields" right-input="selected-fields" 
                  left-header="tabs.head.availablefields" right-header="tabs.head.selectedfields" />

               
                <!-- spacer -->
                <div>
                    &nbsp;<br/>
                </div>

                <div class="buttons">
                    <ul>
                        <li>
                            <a onclick="updateDLValues('vis-cols-multi-sel');$('#metaFieldGroup-edit-form').submit()" class="submit save">
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