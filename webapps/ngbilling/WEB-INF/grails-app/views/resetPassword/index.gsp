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
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>

<%@ page import="com.sapienter.jbilling.common.Util; com.sapienter.jbilling.server.user.db.CompanyDTO" %>

<head>
    <meta name="layout" content="public"/>

    <title><g:message code="login.page.title"/></title>

    <r:script disposition="head">
        var RecaptchaOptions = {
            theme:'white'
        };

        $(document).ready(function () {
            $('#reset_password input[name="email"]').focus();

            $(document).keypress(function (e) {
                if (e.which == 13) {

                    $(this).blur();
                    $('#reset_password form').submit();
                }
            });
        });

        function companyChanged(){
            location.href = '<g:createLink controller="resetPassword" action="index"/>?company='+$('#reset_password [name="company"]').val();
        }
    </r:script>

    <style type="text/css">
    #recaptcha_widget_div label {
        float: none;
    }

    #recaptcha_widget_div a img {
        top: 0px;
        left: 0px;
    }

    #recaptcha_widget_div span {
        font-weight: normal;
        line-height: 0 !important;
    }

    #recaptcha_widget_div {
        margin-left: 85px;
        margin-top: 12px;
    }
    </style>
</head>

<body>

<g:render template="/layouts/includes/messages"/>

<div id="reset_password" class="form-edit">
    <div class="heading">
        <strong><g:message code="forgotPassword.prompt.title"/></strong>
    </div>

    <div class="form-hold">
        <g:form controller="resetPassword" action="captcha">
            <fieldset>

                <div class="form-columns">

                    <g:applyLayout name="form/select">
                        <g:set var="companies" value="${CompanyDTO.list()}"/>
                        <content tag="label"><g:message code="login.prompt.client.id"/></content>
                        <content tag="label.for">company</content>
                        <g:if test="${companies}">
                            <g:select name="company"
                                      from="${companies?.findAll{it.description = StringEscapeUtils.unescapeHtml(it.description)}.sort{it.description}}"
                                      optionKey="id"
                                      optionValue="description"
                                      value="${params?.company as Integer}"
                                      onchange="companyChanged()"/>
                        </g:if>
                        <g:else>
                            <g:select name="company"
                                      from="${companies}"
                                      optionKey="id"
                                      noSelection="['': message(code: 'default.no.selection')]"
                                      optionValue="description"
                                      value="${params?.company as Integer}"
                                      onchange="companyChanged()" />
                        </g:else>
                    </g:applyLayout>

                    <g:if test="${useEmail}">
                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="forgotPassword.prompt.email"/></content>
                            <content tag="label.for">email</content>
                            <g:textField class="field" name="email" value=""/>
                        </g:applyLayout>
                    </g:if>
                    <g:else>
                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="forgotPassword.prompt.userName"/></content>
                            <content tag="label.for">userName</content>
                            <g:textField class="field" name="userName" value=""/>
                        </g:applyLayout>
                    </g:else>

                    <g:if test="${captchaEnabled}">
                        <script type="text/javascript"
                                src="https://www.google.com/recaptcha/api/challenge?k=${publicKey}">
                        </script>
                        <noscript>
                            <iframe src="https://www.google.com/recaptcha/api/noscript?k=${publicKey}"
                                    height="300" width="500" frameborder="0"></iframe><br>
                            <textarea name="recaptcha_challenge_field" rows="3" cols="40">
                            </textarea>
                            <input type="hidden" name="recaptcha_response_field"
                                   value="manual_challenge">
                        </noscript>
                    </g:if>

                    <br/>
                </div>

                <div class="buttons">
                    <ul>
                        <li>
                            <a href="#" class="submit save" onclick="$('#reset_password form').submit();">
                                <span><g:message code="forgotPassword.button.submit"/></span>
                            </a>
                        </li>
                    </ul>
                </div>
            </fieldset>
        </g:form>
    </div>
</div>

</body>
</html>