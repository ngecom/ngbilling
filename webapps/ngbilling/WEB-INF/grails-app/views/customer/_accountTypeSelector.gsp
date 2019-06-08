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

<div class="form-edit">

    <div class="heading">
        <strong>
            <g:message code="customer.account.type.title"/>
        </strong>
    </div>

    <g:form name="user-account-select-form" action="edit">
        <fieldset>
            <g:if test="${parentId}">
                <g:hiddenField name="parentId" value="${parentId}"/>
            </g:if>
            <div class="form-columns">
                <div class="column">
                	<g:isRoot>
                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="prompt.user.company"/></content>
                            <content tag="label.for">user.entityId</content>
                            <g:select name="user.entityId"
                                      from="${companies}"
                                      optionKey="id"
                                      optionValue="${{it?.description}}"
                                      value="${session['company_id']}"
                                      onChange="${remoteFunction(action: 'getAccountTypes',
                  									update: 'account-select',
                  									params: '\'user.entityId=\' + this.value')}" />
                        </g:applyLayout>
                        <div id="account-select">
                        	<g:render template="accountTypeDropDown" model="[accountTypes: accountTypes]"/>
                        </div>
					</g:isRoot>
					<g:isNotRoot>
						<g:hiddenField name="user.entityId" value="${session['company_id']}"/>
                    	<g:applyLayout name="form/select">
                        	<content tag="label"><g:message code="customer.detail.account.type"/></content>
                        	<content tag="label.for">user.accountTypeId</content>
                        	<g:select name="accountTypeId" from="${accountTypes}"
                                  optionKey="id" optionValue="description" />
                    	</g:applyLayout>
                    </g:isNotRoot>
                </div>
            </div>
            <!-- spacer -->
            <div>
                <br/>&nbsp;
            </div>
        </fieldset>
    </g:form>

    <div class="buttons">
        <div class="btn-row">
            <ul>
                <li>
                    <a onclick="$('#user-account-select-form').submit()" class="submit save">
                        <span><g:message code="button.select"/></span>
                    </a>
                </li>
                <li>
                    <g:link action="list" class="submit cancel">
                        <span><g:message code="button.cancel"/></span>
                    </g:link>
                </li>
            </ul>
        </div>
    </div>
</div>