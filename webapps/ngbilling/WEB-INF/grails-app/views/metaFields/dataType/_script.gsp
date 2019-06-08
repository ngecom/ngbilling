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

<g:if test="${field.filename}">
    <jB:templateExists var="templateExists" template="/metaFields/script/${field.filename}" />

    <g:if test="${templateExists}">
        <g:render template="/metaFields/script/${field.filename}" model="[
                field: field, fieldName: fieldName,
                fieldValue: fieldValue, validationRules: validationRules]"/>
    </g:if>
    <g:else>
        <g:message code="metafield.validation.file.not.exist"
                   args="${["/metaFields/script/_${field.filename}.gsp"]}"/>
    </g:else>
</g:if>
<g:else>
    <g:message code="metafield.validation.filename.not.defined" />
</g:else>