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
  Shows edit form for Mediation Configuration.

  @author Vikas Bodani
  @since  05-Oct-2011
--%>

<div class="column-hold">
    
    <g:set var="isNew" value="${!config || !config?.id || config?.id == 0}"/>
    
    <div class="heading">
        <strong>
            <g:if test="${isNew}">
                <g:message code="mediation.config.add.title"/>
            </g:if>
            <g:else>
                <g:message code="mediation.config.edit.title"/>
            </g:else>
        </strong>
    </div>

    <g:form id="save-config-form" name="mediation-config-form" url="[action: 'save']">

    <div class="box">
        <fieldset>
            <div class="form-columns">
                <g:hiddenField name="id" value="${config?.id?:0}"/>
                <g:hiddenField name="entityId" value="${session['company_id']}"/>
                <g:hiddenField name="createDatetime" value="${config?.createDatetime?: null}"/>
                <g:hiddenField name="versionNum" value="${config?.versionNum?: 0}"/>
                
                <g:applyLayout name="form/input">
                    <content tag="label"><g:message code="mediation.config.name"/></content>
                    <content tag="label.for">name</content>
                    <g:textField class="field" name="name" value="${config?.name}"/>
                </g:applyLayout>

                <g:applyLayout name="form/select">
                    <content tag="label"><g:message code="mediation.config.plugin"/></content>
                    <content tag="label.for">pluggableTaskId</content>
                    <g:select from="${readers}"
                              optionKey="id"
                              optionValue="${{'(Id:' + it.id + ') ' + it.type?.getDescription(session['language_id'])}}"
                              name="pluggableTaskId"
                              value="${config?.pluggableTask?.id}"/>
                </g:applyLayout>

                <g:applyLayout name="form/input">
                    <content tag="label"><g:message code="mediation.config.order"/></content>
                    <content tag="label.for">orderValue</content>
                    <g:textField class="field" name="orderValue" value="${config?.orderValue}"/>
                </g:applyLayout>
                
            </div>
        </fieldset>
    </div>

    </g:form>

    <div class="btn-box buttons">
        <ul>
            <li><a class="submit save" onclick="$('#save-config-form').submit();"><span><g:message code="button.save"/></span></a></li>
            <li><a class="submit cancel" onclick="closePanel(this);"><span><g:message code="button.cancel"/></span></a></li>
        </ul>
    </div>
</div>