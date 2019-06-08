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

<%@ page import="org.apache.commons.lang.StringUtils; com.sapienter.jbilling.server.pricing.cache.MatchType; com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.item.db.ItemDTO;" %>
<%@ page import="com.sapienter.jbilling.server.metafields.validation.ValidationRuleType"%>

<%--
  Editor form for validation model attributes

  Parameters to be passed to this template:

  1. validationRule - Validation Rule
  2. metaFieldIdx - (optional) Used when rendering multiple instances of the template in order to provide an unique
        name for input fields.

  @author Panche Isajeski, Shweta Gupta
--%>

<g:set var="attributeIndex" value="${0}"/>
<g:set var="attrs" value="${validationRule?.ruleAttributes ? new TreeMap<String, String>(validationRule.ruleAttributes) : new TreeMap<String, String>()}"/>

<!-- all validation rule attribute definitions -->
<g:each var="definition" in="${validationRule?.ruleType ? ValidationRuleType.valueOf(validationRule?.ruleType)?.validationRuleModel?.attributeDefinitions : null }">
    <g:set var="attributeIndex" value="${attributeIndex + 1}"/>

    <g:set var="attribute" value="${attrs?.remove(definition?.name)}"/>

    <g:applyLayout name="form/input">
        <content tag="label"><g:message code="${definition.name}"/></content>
        <content tag="label.for">metaField${metaFieldIdx}.validationRule.ruleAttributes.${attributeIndex}.value</content>

        <g:hiddenField name="metaField${metaFieldIdx}.validationRule.ruleAttributes.${attributeIndex}.name" value="${definition?.name}"/>
        <g:textField class="field" name="metaField${metaFieldIdx}.validationRule.ruleAttributes.${attributeIndex}.value"
                     value="${attribute}"/>
    </g:applyLayout>
</g:each>

