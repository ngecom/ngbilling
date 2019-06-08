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

<div class="table-box">
	<div class="table-scroll">
    	<table id="processes" cellspacing="0" cellpadding="0">
			<thead>
				<tr>
					<th class="large2">
                        <g:remoteSort action="list" sort="id" update="column1">
                            <g:message code="mediation.th.id" />
                        </g:remoteSort>
                    </th>
					<th class="small2">
                        <g:remoteSort action="list" sort="startDatetime" update="column1">
                            <g:message code="mediation.th.start.date" />
                        </g:remoteSort>
                    </th>
					<th class="small2">
                        <g:remoteSort action="list" sort="endDatetime" update="column1">
                            <g:message code="mediation.th.end.date" />
                        </g:remoteSort>
                    </th>
					<th class="small">
                        <g:message code="mediation.th.total.records" />
                    </th>
                    <th class="small">
                        <g:remoteSort action="list" sort="ordersAffected" update="column1">
                            <g:message code="mediation.th.orders.affected"/>
                        </g:remoteSort>
                    </th>
				</tr>
			</thead>
	
            <tbody>
				<g:each var="entry" status="idx" in="${processes}">
                    <g:set var="proc" value="${entry}"/>
                    <g:set var="recordCount" value="${processValues[idx]}"/>

					<tr id="mediation-${proc.id}" class="${proc?.id == processId ? 'active' : ''}">
						<td>
                            <g:remoteLink breadcrumb="id" class="cell double" action="show" id="${proc.id}" params="['template': 'show']" before="register(this);" onSuccess="render(data, next);">
                                <strong>${proc.id}</strong>
                                <em>${proc.configuration.name}</em>
                            </g:remoteLink>
                        </td>
						<td>
							<g:remoteLink breadcrumb="id" class="cell" action="show" id="${proc.id}" params="['template': 'show']" before="register(this);" onSuccess="render(data, next);">
                                <g:formatDate date="${proc.startDatetime}" formatName="date.timeSecsAMPM.format"/>
                            </g:remoteLink>
						</td>
                        <td>
                            <g:remoteLink breadcrumb="id" class="cell" action="show" id="${proc.id}" params="['template': 'show']" before="register(this);" onSuccess="render(data, next);">
                                <g:formatDate date="${proc.endDatetime}" formatName="date.timeSecsAMPM.format"/>
                            </g:remoteLink>
                        </td>
						<td>
                            <g:remoteLink breadcrumb="id" class="cell" action="show" id="${proc.id}" params="['template': 'show']" before="register(this);" onSuccess="render(data, next);">
                                ${recordCount}
                            </g:remoteLink>
                        </td>
                        <td>
                            <g:remoteLink breadcrumb="id" class="cell" action="show" id="${proc.id}" params="['template': 'show']" before="register(this);" onSuccess="render(data, next);">
                                ${proc.ordersAffected}
                            </g:remoteLink>
                        </td>
					</tr>
				</g:each>
			</tbody>
		</table>
	</div>
</div>

<div class="pager-box">
    <div class="row">
        <div class="results">
            <g:render template="/layouts/includes/pagerShowResults" model="[steps: [10, 20, 50], update: 'column1']"/>
        </div>
    </div>

    <div class="row">
        <util:remotePaginate controller="mediation" action="index" params="${sortableParams(params: [partial: true])}" total="${processes?.totalCount ?: 0}" update="column1"/>
    </div>
</div>

<div class="btn-box">
    <div class="row"></div>
</div>
