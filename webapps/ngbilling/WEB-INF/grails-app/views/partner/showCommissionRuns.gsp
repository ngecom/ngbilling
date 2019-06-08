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


<html>
<head>
	<meta name="layout" content="panels"/>
</head>

<body>

<content tag="filters"></content>

<content tag="column1">
    <div class="table-box">
    	<div class="table-scroll">
        	<table id="runs" cellspacing="0" cellpadding="0">
    			<thead>
    				<tr>
    					<th class="small">
                            <g:message code="label.partner.commissionRun.id"/>
                        </th>
    					<th class="medium">
                            <g:message code="label.partner.commissionRun.runDate"/>
                        </th>
                        <th class="small">
                            <g:message code="label.partner.commissionRun.periodStart"/>
                        </th>
    					<th class="small">
                            <g:message code="label.partner.commissionRun.periodEnd"/>
                        </th>
    				</tr>
    			</thead>

    			<tbody>
                    <g:each var="commissionRun" in="${commissionRuns}">
                        <tr id="process-${commissionRun.id}">
                            <td class="small">
                                <g:link class="cell" action="showCommissions"
                                        params="[id: commissionRun.id, agentId: params.id]">
                                    ${commissionRun.id}
                                </g:link>
                            </td>
                            <td class="medium">
                                <g:link class="cell" action="showCommissions"
                                        params="[id: commissionRun.id, agentId: params.id]">
                                    <g:formatDate date="${commissionRun.runDate}" formatName="date.pretty.format"/>
                                </g:link>
                            </td>
                            <td class="medium">
                                <g:link class="cell" action="showCommissions"
                                        params="[id: commissionRun.id, agentId: params.id]">
                                    <g:formatDate date="${commissionRun.periodStart}" formatName="date.pretty.format"/>
                                </g:link>
                            </td>
                            <td class="medium">
                                <g:link class="cell" action="showCommissions"
                                        params="[id: commissionRun.id, agentId: params.id]">
                                    <g:formatDate date="${commissionRun.periodEnd}" formatName="date.pretty.format"/>
                                </g:link>
                            </td>
                        </tr>
                    </g:each>
    			</tbody>
    		</table>
    	</div>
    </div>

    <div class="pager-box">

        <div class="row">
            <g:paginate controller="partner" action="showCommissionRuns" params="${sortableParams(params: [partial: true])}" total="${commissionRuns?.totalCount ?: 0}" />
        </div>
    </div>

    <div class="btn-box">
        <div class="row"></div>
    </div>
</content>

</body>
</html>