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

<%@ page contentType="text/html;charset=UTF-8" %>

<%--
  Shows edit form for a contact type.

  @author Vikas Bodani
  @since  3-Oct-2011
--%>

<div class="column-hold">
    
    <g:set var="isNew" value="${!type || !type?.id || type?.id == 0}"/>
    
    <div class="heading">
        <strong>
            <g:if test="${isNew}">
                <g:message code="contact.field.type.add.title"/>
            </g:if>
            <g:else>
                <g:message code="contact.field.type.edit.title"/>
            </g:else>
        </strong>
    </div>

    <g:form id="save-type-form" name="field-type-form" url="[action: 'save']">

    <div class="box">
      <div class="sub-box">
        <fieldset>
            <div class="form-columns">
                <g:hiddenField name="id" value="${type?.id}"/>
                <g:hiddenField name="promptKey" value="${type?.promptKey}"/>
                
                <g:applyLayout name="form/input">
                    <content tag="label"><g:message code="contact.field.description"/></content>
                    <content tag="label.for">description</content>
                    <g:textField class="field" name="description" value="${type?.getDescription(session['language_id'])}"/>
                </g:applyLayout>

                <g:applyLayout name="form/select">
                    <content tag="label"><g:message code="contact.field.datatype"/></content>
                    <content tag="label.for">dataType</content>
                    <g:select from="${dataTypeList}"
                              name="dataType"
                              value="${type?.dataType}"/>
                </g:applyLayout>

                <g:applyLayout name="form/checkbox">
                    <content tag="label"><g:message code="contact.field.isReadOnly"/></content>
                    <content tag="label.for">readOnly</content>
                    <g:checkBox class="cb checkbox" name="readOnly" checked="${type?.readOnly > 0}"/>
                </g:applyLayout>
                
                
                <g:applyLayout name="form/checkbox">
                    <content tag="label"><g:message code="contact.field.displayInView"/></content>
                    <content tag="label.for">displayInView</content>
                    <g:checkBox class="cb checkbox" name="displayInView" checked="${type?.displayInView > 0}"/>
                </g:applyLayout>
                
            </div>
        </fieldset>
      </div>
    </div>

    </g:form>

    <div class="btn-box buttons">
        <ul>
            <li><a class="submit save" onclick="$('#save-type-form').submit();"><span><g:message code="button.save"/></span></a></li>
            <li><a class="submit cancel" onclick="closePanel(this);"><span><g:message code="button.cancel"/></span></a></li>
        </ul>
    </div>
</div>