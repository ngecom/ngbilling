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

<div class="heading">
    <strong><g:message code="asset.heading.transitions"/></strong>
</div>
<div class="box">
    <div class="sub-box">
        <g:if test="${transitions}">
            <table class="innerTable" >
                <thead class="innerHeader">
                <tr>
                    <th><g:message code="asset.label.transition.status"/></th>
                    <th><g:message code="asset.label.transition.changedate"/></th>
                </tr>
                </thead>
                <tbody>
                <g:each var="transition" in="${transitions}" status="idx">
                    <tr>
                        <td class="innerContent" style="min-width: 75px">
                            ${transition.newStatus.description}
                        </td>
                        <td class="innerContent">
                            <g:formatDate formatName="date.timeSecs.format" date="${transition.createDatetime}"/>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </g:if>
        <g:else>
            <em><g:message code="asset.prompt.no.transitions"/></em>
        </g:else>
    </div>
</div>