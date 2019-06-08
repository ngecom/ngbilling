<%@ page import="com.sapienter.jbilling.server.metafields.validation.ValidationRuleType; org.apache.commons.lang.WordUtils; com.sapienter.jbilling.server.util.db.EnumerationDTO; com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.metafields.DataType;com.sapienter.jbilling.server.metafields.MetaFieldType" %>
%{--
  jBilling - The Enterprise Open Source Billing System
  Copyright (C) 2003-2013 Enterprise jBilling Software Ltd. and Emiliano Conde

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
  Metafield edit template

  Parameters to be passed to this template:

  1. metaField - MetaFieldWS managed by this template
  2. entityType - entity Type of the metaField
  3. parentId - Id of the parent submit form
  4. metaFieldIdx - (optional) Used when rendering multiple instances of the template in order to provide an unique
        name for input fields. The metaFieldIdx will be appended to all names
  5. allowTypeEditing - (optional) If true the user will be able edit the meta field even though it has been saved.
  6. displayMetaFieldType - (optional) If false the MetaField Type selection will not be displayed

  @author Panche Isajeski
  @since 05/24/2013
--%>

<g:set var="isNew" value="${!metaField || !metaField?.id || metaField?.id == 0}"/>
<g:set var="metaFieldIdx" value="${metaFieldIdx!=null ?metaFieldIdx: ''}"/>
<g:set var="allowTypeChange" value="${allowTypeEditing}" />
<g:set var="displayMetaFieldType" value="${displayMetaFieldType!=null ? displayMetaFieldType : false}" />

<!-- metafield template -->
<div id="metaFieldModel${metaFieldIdx}" class="form-columns">
    <div class="column">
        <g:hiddenField name="entityType${metaFieldIdx}" value="${isNew ? params.entityType : metaField?.entityType?.name()}"/>
        <g:hiddenField name="metaField${metaFieldIdx}.primary" value="${metaField?.primary}"/>

        <g:applyLayout name="form/text">
            <content tag="label"><g:message code="metaField.label.id"/></content>

            <g:if test="${!isNew}">
                <span>${metaField.id}</span>
            </g:if>
            <g:else>
                <em><g:message code="prompt.id.new"/></em>
            </g:else>

            <g:hiddenField name="metaField${metaFieldIdx}.id" value="${metaField?.id}"/>
        </g:applyLayout>

        <div id="field-name${metaFieldIdx}" class="field-name" >
            <g:applyLayout name="form/input">
                <content tag="label"><g:message code="metaField.label.name"/><span id="mandatory-meta-field">*</span></content>
                <content tag="label.for">metaField${metaFieldIdx}.name</content>
                <g:textField class="field" name="metaField${metaFieldIdx}.name" value="${metaField?.name}"/>
            </g:applyLayout>
        </div>
        <div id="field-enumeration${metaFieldIdx}" style="display: none;" class="field-enumeration">
            <g:applyLayout name="form/select">
                <content tag="label"><g:message code="metaField.label.name"/></content>
                <content tag="label.for">name</content>
                <g:select name="metaField${metaFieldIdx}.name" class="field"
                          from="${EnumerationDTO.findAllByEntity(new CompanyDTO(session['company_id']))}"
                          value="${metaField?.name}"
                          optionKey="name"
                          disabled="true"
                          optionValue="name"/>
            </g:applyLayout>
        </div>

        <g:applyLayout name="form/select">
            <content tag="label"><g:message code="metaField.label.dataType"/></content>
            <content tag="label.for">metaField${metaFieldIdx}.dataType</content>
            <g:set var="dataTypes" value="${DataType.values()}"/>
            <g:select
                    disabled="${!isNew && !allowTypeChange}"
                    class="field"
                    name="metaField${metaFieldIdx}.dataType"
                    from="${dataTypes}"
                    value="${metaField?.dataType}" />
            <g:if test="${!isNew && !allowTypeChange}">
                <g:hiddenField name="metaField${metaFieldIdx}.dataType" value="${metaField?.dataType}"/>
            </g:if>
        </g:applyLayout>

        <div id="field-filename${metaFieldIdx}" class="field-filename" >
            <g:applyLayout name="form/input" >
                <content tag="label"><g:message code="metaField.label.filename"/></content>
                <content tag="label.for">metaField${metaFieldIdx}.filename</content>
                <g:textField class="field" name="metaField${metaFieldIdx}.filename" value="${metaField?.filename}" />
            </g:applyLayout>
        </div>

		<g:applyLayout name="form/checkbox">
            <content tag="label"><g:message code="metaField.label.unique"/></content>
            <content tag="label.for">uniqueCheck</content>
            <g:checkBox class="cb checkbox" id="uniqueCheck" name="metaField${metaFieldIdx}.unique" checked="${metaField?.unique}"/>
        </g:applyLayout>
        
        <g:applyLayout name="form/checkbox">
            <content tag="label"><g:message code="metaField.label.mandatory"/></content>
            <content tag="label.for">mandatoryCheck</content>
            <g:checkBox class="cb checkbox" id="mandatoryCheck" name="metaField${metaFieldIdx}.mandatory" checked="${metaField?.mandatory}"/>
        </g:applyLayout>

        <g:applyLayout name="form/checkbox">
            <content tag="label"><g:message code="metaField.label.disabled"/></content>
            <content tag="label.for">disableCheck</content>
            <g:checkBox class="cb checkbox" id="disableCheck" name="metaField${metaFieldIdx}.disabled" checked="${metaField?.disabled}"/>
        </g:applyLayout>

        <g:applyLayout name="form/input">
            <content tag="label"><g:message code="metaField.label.displayOrder"/></content>
            <content tag="label.for">metaField${metaFieldIdx}.displayOrder</content>
            <g:textField class="field" name="metaField${metaFieldIdx}.displayOrder" value="${metaField?.displayOrder}"/>
        </g:applyLayout>

        <g:applyLayout name="form/input">
            <content tag="label"><g:message code="metaField.label.defaultValue"/></content>
            <content tag="label.for">defaultValue${metaFieldIdx}</content>
            <g:textField class="field" name="defaultValue${metaFieldIdx}" value="${metaField?.defaultValue?.value}"/>
        </g:applyLayout>
    </div>

    <div class="column">
        <div id="field-enumeration" style="">
            <g:if test="${displayMetaFieldType}" >
                <g:applyLayout name="form/select">
                    <content tag="label"><g:message code="metaField.label.fieldType"/></content>
                    <content tag="label.for">fieldType${metaFieldIdx}</content>
                    <g:set var="fieldTypes" value="${MetaFieldType.values()}"/>
                    <g:select style="height: 20px"
                            class="field"
                            name="fieldType${metaFieldIdx}"
                            from="${fieldTypes}"
                            value="${metaField?.fieldUsage}" />

                </g:applyLayout>
            </g:if>
        <!-- TODO (pai) Add option to reset field usage selection -->
        </div>

    </div>
</div>

<g:render id="validationTemplate" template="/metaFields/validation/validation" model="[validationRule: metaField?.validationRule, parentId: parentId, metaFieldIdx: metaFieldIdx, enabled: metaField?.validationRule?true:false]"/>
<script>
    $(document).ready(function() {
        $('#disableCheck').on('click', function(){
            var mandatory=$("#mandatoryCheck")
            if ($(this).is(':checked')) {
                mandatory.attr('checked', false);
                mandatory.attr('disabled', true);
            }else {
                mandatory.attr('disabled', false);
            }
        });
    });
</script>
