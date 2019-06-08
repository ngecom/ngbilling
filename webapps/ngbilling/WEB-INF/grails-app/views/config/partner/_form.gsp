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

<%@ page import="com.sapienter.jbilling.server.process.db.PeriodUnitDTO; com.sapienter.jbilling.server.util.db.CountryDTO" %>
<%@ page import="com.sapienter.jbilling.server.util.db.CurrencyDTO" %>
<%@ page import="com.sapienter.jbilling.server.util.db.LanguageDTO" %>
<%@ page import="com.sapienter.jbilling.server.user.contact.db.ContactMapDTO" %>


<div class="form-edit">
    <div class="heading">
        <strong><g:message code="configuration.menu.partner"/>
        </strong>
    </div>

    <div class="form-hold">
        <g:form name="saveCommissionConfig" action="saveCommissionConfig">
            <!-- company details -->
            <fieldset>
                <div class="form-columns" style="margin-bottom: 10px;">
                    <div class="column">
                        <div class="row">
                            <g:applyLayout name="form/date">
                                <content tag="label"><g:message code="billing.next.run.date"/></content>
                                <content tag="label.for">nextRunDate</content>
                                <g:textField class="field" name="nextRunDate"
                                             value="${formatDate(date: configuration?.nextRunDate, formatName: 'datepicker.format')}"
                                             onblur="validateDate(this)"/>
                            </g:applyLayout>
                        </div>

                        <div class="row">
                            <g:applyLayout name="form/input">
                                <content tag="label"><g:message code="order.label.period"/></content>
                                <content tag="label.for">periodValue</content>
                                <g:textField class="field numericOnly" name="periodValue"
                                             value="${configuration?.periodValue}" maxlength="2" size="2"/>
                                <g:select style="float: right; position: relative; top: -20px;width:70px" class="field"
                                          name="periodUnitId" from="${PeriodUnitDTO.list()}"
                                          optionKey="id" optionValue="description"
                                          value="${configuration?.periodUnitId}"/>
                            </g:applyLayout>
                        </div>
                    </div>
                </div>
            </fieldset>

            <div class="btn-box" style="margin-bottom: 10px;">
                <a onclick="$('#saveCommissionConfig').submit();" class="submit save"><span><g:message
                        code="button.save"/></span></a>
                <g:link controller="config" action="index" class="submit cancel"><span><g:message
                        code="button.cancel"/></span></g:link>
                <g:link controller="config" action="triggerCommissionProcess" class="submit apply"><span><g:message
                        code="button.run.commissionProcess"/></span></g:link>
            </div>
        </g:form>
    </div>
</div>
