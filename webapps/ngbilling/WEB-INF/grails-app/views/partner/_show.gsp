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

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="org.apache.commons.lang.StringEscapeUtils; grails.plugin.springsecurity.SpringSecurityUtils; com.sapienter.jbilling.server.process.db.PeriodUnitDTO"  %>

<%--
  Shows a Partner

  @author Vikas Bodani
  @since  26-Jul-2011
--%>

<div class="column-hold">
    <div class="heading">
        <strong>
            <g:if test="${contact?.firstName || contact?.lastName}">
                ${contact.firstName} ${contact.lastName}
            </g:if>
            <g:else>
                ${selected?.baseUser?.userName}
            </g:else>
            <em><g:if test="${contact}">${contact.organizationName}</g:if></em>
        </strong>
    </div>

    <!-- partner user details -->
    <div class="box">

        <div class="sub-box">
            <table class="dataTable" cellspacing="0" cellpadding="0">
                <tbody>
                <tr>
                    <td><g:message code="partner.detail.id"/></td>
                    <td class="value">${selected.id}</td>
                </tr>
                <tr>
                    <td><g:message code="customer.detail.user.username"/></td>
                    <td class="value">
                        ${selected?.baseUser.userName}
                </tr>
                <tr>
                    <td><g:message code="customer.detail.user.status"/></td>
                    <td class="value">${selected?.baseUser.userStatus.description}</td>
                </tr>
                <tr>
                    <td><g:message code="prompt.partner.type"/></td>
                    <td class="value"><g:message code="PartnerType.${selected?.type}"/></td>
                </tr>
                <tr>
                    <td><g:message code="user.language"/></td>
                    <td class="value">${selected?.baseUser.language.getDescription()}</td>
                </tr>

                <tr>
                    <td><g:message code="customer.detail.user.created.date"/></td>
                    <td class="value"><g:formatDate date="${selected?.baseUser.createDatetime}" formatName="date.pretty.format"/></td>
                </tr>
                <tr>
                    <td><g:message code="user.last.login"/></td>
                    <td class="value"><g:formatDate date="${selected?.baseUser.lastLoginDate}" formatName="date.pretty.format"/></td>
                </tr>

                <tr>
                    <td><g:message code="user.locked"/></td>
                    <td class="value"><g:formatBoolean boolean="${selected?.baseUser?.isAccountLocked()}" true="Yes" false="No"/></td>
                </tr>

                <g:if test="${selected?.parent}">
                        <!-- empty spacer row -->
                        <tr>
                            <td colspan="2"><br/></td>
                        </tr>
                        <tr>
                            <td><g:message code="prompt.parent.id"/></td>
                            <td class="value">
                                <g:remoteLink action="show" id="${selected.parent.id}" before="register(this);" onSuccess="render(data, next);">
                                    ${selected?.parent?.id} - ${StringEscapeUtils.escapeHtml(selected?.parent?.baseUser?.userName)}
                                </g:remoteLink>
                            </td>
                        </tr>
                </g:if>

                <g:if test="${selected?.children}">
                    <!-- empty spacer row -->
                    <tr>
                        <td colspan="2"><br/></td>
                    </tr>

                    <!-- direct sub-accounts -->
                    <g:each var="account" in="${selected?.children.findAll{ it.baseUser.deleted == 0 }}">
                        <tr>
                            <td><g:message code="customer.subaccount.title" args="[ account.baseUser.id ]"/></td>
                            <td class="value">
                                <g:remoteLink action="show" id="${account.id}" before="register(this);" onSuccess="render(data, next);">
                                    ${StringEscapeUtils.escapeHtml(account?.baseUser?.userName)}
                                </g:remoteLink>
                            </td>
                        </tr>
                    </g:each>
                </g:if>

                <g:if test="${selected?.metaFields}">
                    <!-- empty spacer row -->
                    <tr>
                        <td colspan="2"><br/></td>
                    </tr>
                    <g:render template="/metaFields/metaFields" model="[metaFields: selected?.metaFields]"/>
                </g:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- partner details -->
    <div class="heading">
        <strong><g:message code="partner.details.title"/></strong>
    </div>
    <g:if test="${selected}">
    <div class="box">
        <div class="sub-box">
            <table class="dataTable" cellspacing="0" cellpadding="0">
                <tbody>
                <tr>
                    <td><g:message code="partner.detail.number.of.customers"/></td>
                    <td class="value">
                        <g:link controller="customer" action="partner" id="${selected?.id}">
                            ${selected?.customers?.size()}
                        </g:link>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
    </g:if>
    
    <!-- contact details -->
    <div class="heading">
        <strong><g:message code="customer.detail.contact.title"/></strong>
    </div>
    <g:if test="${contact}">
    <div class="box">

        <div class="sub-box">
            <table class="dataTable" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td><g:message code="customer.detail.user.email"/></td>
                        <td class="value"><a href="mailto:${contact?.email}">${contact?.email}</a></td>
                    </tr>
                    <tr>
                        <td><g:message code="customer.detail.contact.telephone"/></td>
                        <td class="value">
                            <g:if test="${contact.phoneCountryCode}">${contact.phoneCountryCode}.</g:if>
                            <g:if test="${contact.phoneAreaCode}">${contact.phoneAreaCode}.</g:if>
                            ${contact.phoneNumber}
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="customer.detail.contact.address"/></td>
                        <td class="value">${contact.address1} ${contact.address2}</td>
                    </tr>
                    <tr>
                        <td><g:message code="customer.detail.contact.city"/></td>
                        <td class="value">${contact.city}</td>
                    </tr>
                    <tr>
                        <td><g:message code="customer.detail.contact.state"/></td>
                        <td class="value">${contact.stateProvince}</td>
                    </tr>
                    <tr>
                        <td><g:message code="customer.detail.contact.country"/></td>
                        <td class="value">${contact.countryCode}</td>
                    </tr>
                    <tr>
                        <td><g:message code="customer.detail.contact.zip"/></td>
                        <td class="value">${contact.postalCode}</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    </g:if>

    <div class="btn-box">
        <div class="row">
            <g:link controller="partner" action="edit" id="${selected.id}" class="submit edit"><span><g:message code="button.edit"/></span></g:link>
            <a onclick="showConfirm('delete-${selected.id}');" class="submit delete"><span><g:message code="button.delete"/></span></a>
                <g:link controller="user" action="userCodeList" id="${selected.baseUser.id}" class="submit show"><span><g:message code="button.userCode.list"/></span></g:link>
            <g:if test="${selected.parent == null}">
                <g:link action="edit" params="[parentId: selected.id]" class="submit add"><span><g:message code="partner.add.subaccount.button"/></span></g:link>
            </g:if>
            <g:link controller="partner" action='showCommissionRuns' id="${selected.id}" class="submit show"><span><g:message code="button.showCommissions"/></span></g:link>
        </div>
    </div>

    <g:render template="/confirm"
              model="['message': 'partner.delete.confirm',
                      'controller': 'partner',
                      'action': 'delete',
                      'id': selected.id,
                     ]"/>

</div>
