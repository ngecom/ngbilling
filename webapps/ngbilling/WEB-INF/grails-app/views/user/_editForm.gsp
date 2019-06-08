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

<%@ page import="com.sapienter.jbilling.server.user.ContactWS; com.sapienter.jbilling.server.user.UserDTOEx; com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.user.permisson.db.RoleDTO; com.sapienter.jbilling.common.CommonConstants; com.sapienter.jbilling.server.util.db.LanguageDTO" %>

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
                <jB:flow/>
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
                                <content tag="label"><g:message code="prompt.login.name"/></content>
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

                        <g:if test="${!isNew}">
                             <g:applyLayout name="form/input">
                                <content tag="label"><g:message code="prompt.current.password"/></content>
                                <content tag="label.for">oldPassword</content>
                                <g:passwordField class="field" name="oldPassword"/>
                            </g:applyLayout>
                        </g:if>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="prompt.password"/></content>
                            <content tag="label.for">newPassword</content>
                            <g:passwordField class="field" name="newPassword"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="prompt.verify.password"/></content>
                            <content tag="label.for">verifiedPassword</content>
                            <g:passwordField class="field" name="verifiedPassword"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="prompt.user.status"/></content>
                            <content tag="label.for">user.statusId</content>
                            <g:if test="${params.id}">
                                <g:userStatus name="user.statusId" value="${user?.statusId}" languageId="${session['language_id']}"/>
							</g:if>
							<g:else>
								<g:userStatus name="user.statusId" value="${user?.statusId}" languageId="${session['language_id']}" disabled="true"/>
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
                        </g:applyLayout>
                    </div>

                    <!-- contact information column -->
                    <div class="column">
                        <g:set var="contact" value="${contacts && contacts.length > 0 ? contacts[0] : new ContactWS()}"/>
                        <g:render template="/customer/contact" model="[contact: contact]"/>

                        <br/>&nbsp;
                    </div>
                </div>

                <div class="buttons">
                    <ul>
                        <li>
                            <a onclick="$('#user-edit-form').submit()" class="submit save"><span><g:message code="button.save"/></span></a>
                        </li>
                        <li>
                            <g:set var="cancelLink" value="${jB.property([name: 'cancelLink'])}"/>
                            <g:if test="${cancelLink}">
                               <g:link url="${resource(file: cancelLink)}" class="submit cancel"><span><g:message code="button.cancel"/></span></g:link>
                            </g:if>
                            <g:else>
                                <g:link action="list" class="submit cancel"><span><g:message code="button.cancel"/></span></g:link>
                            </g:else>
                        </li>
                    </ul>
                </div>

            </fieldset>
        </g:form>
    </div>
</div>
