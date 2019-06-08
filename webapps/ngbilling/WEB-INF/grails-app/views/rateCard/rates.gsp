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

<html>
<head>
	<meta name="layout" content="main"/>
</head>
<body>

    %{-- rate card summary --}%
    <div class="table-info" >
        <em>
            <g:message code="rate.card.inspect.th.id"/>
            <strong>${rateCard.id}</strong>
        </em>
        <em>
            <g:message code="rate.card.inspect.th.name"/>
            <strong>${rateCard.name}</strong>
        </em>
        <em>
            <g:message code="rate.card.inspect.th.table.name"/>
            <strong>${rateCard.tableName}</strong>
        </em>
    </div>

    %{-- rate card contents --}%
    <div class="table-area">
        <table>
            <thead>
                <tr>
                    <g:each var="column" in="${columns}" status="i">
                        <g:if test="${i == 0}">
                            <td class="first">${column}</td>
                        </g:if>
                        <g:elseif test="${i == columns.size}">
                            <td class="last">${column}</td>
                        </g:elseif>
                        <g:else>
                            <td>${column}</td>
                        </g:else>
                    </g:each>
                </tr>
            </thead>
            <tbody>

            <g:while test="${resultSet.next()}">
                <g:set var="result" value="${resultSet.get()}"/>

                <tr>
                <g:each var="result" in="${resultSet.get()}" status="i">


                    <td class="${i == 0 ? 'col02' : ''}">
                        ${result}
                    </td>
                </g:each>
                </tr>

            </g:while>

            <%
                resultSet.close()
            %>

            </tbody>
        </table>
    </div>

</body>
</html>