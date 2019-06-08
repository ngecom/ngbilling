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
  @since  30-Sept-2011
--%>

<div class="column-hold">
    
    <g:set var="isNew" value="${!period || !period?.id || period?.id == 0}"/>
    
    <div class="heading">
        <strong>
            <g:if test="${isNew}">
                <g:message code="period.add.title"/>
            </g:if>
            <g:else>
                <g:message code="period.edit.title"/>
            </g:else>
        </strong>
    </div>

    <g:form id="save-period-form" name="order-period-form" url="[action: 'save']" >
    <input type="hidden" name="isNew" value="${isNew}">
    <div class="box">
        <div class="sub-box">
          <fieldset>
            <div class="form-columns">
                <g:hiddenField name="id" value="${period?.id}"/>

                <g:applyLayout name="form/input">
                    <content tag="label"><g:message code="orderPeriod.description"/><span id="mandatory-meta-field">*</span></content>
                    <content tag="label.for">description</content>
                    <g:textField class="field" name="description" value="${periodWS?periodWS.getDescription(session['language_id'])?.content:period?.getDescription(session['language_id'])}"/>
                </g:applyLayout>

                <g:applyLayout name="form/select">
                    <content tag="label"><g:message code="orderPeriod.unit"/></content>
                    <content tag="label.for">periodUnit</content>
                    <g:select from="${periodUnits}"
                              optionKey="id"
                              optionValue="${{it.getDescription(session['language_id'])}}"
                              name="periodUnitId"
                              value="${periodWS?periodWS.periodUnitId:period?.periodUnit?.id}"/>
                </g:applyLayout>

                <g:applyLayout name="form/input">
                    <content tag="label"><g:message code="orderPeriod.value"/><span id="mandatory-meta-field">*</span></content>
                    <content tag="label.for">periodValue</content>
                    <g:textField class="field" name="value" value="${periodWS?periodWS.value:period?.value}"/>
                </g:applyLayout>
                
            </div>
        </fieldset>
      </div>
    </div>

    </g:form>

    <div class="btn-box buttons">
        <ul>
            <li><a class="submit save" onclick="$('#save-period-form').submit();"><span><g:message code="button.save"/></span></a></li>
            <li><a class="submit cancel" onclick="closePanel(this);"><span><g:message code="button.cancel"/></span></a></li>
        </ul>
    </div>
</div>