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

<%@ page import="com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.util.db.EnumerationDTO" %>

<g:set var="enumerations" value="${EnumerationDTO.createCriteria().list(){eq('entity', new CompanyDTO(session['company_id']))}}"/>
<g:set var="enumValues" value="${null}"/>
<%
    for (EnumerationDTO dto : enumerations) {
        if (dto.name == field.getName()) {
            enumValues= []
            enumValues.addAll(dto.values.collect {it.value})
        }
    }
%>
<g:applyLayout name="form/select">
    <content tag="label"><g:message code="${field.name}"/><g:if test="${field.mandatory}"><span id="mandatory-meta-field">*</span></g:if></content>
    <content tag="label.for">metaField_${field.id}.value</content>
    <g:select
            class="field ${validationRules}"
            name="metaField_${field.id}.value"
            from="${enumValues}"
            optionKey=""
            value="${fieldValue}"
            multiple="true"/>
</g:applyLayout>