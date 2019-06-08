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

    @author Shweta Gupta
--%>

<%@ page import="com.sapienter.jbilling.server.metafields.validation.ValidationRuleType" %>
<div class="column">
    <g:applyLayout name="form/select">
        <content tag="label"><g:message code="validation.rule.type"/></content>
        <content tag="label.for">metaField${metaFieldIdx}.validationRule.ruleType</content>
        <g:select name="metaField${metaFieldIdx}.validationRule.ruleType"
                  id="metaField${metaFieldIdx}.validationRule.ruleType"
                  class="validation-type"
                  from="${types}"
                  valueMessagePrefix="validation.rule.type"
                  value="${validationRule?.ruleType ? ValidationRuleType.valueOf(validationRule?.ruleType) : null}"
                  noSelection="['': message(code: 'default.no.selection')]"/>

    </g:applyLayout>
    <g:render template="/metaFields/validation/validationAttributes" model="[validationRule: validationRule, metaFieldIdx: metaFieldIdx, validationType : validationType]"/>
</div>

<div class="column">
    <g:if test="${validationRule?.enabled}">
        <g:render template="/metaFields/validation/errorDescriptions" model="[validationRule: validationRule, parentId: parentId, metaFieldIdx : metaFieldIdx]"/>
    </g:if>
</div>
