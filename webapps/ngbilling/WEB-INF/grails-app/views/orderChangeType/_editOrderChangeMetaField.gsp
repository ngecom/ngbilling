<%@ page import="com.sapienter.jbilling.server.metafields.DataType; com.sapienter.jbilling.server.metafields.EntityType; com.sapienter.jbilling.server.metafields.MetaFieldWS" %>
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

<%--
   Edit page for one meta field. Used by editOrderChangeType.

  @author Alexander Aksenov
--%>
<g:if test="${metaField}">
    <li id="line-${metaFieldIdx}" class="line">
        <span id="metaField-header-desc-${metaFieldIdx}" class="description">
            ${metaField.name}
        </span>
        <span id="metaField-header-datatype-${metaFieldIdx}" class="data-type">${metaField.dataType}</span>
        <span id="metaField-header-mandatory-${metaFieldIdx}" class="mandatory">
            <g:if test="${metaField.mandatory}">
                <g:message code="product.orderLineMetafields.isMandatory"/>
            </g:if>
            <g:else>
                <g:message code="product.orderLineMetafields.notMandatory"/>
            </g:else>
        </span>

        <div style="clear: both;"></div>
    </li>

    <li id="line-${metaFieldIdx}-editor" class="editor">
        <div class="box">
        <g:render template="/metaFields/editMetafield"
                  model="[metaField: metaField, entityType: EntityType.ORDER_LINE,
                          parentId: '', metaFieldIdx: metaFieldIdx]"/>
        </div>

        <div class="btn-row">
            <a class="submit save" onclick="$('#line-${metaFieldIdx}').trigger('click');"><span><g:message
                        code="button.update"/></span></a>
            <a class="submit cancel" onclick="$('#line-${metaFieldIdx}').remove();
                            $('#line-${metaFieldIdx}-editor').remove();"><span><g:message
                                    code="button.remove"/></span></a>
        </div>
    </li>

    <script type="text/javascript">
        <%-- change the  meta field name in the header li when it is changed in the text field --%>
        $('#metaField${metaFieldIdx}\\.name').change(function () {
            $('#metaField-header-desc-${metaFieldIdx}').html($(this).val())
        });

        $('#metaField${metaFieldIdx}\\.mandatory').change(function () {
            $('#metaField-header-mandatory-${metaFieldIdx}').html($(this).is(':checked')
                    ? '<g:message code="product.orderLineMetafields.isMandatory"/>'
                    : '<g:message code="product.orderLineMetafields.notMandatory"/>')
        });

        <%-- change the  meta field name and data type in the header li when the data type is changed --%>
        $('#metaField${metaFieldIdx}\\.dataType').change(function () {
            $('#metaField-header-datatype-${metaFieldIdx}').html($(this).val());

            var visibleFieldId;
            if ($(this).val() == '${DataType.ENUMERATION}' || $(this).val() == '${DataType.LIST}') {
                visibleFieldId = '#field-enumeration${metaFieldIdx}';
                $('#field-enumeration${metaFieldIdx}').show().find('select').prop('disabled', '');
                $('#field-name${metaFieldIdx}').hide().find('input').prop('disabled', 'true');
                $('#field-filename${metaFieldIdx}').hide().find('input').prop('disabled', 'true');
            } else if ($(this).val() == '${DataType.SCRIPT}'){
                visibleFieldId = '#field-filename${metaFieldIdx}';
                $('#field-filename${metaFieldIdx}').show().find('input').prop('disabled', '');
                $('#field-enumeration${metaFieldIdx}').hide().find('select').prop('disabled', 'true');
                $('#field-name${metaFieldIdx}').hide().find('input').prop('disabled', 'true');
            } else {
                visibleFieldId = '#field-name${metaFieldIdx}';
                $('#field-name${metaFieldIdx}').show().find('input').prop('disabled', '');
                $('#field-enumeration${metaFieldIdx}').hide().find('select').prop('disabled', 'true');
                $('#field-filename${metaFieldIdx}').hide().find('input').prop('disabled', 'true');
            }

            $('#metaField-header-desc-${metaFieldIdx}').html($(visibleFieldId + ' #metaField${metaFieldIdx}\\.name').val())
        });

        <%-- Enable the drop down effect when user clicks the header line --%>
        $('#line-${metaFieldIdx}').click(function () {
            var id = $(this).attr('id');
            $('#' + id).toggleClass('active');
            $('#' + id + '-editor').toggle('blind');
        });
    </script>
</g:if>