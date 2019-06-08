%{--
  JBILLING CONFIDENTIAL
  _____________________

  [2003] - [2012] Enterprise jBilling Software Ltd.
  All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Enterprise jBilling Software.
  The intellectual and technical concepts contained
  herein are proprietary to Enterprise jBilling Software
  and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden.
  --}%

<%--
  Created by IntelliJ IDEA.
  User: vojislav
  Date: 4.5.15
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <sec:ifLoggedIn>
            <meta name="layout" content="main" />
        </sec:ifLoggedIn>

        <sec:ifNotLoggedIn>
            <meta name="layout" content="public" />
        </sec:ifNotLoggedIn>

        <title><g:message code="flash.exception.message.title.page.not.found"/></title>
    </head>

    <body>
        <div class="msg-box error wide">
            <img src="${resource(dir:'images', file:'icon14.gif')}" alt="${message(code:'error.icon.alt',default:'Page Not Found')}"/>
            <strong><g:message code="flash.exception.message.title.page.not.found"/></strong>
            <p>
                <g:message code="flash.exception.message.page.not.found"/>
            </p>
        </div>
    </body>
</html>