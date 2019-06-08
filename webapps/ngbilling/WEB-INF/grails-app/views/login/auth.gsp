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

<%@ page import="com.sapienter.jbilling.server.user.db.CompanyDTO" %>

<head>
    <meta name="layout" content="public" />

    <title><g:message code="login.page.title"/></title>

    <r:script disposition="head">
        $(document).ready(function() {
            $('#login input[name="j_username"]').focus();

            $(document).keypress(function(e) {
                    if(e.which == 13) {

                        $(this).blur();
                        $('#login form').submit();
                    }
                });

        });
    </r:script>
</head>
<body>

    <g:render template="/layouts/includes/messages"/>

    <div id="login" class="form-edit">
        <div class="heading">
            <strong><g:message code="login.prompt.title"/></strong>
        </div>
        <div class="form-hold">
            <form action='${postUrl}' method='POST' id='login-form' autocomplete='off'>
                
                <g:hiddenField name="interactive_login" value="true"/>                

                <fieldset>

                    <div class="form-columns">
                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="login.prompt.username"/></content>
                            <content tag="label.for">username</content>
                            <g:textField class="field" name="j_username" value="${params.userName}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="login.prompt.password"/></content>
                            <content tag="label.for">password</content>
                            <g:passwordField class="field" name="j_password"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/select">
                            <g:set var="companies" value="${CompanyDTO.createCriteria().list(){eq('deleted', 0)}.sort {it.description}}"/>
                            <content tag="label"><g:message code="login.prompt.client.id"/></content>
                            <content tag="label.for">client_id</content>
                            <g:if test="${companies}" >
                                <g:select name="j_client_id"
                                          from="${companies}"
                                          optionKey="id"
                                          optionValue="${{it?.description}}"
                                          value="${params.companyId && !params.companyId.isEmpty() ? params.companyId as Integer : null}"/>
                            </g:if>
                            <g:else>
                                <g:select name="j_client_id"
                                          from="${companies}"
                                          optionKey="id"
                                          noSelection="['': message(code: 'default.no.selection')]"
                                          optionValue="description"
                                          value="${params.companyId && !params.companyId.isEmpty() ? params.companyId as Integer : null}"/>
                            </g:else>
                        </g:applyLayout>

                        <g:applyLayout name="form/text">
                            <content tag="label">&nbsp;</content>
                            <g:link controller="resetPassword"><g:message code="login.prompt.forgotPassword" /></g:link>
                        </g:applyLayout>

                        <br/>
                    </div>

                    <div class="buttons">
                        <ul>
                            <li>
                                <a href="#" class="submit save" onclick="$('#login form').submit();">
                                    <span><g:message code="login.button.submit"/></span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </fieldset>
            </form>
        </div>
    </div>

</body>
</html>