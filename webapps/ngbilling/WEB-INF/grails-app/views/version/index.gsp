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

<%@ page import="org.joda.time.DateTimeZone" %>
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
  --}%

<%--
  Version debug page

  @author Brian Cowdery
  @since  22-Jun-2011
--%>

<html>
<head>
    <title>jBilling <g:meta name="app.version"/></title>
    <meta name="layout" content="public" />
</head>
<body>

<div class="form-edit">

    <div class="heading">
        <strong><g:meta name="app.name"/> <g:meta name="app.version"/></strong>
    </div>

    <div class="form-hold">
        <div class="form-columns">

            <div class="column">
                <h2>Application Version</h2>

                <table cellpadding="0" cellspacing="0" class="dataTable">
                    <tr>
                        <td>jBilling Edition:</td>
                        <td class="value"><g:meta name="app.version"/></td>
                    </tr>
                    <tr>
                        <td>Grails Version:</td>
                        <td class="value"><g:meta name="app.grails.version"/></td>
                    </tr>
                    <tr>
                        <td>Groovy Version:</td>
                        <td class="value">${GroovySystem.getVersion()}</td>
                    </tr>
                    <tr>
                        <td>JVM Version:</td>
                        <td class="value">${System.getProperty('java.version')}</td>
                    </tr>
                </table>

                <h2>Locale</h2>

                <table cellpadding="0" cellspacing="0" class="dataTable">
                    <tr>
                        <td>JVM Default Locale:</td>
                        <td class="value">${Locale.getDefault()}</td>
                    </tr>
                    <tr>
                        <td>JVM Default TimeZone:</td>
                        <td class="value">
                            <g:set var="jdkTimezone" value="${TimeZone.getDefault()}"/>
                            ${jdkTimezone.getID()}
                        </td>
                    </tr>
                    <tr>
                        <td>Joda-Time Default TimeZone:</td>
                        <td class="value">
                            <g:set var="jodaTimezone" value="${DateTimeZone.getDefault()}"/>
                            <g:if test="${jodaTimezone.toTimeZone().equals(jdkTimezone)}">
                                ${jodaTimezone.getID()}
                            </g:if>
                            <g:else>
                                <span style="color: red;" title="Does not match JDK TimeZone">${jodaTimezone.getID()}</span>
                            </g:else>
                        </td>
                    </tr>
                </table>
            </div>

            <div class="column">
                <h2>Installed Plugins</h2>

                <table cellpadding="0" cellspacing="0" class="dataTable">
                    <g:set var="pluginManager" value="${applicationContext.getBean('pluginManager')}"/>
                    <g:each var="plugin" in="${pluginManager.allPlugins}">
                        <tr>
                            <td>${plugin.name}</td>
                            <td class="value">${plugin.version}</td>
                        </tr>
                    </g:each>
                </table>
            </div>

        </div>
    </div>

</div>

</body>
</html>
