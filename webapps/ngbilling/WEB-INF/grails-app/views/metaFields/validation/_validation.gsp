<%@ page import="com.sapienter.jbilling.server.metafields.validation.ValidationRuleType; org.apache.commons.lang.WordUtils; com.sapienter.jbilling.server.util.db.EnumerationDTO; com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.metafields.DataType;com.sapienter.jbilling.server.metafields.MetaFieldType" %>
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
  Validation rule model

  Parameters to be passed to this template:

  1. validationRule - Validation Rule
  2. parentId - Id of the parent submit form
  3. metaFieldIdx - (optional) Used when rendering multiple instances of the template in order to provide an unique
        name for input fields. The metaFieldIdx will be appended to all names

  @author Panche Isajeski, Shweta Gupta
--%>

<g:set var="types" value="${com.sapienter.jbilling.server.metafields.validation.ValidationRuleType.values() as java.util.List}"/>
<g:set var="validationType" value="${validationRule?.ruleType ? ValidationRuleType.valueOf(validationRule?.ruleType) : types?.first()}"/>

<div id="metaField${metaFieldIdx}.validationModel" class="form-columns">
    <g:hiddenField name="metaFieldIdx" value="${metaFieldIdx}"/>
    <g:hiddenField name="metaField${metaFieldIdx}.validationRule.enabled" value="${enabled}"/>
    <g:hiddenField name="metaField${metaFieldIdx}.validationRule.id" value="${validationRule?.id}"/>
    <g:render template="/metaFields/validation/validationRule" model="[validationRule: validationRule, metaFieldIdx: metaFieldIdx, validationType : validationType, types: types, parentId: parentId]"/>
</div>


<script type="text/javascript">

    $(function() {
        $('[name="metaField${metaFieldIdx}.validationRule.ruleType"]').change(function() {
            var val  = $("[name='metaField${metaFieldIdx}.validationRule.ruleType']").attr('value');
            if(val==null || val==""){
                $("[name='metaField${metaFieldIdx}.validationRule.enabled']").attr('value', false);
            } else {
                $("[name='metaField${metaFieldIdx}.validationRule.enabled']").attr('value', true);
            }
            updateValidationModel${metaFieldIdx}();
        });
    });

    function updateValidationModel${metaFieldIdx}() {
        var $parentForm = $('div[id="metaField${metaFieldIdx}.validationModel"] :input');
        $.ajax({
            type: 'POST',
            url: '${createLink(controller:'metaFields', action: 'updateValidationModel')}',
            data: $parentForm.serialize(),
            success: function(data) { $('div[id="metaField${metaFieldIdx}.validationModel"]').replaceWith(data); }
        });
    }

</script>