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
	@author Vikas Bodani
	@since 17 Feb 2011
 --%>

<html>
<head>
	<meta name="layout" content="panels"/>
</head>
<body>

    <content tag="column1">
        <g:render template="processes" model="[processes: processes, filters:filters ,processValues:processValues]"/>
    </content>

    <content tag="column2">
        <!-- show selected process if set -->
        <g:if test="${selected}">
            <g:render template="show" model="[process: process]"/>
        </g:if>
    </content>

</body>
</html>