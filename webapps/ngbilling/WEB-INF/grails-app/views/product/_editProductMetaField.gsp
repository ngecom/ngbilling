<%@ page import="com.sapienter.jbilling.server.metafields.DataType; com.sapienter.jbilling.server.metafields.EntityType; com.sapienter.jbilling.server.metafields.MetaFieldWS" %>
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

<%--
   Edit page for one meta field. Used by editProduct.

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