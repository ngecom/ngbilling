<%@ page import="com.sapienter.jbilling.common.CommonConstants; org.apache.commons.lang.StringUtils; com.sapienter.jbilling.server.metafields.DataType" %>
<%@ page import="com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.util.db.EnumerationDTO; org.apache.commons.lang.WordUtils" %>

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
  View template for rendering meta-field input's to create and update meta-field values..

  <g:render template="/metaFields/editMetaFields" model="[availableFields: availableFields, fieldValues: object.metaFields]"/>

  @author Brian Cowdery
  @since 26-Oct-2011
--%>

<g:each var="field" in="${availableFields?.sort{ it.displayOrder }}">
    <g:set var="templateName" value="${WordUtils.uncapitalize(WordUtils.capitalizeFully(field.getDataType().name(), ['_'] as char[]).replaceAll('_',''))}"/>
    <g:if test="${!field.disabled}">
        <g:set var="fieldName" value="${StringUtils.abbreviate(message(code: field.name), 50)}"/>
        <g:set var="fieldValue" value="${fieldValues?.find{ (it.fieldName == field.name) &&
                ((it.groupId && groupId && it.groupId == groupId) || (!it.groupId && !groupId)) }?.getValue()}"/>
        <g:if test="${fieldValue == null && field.getDefaultValue()}">
            <g:set var="fieldValue" value="${field.getDefaultValue().getValue()}"/>
        </g:if>
        <g:elseif test="${g.ifValuePresent(field:field,fieldsArray: fieldsArray)}">
            <g:set var="fieldValue" value="${g.setFieldValue(field:field, fieldsArray:fieldsArray)}"/>
        </g:elseif>
        <g:if test="${fieldName == CommonConstants.METAFIELD_NAME_CC_NUMBER}">
            <g:if test="${!user?.id || user?.id < 0 || !fieldValues?.getAt(0)?.id || fieldValues?.getAt(0)?.id == null}">
                <g:set var="fieldValue" value="${fieldValue}"/>
            </g:if>
            <g:elseif test="${user?.id > 0}">
                <g:set var="fieldValue" value="${fieldValue?.replaceAll('^\\d{12}','************')}"/>
            </g:elseif>
        </g:if>
        
        <g:render id="dataTypeTemplate" template="/metaFields/dataType/${templateName}" model="[
               field: field, fieldName: fieldName, fieldValue: fieldValue,
               validationRules: validationRules]"/>
               
    </g:if>
</g:each>
