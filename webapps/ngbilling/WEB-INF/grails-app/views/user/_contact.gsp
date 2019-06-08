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

<%@ page import="com.sapienter.jbilling.server.util.db.CountryDTO" %>

    <g:hiddenField name="contact.id" value="${contact?.id}"/>

    <g:applyLayout name="form/input">
        <content tag="label"><g:message code="prompt.organization.name"/></content>
        <content tag="label.for">contact?.organizationName</content>
        <sec:ifAnyGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.organizationName" value="${contact?.organizationName}" />
		</sec:ifAnyGranted>
		<sec:ifNotGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.organizationName" value="${contact?.organizationName}" readonly="readonly"/>
		</sec:ifNotGranted>
    </g:applyLayout>

    <g:applyLayout name="form/input">
        <content tag="label"><g:message code="prompt.first.name"/></content>
        <content tag="label.for">contact.firstName</content>
        <sec:ifAnyGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.firstName" value="${contact?.firstName}" />
		</sec:ifAnyGranted>
		<sec:ifNotGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.firstName" value="${contact?.firstName}" readonly="readonly"/>
		</sec:ifNotGranted>
    </g:applyLayout>

    <g:applyLayout name="form/input">
        <content tag="label"><g:message code="prompt.last.name"/></content>
        <content tag="label.for">contact.lastName</content>
        <sec:ifAnyGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.lastName" value="${contact?.lastName}" />
		</sec:ifAnyGranted>
		<sec:ifNotGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.lastName" value="${contact?.lastName}" readonly="readonly"/>
		</sec:ifNotGranted>
    </g:applyLayout>

    <g:applyLayout name="form/text">
        <content tag="label"><g:message code="prompt.phone.number"/></content>
        <content tag="label.for">contact.phoneCountryCode</content>
        <span>
        <sec:ifAnyGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
            <g:textField class="field" name="contact.phoneCountryCode" value="${contact?.phoneCountryCode}" maxlength="3" size="2"/>
            -
            <g:textField class="field" name="contact.phoneAreaCode" value="${contact?.phoneAreaCode}" maxlength="5" size="3"/>
            -
            <g:textField class="field" name="contact.phoneNumber" value="${contact?.phoneNumber}" maxlength="10" size="8"/>
		</sec:ifAnyGranted>
		<sec:ifNotGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
            <g:textField class="field" name="contact.phoneCountryCode" value="${contact?.phoneCountryCode}" maxlength="3" size="2" readonly="readonly"/>
            -
            <g:textField class="field" name="contact.phoneAreaCode" value="${contact?.phoneAreaCode}" maxlength="5" size="3" readonly="readonly"/>
            -
            <g:textField class="field" name="contact.phoneNumber" value="${contact?.phoneNumber}" maxlength="10" size="8" readonly="readonly"/>
		</sec:ifNotGranted>
        </span>
    </g:applyLayout>

    <g:applyLayout name="form/input">
        <content tag="label"><g:message code="prompt.email"/><span id="mandatory-meta-field">*</span></content>
        <content tag="label.for">contact.email</content>
        <sec:ifAnyGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.email" value="${contact?.email}" />
		</sec:ifAnyGranted>
		<sec:ifNotGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.email" value="${contact?.email}" readonly="readonly"/>
		</sec:ifNotGranted>
    </g:applyLayout>

    <g:applyLayout name="form/input">
        <content tag="label"><g:message code="prompt.address1"/></content>
        <content tag="label.for">contact.address1</content>
        <sec:ifAnyGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.address1" value="${contact?.address1}" />
		</sec:ifAnyGranted>
		<sec:ifNotGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.address1" value="${contact?.address1}" readonly="readonly"/>
		</sec:ifNotGranted>
    </g:applyLayout>

    <g:applyLayout name="form/input">
        <content tag="label"><g:message code="prompt.address2"/></content>
        <content tag="label.for">contact.address2</content>
        <sec:ifAnyGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.address2" value="${contact?.address2}" />
		</sec:ifAnyGranted>
		<sec:ifNotGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.address2" value="${contact?.address2}" readonly="readonly"/>
		</sec:ifNotGranted>
    </g:applyLayout>

    <g:applyLayout name="form/input">
        <content tag="label"><g:message code="prompt.city"/></content>
        <content tag="label.for">contact.city</content>
        <sec:ifAnyGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.city" value="${contact?.city}" />
		</sec:ifAnyGranted>
		<sec:ifNotGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.city" value="${contact?.city}" readonly="readonly"/>
		</sec:ifNotGranted>
    </g:applyLayout>

    <g:applyLayout name="form/input">
        <content tag="label"><g:message code="prompt.state"/></content>
        <content tag="label.for">contact.stateProvince</content>
        <sec:ifAnyGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.stateProvince" value="${contact?.stateProvince}" />
		</sec:ifAnyGranted>
		<sec:ifNotGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.stateProvince" value="${contact?.stateProvince}" readonly="readonly"/>
		</sec:ifNotGranted>
    </g:applyLayout>

    <g:applyLayout name="form/input">
        <content tag="label"><g:message code="prompt.zip"/></content>
        <content tag="label.for">contact.postalCode</content>
        <sec:ifAnyGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.postalCode" value="${contact?.postalCode}" />
		</sec:ifAnyGranted>
		<sec:ifNotGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:textField class="field" name="contact.postalCode" value="${contact?.postalCode}" readonly="readonly"/>
		</sec:ifNotGranted>
    </g:applyLayout>

    <g:applyLayout name="form/select">
        <content tag="label"><g:message code="prompt.country"/></content>
        <content tag="label.for">contact.countryCode</content>

		<sec:ifAnyGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
		<g:select name="contact.countryCode"
                 from="${CountryDTO.list()}"
                 optionKey="code"
                 optionValue="${{ it.getDescription(session['language_id']) }}"
                 noSelection="['': message(code: 'default.no.selection')]"
                 value="${contact?.countryCode}"/>
        </sec:ifAnyGranted>

        <sec:ifNotGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
		<g:select name="contact.countryCode"
                 from="${CountryDTO.list()}"
                 optionKey="code"
                 optionValue="${{ it.getDescription(session['language_id']) }}"
                 noSelection="['': message(code: 'default.no.selection')]"
                 value="${contact?.countryCode}" disabled="true"/>
        </sec:ifNotGranted>

    </g:applyLayout>

    <g:applyLayout name="form/checkbox">
        <content tag="label"><g:message code="prompt.include.in.notifications"/></content>
        <content tag="label.for">contact.include</content>
        <sec:ifAnyGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:checkBox class="cb checkbox" name="contact.include" checked="${contact?.include}"/>
		</sec:ifAnyGranted>
		<sec:ifNotGranted roles="MY_ACCOUNT_162,ROLE_SUPER_USER">
			<g:checkBox class="cb checkbox" name="contact.include" checked="${contact?.include}" disabled="true"/>
		</sec:ifNotGranted>
    </g:applyLayout>
</div>
