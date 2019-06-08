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

 rbidden.
  --}%

<%@ page import="com.sapienter.jbilling.common.CommonConstants; org.apache.commons.lang.StringEscapeUtils; com.sapienter.jbilling.server.metafields.MetaFieldHelper; com.sapienter.jbilling.client.user.UserHelper; com.sapienter.jbilling.common.CommonConstants" %>
<table cellpadding="0" cellspacing="0" class="blacklist" width="100%">
    <thead>
    <tr>
        <th class="medium"><g:message code="blacklist.th.name"/></th>
        <th class="small2"><g:message code="blacklist.th.credit.card"/></th>
        <th class="small2"><g:message code="blacklist.th.ip.address"/></th>
    </tr>
    </thead>

    <tbody>
    <g:each var="entry" status="i" in="${blacklist}">
        <tr class="${i % 2 == 0 ? 'even' : 'odd'}">
            <td id="entry-${entry.id}">
                <g:remoteLink class="cell" action="show" id="${entry.id}" before="register(this);" onSuccess="render(data, next);">
                    <g:set var="name" value="${UserHelper.getDisplayName(entry.user, entry.contact)}"/>
                    ${name ? StringEscapeUtils.escapeHtml(name) : entry.user?.id ?: entry.contact?.userId ?: entry.contact?.id}
                </g:remoteLink>
            </td>
            <td>
                <g:remoteLink class="cell" action="show" id="${entry.id}" before="register(this);" onSuccess="render(data, next);">
                    <g:if test="${entry.creditCard?.metaFields}">
                    %{-- obscure credit card by default, or if the preference is explicitly set --}%
                            <g:set var="creditCardNumber" value="${entry.creditCard?.metaFields?.find{it.field.name == com.sapienter.jbilling.common.CommonConstants.METAFIELD_NAME_CC_NUMBER}?.getValue()?.replaceAll('^\\d{12}','************')}"/>
                            ${StringEscapeUtils.escapeHtml(creditCardNumber)}

                    </g:if>
                </g:remoteLink>
            </td>
            <td>
                <g:set var="customer" value="${entry.user?.customer}"/>
                <g:if test="${customer}">
                    <g:remoteLink class="cell" action="show" id="${entry.id}" before="register(this);" onSuccess="render(data, next);">
                        ${StringEscapeUtils.escapeHtml(MetaFieldHelper.getMetaField(customer, ipAddressType?.name)?.getValue())}
                    </g:remoteLink>
                </g:if>
            </td>
        </tr>
    </g:each>
    </tbody>
</table>