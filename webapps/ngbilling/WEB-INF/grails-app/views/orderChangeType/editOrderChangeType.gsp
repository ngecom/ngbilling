<%@ page import="com.sapienter.jbilling.server.metafields.DataType; com.sapienter.jbilling.server.metafields.MetaFieldWS; com.sapienter.jbilling.server.metafields.EntityType; com.sapienter.jbilling.server.metafields.db.MetaFieldDAS" %>
%{--
  JBILLING CONFIDENTIAL
  _____________________

  [2003] - [2014] Enterprise jBilling Software Ltd.
  All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Enterprise jBilling Software.
  The intellectual and technical concepts contained
  herein are proprietary to Enterprise jBilling Software
  and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden.
  --}%

<html>
<head>
    %{--<meta name="layout" content="configuration"/>--}%
    <meta name="layout" content="main"/>
    <r:require module="errors" />
</head>

<body>
<!-- selected configuration menu item -->
<content tag="menu.item">orderChangeTypes</content>


<div class="form-edit">
    <g:set var="isNew" value="${!orderChangeType || !orderChangeType?.id || orderChangeType?.id == 0}"/>

    <div class="heading">
        <strong>
            <g:if test="${isNew}">
                <g:message code="config.orderChangeTypes.period.add.title"/>
            </g:if>
            <g:else>
                <g:message code="config.orderChangeTypes.period.edit.title"/>
            </g:else>
        </strong>
    </div>

    <div class="form-hold">
        <g:form id="save-orderChangeType-form" name="order-change-period-form" url="[action: 'save']">
            <input type="hidden" name="isNew" value="${isNew}">

            <div class="box">
                <div class="sub-box">
                    <fieldset>
                        <div class="form-columns">
                            <g:hiddenField name="id" value="${orderChangeType?.id}"/>

                            <g:applyLayout name="form/input">
                                <content tag="label"><g:message code="orderChangeType.name"/></content>
                                <content tag="label.for">name</content>
                                <g:textField class="field" name="name" value="${orderChangeType?.name}"/>
                            </g:applyLayout>

                            <g:applyLayout name="form/checkbox">
                                <content tag="label"><g:message code="orderChangeType.defaultType"/></content>
                                <content tag="label.for">defaultType_checkbox</content>
                                <g:checkBox class="cb checkbox" name="defaultType" id="defaultType_checkbox"
                                            checked="${orderChangeType?.defaultType}"
                                            onchange="disableItemTypesSelect();"/>
                            </g:applyLayout>

                            <g:applyLayout name="form/select">
                                <content tag="label"><g:message code="orderChangeType.itemTypes"/></content>
                                <content tag="label.for">itemTypes</content>
                                <g:select name="itemTypes" from="${itemTypes}" multiple="true" id="itemTypes_selector"
                                          optionKey="id" optionValue="${{it.description + ' (Id: ' + it.id + ')'}}"
                                          value="${orderChangeType.itemTypes}"
                                          disabled="${orderChangeType?.defaultType}"/>
                            </g:applyLayout>

                            <g:applyLayout name="form/checkbox">
                                <content tag="label"><g:message
                                        code="orderChangeType.allowOrderStatusChange"/></content>
                                <content tag="label.for">allowOrderStatusChange</content>
                                <g:checkBox class="cb checkbox" name="allowOrderStatusChange"
                                            checked="${orderChangeType?.allowOrderStatusChange}"/>
                            </g:applyLayout>
                        </div>
                    </fieldset>
                </div>
            </div>

            <div id="orderChangeMetaFields"
                 class="box-cards ${orderChangeType?.id > 0 || orderChangeType?.orderChangeTypeMetaFields?.size() > 0 ? 'box-cards-open' : ''}">
                <div class="box-cards-title">
                    <a class="btn-open" href="#"><span><g:message
                            code="orderChangeType.orderChangeMetafields"/></span></a>
                </div>

                <div class="box-card-hold">
                    <%-- buttons to add empty meta field or from templates  class="type-metafield-menu" --%>
                    <div class="type-metafield-header">

                        <div class="btn-row">
                            <span class="type-metafield-menu">

                                <label for="metaFieldTemplate.id"><g:message
                                        code="orderChangeType.orderChangeMetafields.import"/></label>
                                <g:select name="metaFieldTemplate.id" id="metaFieldTemplate-id" class="field"
                                          from="${new MetaFieldDAS().getAvailableFields(session['company_id'], [EntityType.ORDER_CHANGE] as EntityType[], true)}"
                                          optionKey="id"
                                          optionValue="name"/>

                                <a onclick="${remoteFunction(action: 'populateOrderChangeMetaFieldForEdit',
                                        update: [success: 'meta-field-load-target', failure: 'meta-field-load-target'],
                                        onComplete: 'moveMetaFieldsFromTemplate()',
                                        params: '\'mfId=\' + $(\'#metaFieldTemplate-id\').val() + \'&startIdx=\' + (metaFieldIdx+1) + \'&entityType=' + EntityType.ORDER_CHANGE + '\'')}">
                                    <img src="${resource(dir: 'images', file: 'add.png')}" alt="add"/>
                                </a>
                            </span>

                            <a onclick="addMetaField();" class="submit add" style="width: 150px;"><span><g:message
                                    code="button.add.new.metaField"/></span></a>
                        </div>
                    </div>

                    <div>
                        <ul id="orderChange-metafield-lines">
                            <% params.entityType = com.sapienter.jbilling.server.metafields.EntityType.ORDER_CHANGE.name(); %>
                            <g:render template="editOrderChangeMetaFieldsCollection"
                                      model="[metaFields: orderChangeType.orderChangeTypeMetaFields, startIdx: 1]"/>
                        </ul>
                    </div>
                </div>

                <!-- spacer -->
                <div>
                    <br/>&nbsp;
                </div>

            </div>
        </g:form>
    </div>

    <div class="buttons">
        <ul>
            <li><a class="submit save" onclick="$('#save-orderChangeType-form').submit();"><span><g:message
                    code="button.save"/></span></a></li>
            <li><g:link action="list" class="submit cancel"><span><g:message code="button.cancel"/></span></g:link></li>
        </ul>
    </div>
