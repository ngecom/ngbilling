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

<%@ page import="org.apache.commons.lang.StringEscapeUtils; com.sapienter.jbilling.client.util.SortableCriteria; java.util.regex.Pattern; com.sapienter.jbilling.server.user.UserBL; com.sapienter.jbilling.server.user.contact.db.ContactDTO" %>

<%--
   Display a list of User Codes and allows for sorting.

  @author Gerhard Maree
  @since  25-Nov-2013
--%>

<%-- parameters the page functionality must include in URLs --%>
<g:set var="searchParams" value="${SortableCriteria.extractParameters(params, ['filterBy','active'])}" />

<div class="heading"><strong><g:message code="userCode.heading.userCodes.for" args="[user.userName]" /></strong></div>
<div class="box narrow">
    <div class="sub-box-no-pad form-columns">
        <g:form name="user-code-filter-form" id="${params.id}" action="userCodeList">
            <g:applyLayout name="form/input">
                <content tag="label"><g:message code="filters.title"/></content>
                <content tag="label.for">filterBy</content>
                <g:textField name="filterBy" class="field default"
                             placeholder="${message(code: 'userCode.filterBy.default')}" value="${params.filterBy}"/>
            </g:applyLayout>

            <g:applyLayout name="form/checkbox">
                <content tag="label"><g:message code="userCode.active.title"/></content>
                <content tag="label.for">active</content>
                <g:checkBox name="active" class="field default" checked="${'on' == params.active}"/>
            </g:applyLayout>
        </g:form>
    </div>
</div>


<div class="table-box">
    <table id="users" cellspacing="0" cellpadding="0">
        <thead>
            <tr>
                <th>
                    <g:remoteSort action="userCodeList" sort="identifier" update="column1" searchParams="${searchParams}">
                        <g:message code="userCode.table.th.identifier"/>
                    </g:remoteSort>
                </th>
                <th class="medium2">
                    <g:remoteSort action="userCodeList" sort="externalReference" update="column1" searchParams="${searchParams}">
                        <g:message code="userCode.table.th.externalReference"/>
                    </g:remoteSort>
                </th>
                <th class="small">
                    <g:remoteSort action="userCodeList" sort="type" update="column1" searchParams="${searchParams}">
                        <g:message code="userCode.table.th.type"/>
                    </g:remoteSort>
                </th>
                <th class="small">
                    <g:remoteSort action="userCodeList" sort="validTo" update="column1" searchParams="${searchParams}">
                        <g:message code="userCode.table.th.validTo"/>
                    </g:remoteSort>
                </th>
            </tr>
        </thead>

        <tbody>
        <g:each in="${userCodes}" var="userCode">
            <tr id="user-${userCode.id}" class="${selected?.id == userCode.id ? 'active' : ''}">
                <td class="narrow">
                    <g:remoteLink class="cell double" action="userCodeShow" params="['template': 'userCodeShow']" id="${userCode.id}" before="register(this);" onSuccess="render(data, next);">
                        <strong>${StringEscapeUtils.escapeHtml(userCode?.identifier)}</strong>
                    </g:remoteLink>
                </td>
                <td class="narrow">
                    <g:remoteLink class="cell double" action="userCodeShow" params="['template': 'userCodeShow']" id="${userCode.id}" before="register(this);" onSuccess="render(data, next);">
                        <strong>${StringEscapeUtils.escapeHtml(userCode?.externalReference)}</strong>
                    </g:remoteLink>
                </td>
                <td class="narrow">
                    <g:remoteLink class="cell" action="userCodeShow" params="['template': 'userCodeShow']" id="${userCode.id}" before="register(this);" onSuccess="render(data, next);">
                        <span>${StringEscapeUtils.escapeHtml(userCode?.type)}</span>
                    </g:remoteLink>
                </td>
                <td class="narrow">
                    <g:remoteLink class="cell" action="userCodeShow" params="['template': 'userCodeShow']" id="${userCode.id}" before="register(this);" onSuccess="render(data, next);">
                        <span><g:formatDate format="MM/dd/yyyy" date="${userCode?.validTo}"/></span>
                    </g:remoteLink>
                </td>
            </tr>

        </g:each>
        </tbody>
    </table>
</div>

<div class="pager-box">
    <div class="row">
        <div class="results">
            <g:render template="/layouts/includes/pagerShowResults" model="[steps: [10, 20, 50], action: 'userCodeList', id: params.id, update: 'column1', searchParams: searchParams]" />
        </div>
    </div>

    <div class="row">
        <util:remotePaginate controller="user" action="userCodeList" id="${params.id}" params="${sortableParams(params: ([partial: true])) + searchParams}" total="${userCodes?.totalCount ?: 0}" update="column1"/>
    </div>
</div>

<div class="btn-box">
        <g:link action="userCodeEdit" params="[add: 'true', userId: params?.id]" class="submit add"><span><g:message code="button.create"/></span></g:link>
</div>


<script type="text/javascript">

    <%-- event listeners to reload results --%>
    $('#user-code-filter-form :input[name=filterBy]').blur(function () {
        $('#user-code-filter-form').submit();
    });

    $('#user-code-filter-form :input[name=active]').change(function () {
        $('#user-code-filter-form').submit();
    });

    <g:if test="${params.partial}" >
    <%-- register for the slide events if it is loaded by pagination --%>
        registerSlideEvents();
    </g:if>
    placeholder();
</script>
