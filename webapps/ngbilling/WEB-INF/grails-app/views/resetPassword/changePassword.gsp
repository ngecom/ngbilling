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

%{-- <%@ page import="com.sapienter.jbilling.server.user.UserDTOEx; com.sapienter.jbilling.server.user.contact.db.ContactTypeDTO; com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.user.permisson.db.RoleDTO; com.sapienter.jbilling.common.CommonConstantsstants; com.sapienter.jbilling.server.util.db.LanguageDTO" %> --}%
<html>
<head>
    <meta name="layout" content="public" />
    <r:script disposition="head">
        $(document).ready(function () {
            $('input[name="newPassword"]').focus();

            $('#confirmedNewPassword').keypress(function(e) {
                if ( e.keyCode == 13 ) {  // detect the enter key
                    $('#user-password-update-form').submit();
                }
            });
        });
    </r:script>
</head>
<body>
<div id="reset_password" class="form-edit">

    <g:render template="/layouts/includes/messages"/>
    <div class="heading">
        <strong>
            <g:message code="login.reset.password.title"/>
        </strong>
    </div>

    <div class="form-hold">
        <g:form name="user-password-update-form" action="updatePassword">
            <fieldset>
                <div class="form-columns">

                    <g:hiddenField name="token" value="${token}"/>
                    <!-- user details column -->
                    <div class="column">

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="prompt.password"/></content>
                            <content tag="label.for">newPassword</content>
                            <g:passwordField class="field" name="newPassword"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="prompt.verify.password"/></content>
                            <content tag="label.for">confirmedNewPassword</content>
                            <g:passwordField class="field" name="confirmedNewPassword"/>
                        </g:applyLayout>
                    </div>

                </div>
                <br/>

                <div class="buttons">
                    <ul>
                        <li>
                            <a onclick="$('#user-password-update-form').submit()" class="submit save"><span><g:message code="button.reset"/></span></a>
                        </li>
                    </ul>
                </div>

            </fieldset>
        </g:form>
    </div>
</div>
</body>
</html>