</div>

<%-- meta fields from groups or already created ones are loaded here before being moved into the list --%>
<div id="meta-field-load-target" style="display: none">
</div>

<%-- template used to create empty meta fields--%>
<div id="meta-field-template" style="display: none">
    <li id="line-_mfIdx_" class="line active">
        <span id="metaField-header-desc-_mfIdx_" class="description">-</span>
        <span id="metaField-header-datatype-_mfIdx_" class="data-type">-</span>
        <span id="metaField-header-mandatory-_mfIdx_" class="mandatory"><g:message code="product.orderLineMetafields.notMandatory"/></span>
        <div style="clear: both;"></div>
    </li>

    <li id="line-_mfIdx_-editor" class="editor open">
        <% params.entityType = com.sapienter.jbilling.server.metafields.EntityType.PRODUCT.name(); %>
        <div class="box">
            <g:render template="/metaFields/editMetafield"
                       model="[metaField: new MetaFieldWS(), entityType: EntityType.PRODUCT,
                               parentId: '', metaFieldIdx: '_mfIdx_']"/>
        </div>
        <div class="btn-row">
            <a class="submit save" onclick="$('#line-_mfIdx_').trigger('click');"><span><g:message
                    code="button.update"/></span></a>
            <a class="submit cancel" onclick="$('#line-_mfIdx_').remove();
                                $('#line-_mfIdx_-editor').remove();"><span><g:message
                                        code="button.remove"/></span></a>
        </div>
    </li>
</div>
</body>
<r:script>

    <%-- move meta fields loaded from template to the list of editable meta fields--%>
    function moveMetaFieldsFromTemplate() {
        var metaFields = $("#meta-field-load-target").children().detach();
        metaFieldIdx += metaFields.length;
        $("#orderChange-metafield-lines").append(metaFields);
    }

    var metaFieldIdx = ${1 + (orderChangeType.orderChangeTypeMetaFields != null ? orderChangeType.orderChangeTypeMetaFields.size() : 0)};

    <%-- Add a new empty meta field line to the table --%>
    function addMetaField() {
        metaFieldIdx ++;
        <%-- Clone the template --%>
        var template = $("#meta-field-template").clone().html().replace(/_mfIdx_/g, metaFieldIdx);
        $("#orderChange-metafield-lines").append(template);


        <%-- Display the correct input depending if the type is list or enumeration --%>
        $('#metaField'+metaFieldIdx+'\\.dataType').change(function () {
            var idx = $(this).prop('id').substring(9, $(this).prop('id').length - 9);
            $('#metaField-header-datatype-'+idx).html($(this).val());

            var visibleFieldId;
            if ($(this).val() == '${DataType.ENUMERATION}' || $(this).val() == '${DataType.LIST}') {
                $('#field-name'+idx).hide().find('input').prop('disabled', 'true');
                $('#field-enumeration'+idx).show().find('select').prop('disabled', '');
                $('#field-filename'+idx).hide().find('input').prop('disabled', 'true')
                visibleFieldId = '#field-enumeration'+idx;
            } else if ($(this).val() == '${DataType.SCRIPT}'){
                $('#field-name'+idx).show().find('input').prop('disabled', '');
                $('#field-enumeration'+idx).hide().find('select').prop('disabled', 'true');
                $('#field-filename'+idx).show().find('input').prop('disabled', '')
                visibleFieldId = '#field-filename'+idx;
            } else {
                $('#field-name'+idx).show().find('input').prop('disabled', '');
                $('#field-enumeration'+idx).hide().find('select').prop('disabled', 'true');
                $('#field-filename'+idx).hide().find('input').prop('disabled', 'true')
                visibleFieldId = '#field-name'+idx;
            }
            var newName = $(visibleFieldId + ' #metaField'+idx+'\\.name').val();
            if(newName == '') {
                newName = '-';
            }
            $('#metaField-header-desc-'+idx).html(newName)
        }).change();

        <%-- Set the header to the name of the meta field --%>
        $('#metaField'+metaFieldIdx+'\\.name').change(function () {
            var idx = $(this).prop('id').substring(9, $(this).prop('id').length - 5);
            $('#metaField-header-desc-'+idx).html($(this).val())
        });

        <%-- Set mandatory depending on the checkbox--%>
        $('#metaField'+metaFieldIdx+'\\.mandatory').change(function () {
            var idx = $(this).prop('id').substring(9, $(this).prop('id').length - 10);
            $('#metaField-header-mandatory-'+idx).html($(this).is(':checked')
                                ? '<g:message code="orderChangeType.orderChangeTypeMetaFields.isMandatory"/>'
                                : '<g:message code="orderChangeType.orderChangeTypeMetaFields.notMandatory"/>')
        });

        <%-- enable drop down effect when user clicks on a row header --%>
        $('#line-'+metaFieldIdx).click(function() {
            var id = $(this).attr('id');
            $('#' + id).toggleClass('active');
            $('#' + id + '-editor').toggle('blind');
        });
    }

    function disableItemTypesSelect() {
        $("#itemTypes_selector").prop('disabled', $("#defaultType_checkbox").prop("checked"));
    }

</r:script>
</html>