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

<%@ page import="com.sapienter.jbilling.common.CommonConstants; com.sapienter.jbilling.server.user.ContactWS; com.sapienter.jbilling.server.user.UserDTOEx; com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.user.permisson.db.RoleDTO; com.sapienter.jbilling.server.util.db.LanguageDTO" %>
<html>
<head>
    <meta name="layout" content="main" />

    <r:script disposition="head">
        $(document).ready(function() {
            $('#contactType').change(function() {
                var selected = $('#contact-' + $(this).val());
                $(selected).show();
                $('div.contact').not(selected).hide();
            }).change();
        });

        function goBack() {
			window.history.back()
		}
    </r:script>
</head>
<body>
<div class="form-edit">

    <g:set var="isNew" value="${!user || !user?.userId || user?.userId == 0}"/>

    <div class="heading">
        <strong>
            <g:if test="${isNew}">
                New User
            </g:if>
            <g:else>
                Edit User
            </g:else>
        </strong>
    </div>

    <div class="form-hold">
        <g:form name="user-edit-form" action="save" useToken="true">
            <fieldset>
                <div class="form-columns">

                    <!-- user details column -->
                    <div class="column">
                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="prompt.customer.number"/></content>

                            <g:if test="${!isNew}">
                                <span>${user.userId}</span>
                            </g:if>
                            <g:else>
                                <em><g:message code="prompt.id.new"/></em>
                            </g:else>

                            <g:hiddenField name="user.userId" value="${user?.userId}"/>
                        </g:applyLayout>

                        <g:if test="${isNew}">
                            <g:applyLayout name="form/input">
                                <content tag="label"><g:message code="prompt.login.name"/><span id="mandatory-meta-field">*</span></content>
                                <content tag="label.for">user.userName</content>
                                <g:textField class="field" name="user.userName" value="${user?.userName}"/>
                            </g:applyLayout>
                        </g:if>
                        <g:else>
                            <g:applyLayout name="form/text">
                                <content tag="label"><g:message code="prompt.login.name"/></content>

                                ${user?.userName}
                                <g:hiddenField name="user.userName" value="${user?.userName}"/>
                            </g:applyLayout>
                        </g:else>

                    <g:if test="${!isNew && user?.userId == loggedInUser?.id}">
                        
                            <g:applyLayout name="form/input">
                                <content tag="label"><g:message code="prompt.current.password"/></content>
                                <content tag="label.for">oldPassword</content>
									<g:passwordField class="field" name="oldPassword"/>
									<g:passwordField class="field" name="oldPassword" disabled="true"/>
                            </g:applyLayout>
                        
                    </g:if>

                    <!-- USER CREDENTIALS -->
                    <g:if test="${isNew}">
                        <g:preferenceEquals preferenceId="${CommonConstants.PREFERENCE_CREATE_CREDENTIALS_BY_DEFAULT}" value="0">
                            <g:applyLayout name="form/checkbox">
                                <content tag="label"><g:message code="prompt.create.credentials"/></content>
                                <content tag="label.for">user.createCredentials</content>
                                <g:checkBox class="cb checkbox" name="user.createCredentials" checked="${user?.createCredentials}"/>
                            </g:applyLayout>
                        </g:preferenceEquals>
                    </g:if>

                    <g:if test="${!isNew && user?.userId == loggedInUser?.id}">
                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="prompt.password"/><span id="mandatory-meta-field">*</span></content>
                            <content tag="label.for">newPassword</content>
								<g:passwordField class="field" name="newPassword"/>
								<g:passwordField class="field" name="newPassword" disabled="true"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="prompt.verify.password"/><span id="mandatory-meta-field">*</span></content>
                            <content tag="label.for">verifiedPassword</content>
								<g:passwordField class="field" name="verifiedPassword"/>
								<g:passwordField class="field" name="verifiedPassword" disabled="true"/>
                        </g:applyLayout>
                    </g:if>


                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="prompt.user.status"/></content>
                            <content tag="label.for">user.statusId</content>
	                            <g:if test="${params.id}">
	                                <g:userStatus name="user.statusId" value="${user?.statusId}" languageId="${session['language_id']}"/>
	                            </g:if>
	                            <g:else>
	                                <g:userStatus name="user.statusId" value="${user?.statusId}" languageId="${session['language_id']}" />
	                            </g:else>
	                    </g:applyLayout>

                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="prompt.user.language"/></content>
                            <content tag="label.for">user.languageId</content>
	                            <g:select name="user.languageId" from="${LanguageDTO.list()}"
	                                    optionKey="id" optionValue="description" value="${user?.languageId}" />
	                    </g:applyLayout>

                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="prompt.user.role"/></content>
                            <content tag="label.for">user.mainRoleId</content>

	                            <g:select name="user.mainRoleId"
                                      from="${roles}"
                                      optionKey="roleTypeId"
                                      optionValue="${{ it.getTitle(session['language_id']) }}"
                                      value="${user?.mainRoleId}"/>
								<g:hiddenField name="user.role" value="${user?.role}"/>
                        </g:applyLayout>
                        <g:set var="isReadOnly" value="true"/>
                            <g:set var="isReadOnly" value="false"/>
                        <g:applyLayout name="form/checkbox">
                            <content tag="label"><g:message code="user.account.lock"/></content>
                            <content tag="label.for">user.isAccountLocked</content>
                            <g:checkBox class="cb checkbox" name="user.isAccountLocked" checked="${user?.isAccountLocked}" disabled="${isReadOnly}"/>
                        </g:applyLayout>
                        <g:set var="isReadOnly" value="true"/>
                            <g:set var="isReadOnly" value="false"/>
                        <g:applyLayout name="form/checkbox">
                        <content tag="label"><g:message code="prompt.user.inactive"/></content>
                        <content tag="label.for">user.accountExpired</content>
                        <g:checkBox class="cb checkbox" name="user.accountExpired" checked="${user?.accountDisabledDate}" disabled="${isReadOnly}"/>
                        </g:applyLayout>
                    </div>

                    <!-- contact information column -->
                    <div class="column">
                        <g:set var="contact" value="${contacts && contacts.size()>0 ? contacts[0] : new ContactWS()}"/>
                        <g:render template="/user/contact" model="[contact: contact]"/>
                        <br/>&nbsp;
                    </div>
                </div>

                <div class="buttons">
                    <ul>
                        <li>
                            <a onclick="$('#user-edit-form').submit()" class="submit save"><span><g:message code="button.save"/></span></a>
                        </li>
                        <li>
                            <g:link action="list" class="submit cancel"><span><g:message code="button.cancel"/></span></g:link>
                        </li>
                    </ul>
                </div>

            </fieldset>
        </g:form>
    </div>
</div>
</body>
</html>