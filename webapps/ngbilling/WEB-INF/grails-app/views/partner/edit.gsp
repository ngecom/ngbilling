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

<%@ page import="com.sapienter.jbilling.server.user.partner.PartnerCommissionType; com.sapienter.jbilling.server.user.partner.PartnerType; com.sapienter.jbilling.server.user.ContactWS; com.sapienter.jbilling.server.user.db.CompanyDTO" %>
<%@ page import="com.sapienter.jbilling.server.user.permisson.db.RoleDTO" %>
<%@ page import="com.sapienter.jbilling.common.CommonConstants" %>
<%@ page import="com.sapienter.jbilling.server.util.db.LanguageDTO" %>
<%@ page import="com.sapienter.jbilling.server.util.db.EnumerationDTO" %>
<%@ page import="com.sapienter.jbilling.server.process.db.PeriodUnitDTO" %>
<%@ page import="com.sapienter.jbilling.client.user.UserHelper" %>

<html>
<head>
    <meta name="layout" content="main"/>

    <style type="text/css">
    .date img {
        top: -20px !important;
        right: 2px !important;
    }
    </style>
</head>

<body>
<div class="form-edit">

<g:set var="isNew" value="${!user || !user?.userId || user?.userId == 0}"/>
<g:set var="defaultCurrency" value="${CompanyDTO.get(session['company_id']).getCurrency()}"/>

<div class="heading">
    <strong>
        <g:if test="${isNew}">
            <g:message code="partner.create.title"/>
        </g:if>
        <g:else>
            <g:message code="partner.edit.title"/>
        </g:else>
    </strong>
</div>

<div class="form-hold">
<g:form name="user-edit-form" action="save">
<fieldset>
<div class="form-columns">

<!-- user details column -->
<div class="column">
<g:applyLayout name="form/text">
    <content tag="label"><g:message code="prompt.customer.number"/></content>

    <g:if test="${!isNew}">
        <span>${partner.id}</span>
    </g:if>
    <g:else>
        <em><g:message code="prompt.id.new"/></em>
    </g:else>

    <g:hiddenField name="user.userId" value="${user?.userId}"/>
    <g:hiddenField name="id" value="${partner?.id}"/>

    <g:hiddenField name="totalPayments" value="${partner?.totalPayments ?: 0}"/>
    <g:hiddenField name="totalRefunds" value="${partner?.totalRefunds ?: 0}"/>
    <g:hiddenField name="totalPayouts" value="${partner?.totalPayouts ?: 0}"/>
    <g:hiddenField name="duePayout" value="${partner?.duePayout ?: 0}"/>

</g:applyLayout>

<g:if test="${isNew}">
    <g:applyLayout name="form/input">
        <content tag="label"><g:message code="prompt.login.name"/><span id="mandatory-meta-field">*</span></content>
        <content tag="label.for">user.userName</content>
        <g:textField class="field" name="user.userName" value="${user?.userName}"/>
    </g:applyLayout>
</g:if>
<g:else>
    <g:applyLayout name="form/text">
        <content tag="label"><g:message code="prompt.login.name"/><span id="mandatory-meta-field">*</span></content>

        ${user?.userName}
        <g:hiddenField name="user.userName" value="${user?.userName}"/>
    </g:applyLayout>
</g:else>

<g:if test="${!isNew && user?.userId == loggedInUser?.id}">
   
    <g:applyLayout name="form/input">
        <content tag="label"><g:message code="prompt.current.password"/><span id="mandatory-meta-field">*</span></content>
        <content tag="label.for">oldPassword</content>
        <g:passwordField class="field" name="oldPassword"/>
    </g:applyLayout>

    <g:applyLayout name="form/input">
        <content tag="label"><g:message code="prompt.password"/><span id="mandatory-meta-field">*</span></content>
        <content tag="label.for">newPassword</content>
        <g:passwordField class="field" name="newPassword"/>
    </g:applyLayout>

    <g:applyLayout name="form/input">
        <content tag="label"><g:message code="prompt.verify.password"/><span id="mandatory-meta-field">*</span></content>
        <content tag="label.for">verifiedPassword</content>
        <g:passwordField class="field" name="verifiedPassword"/>
    </g:applyLayout>
</g:if>

<!-- PARTNER CREDENTIALS -->
<g:if test="${isNew}">
    <g:preferenceEquals preferenceId="${CommonConstants.PREFERENCE_CREATE_CREDENTIALS_BY_DEFAULT}" value="0">
        <g:applyLayout name="form/checkbox">
            <content tag="label"><g:message code="prompt.create.credentials"/></content>
            <content tag="label.for">user.createCredentials</content>
            <g:checkBox class="cb checkbox" name="user.createCredentials" checked="${user?.createCredentials}"/>
        </g:applyLayout>
    </g:preferenceEquals>
</g:if>

<g:applyLayout name="form/select">
    <content tag="label"><g:message code="prompt.user.status"/></content>
    <content tag="label.for">user.statusId</content>
    <g:userStatus name="user.statusId" value="${user?.statusId}" languageId="${session['language_id']}"/>
</g:applyLayout>

<g:applyLayout name="form/select">
    <content tag="label"><g:message code="prompt.user.language"/></content>
    <content tag="label.for">user.languageId</content>
    <g:select name="user.languageId" from="${LanguageDTO.list()}"
              optionKey="id" optionValue="description" value="${user?.languageId}"/>
</g:applyLayout>

<g:applyLayout name="form/select">
    <content tag="label"><g:message code="prompt.user.currency"/></content>
    <content tag="label.for">user.currencyId</content>
    <g:select name="user.currencyId"
              from="${currencies}"
              optionKey="id"
              optionValue="${{ it.getDescription() }}"
              value="${user?.currencyId ?: defaultCurrency?.id}"/>
</g:applyLayout>

<g:applyLayout name="form/text">
    <content tag="label"><g:message code="prompt.user.role"/></content>
    <content tag="label.for">user.mainRoleId</content>

    <g:hiddenField name="user.mainRoleId" value="${CommonConstants.TYPE_PARTNER}"/>
    ${RoleDTO.findByRoleTypeId(CommonConstants.TYPE_PARTNER)?.getTitle(session['language_id'])}
</g:applyLayout>

<g:set var="isReadOnly" value="true"/>
<sec:ifAllGranted roles="CUSTOMER_11">
    <g:set var="isReadOnly" value="false"/>
</sec:ifAllGranted>
<g:applyLayout name="form/checkbox">
    <content tag="label"><g:message code="user.account.lock"/></content>
    <content tag="label.for">user.isAccountLocked</content>
    <g:checkBox class="cb checkbox" name="user.isAccountLocked" checked="${user?.isAccountLocked}" disabled="${isReadOnly}"/>
</g:applyLayout>

<g:applyLayout name="form/select">
    <content tag="label"><g:message code="prompt.partner.type"/></content>
    <content tag="label.for">type</content>
    <g:select name="type"
              from="${PartnerType.values()}"
              valueMessagePrefix="PartnerType"
              value="${partner?.type?PartnerType.valueOf(partner?.type):partner?.type}"/>
</g:applyLayout>

<g:applyLayout name="form/select">
    <content tag="label"><g:message code="prompt.partner.commissionType"/></content>
    <content tag="label.for">commissionType</content>
    <g:select name="commissionType"
              from="${PartnerCommissionType.values()}"
              valueMessagePrefix="PartnerCommissionType"
              noSelection="['': message(code: 'default.no.selection')]"
              value="${partner?.commissionType?PartnerCommissionType.valueOf(partner?.commissionType):partner?.commissionType}"/>
</g:applyLayout>

<g:if test="${partner?.parentId || !parentId}">
    <g:applyLayout name="form/input">
        <content tag="label"><g:message code="prompt.parent.id"/></content>
        <content tag="label.for">parentId</content>
        <g:textField class="field" name="parentId" value="${partner.parentId ?: parentId}"/>
    </g:applyLayout>
</g:if>
<g:else>
    <g:applyLayout name="form/text">
        <content tag="label"><g:message code="prompt.parent.id"/></content>
        ${parentId}
        <g:hiddenField class="field" name="parentId" value="${parentId}"/>
    </g:applyLayout>
</g:else>

</div>


<!-- contact information column -->
<div class="column">

    <g:set var="contact" value="${contacts && contacts.size > 0 ? contacts[0] : new ContactWS()}"/>
    <g:render template="/customer/contact" model="[contact: contact]"/>

    <br/>&nbsp;

<!-- customer meta fields -->
<g:render template="/metaFields/editMetaFields" model="[
        availableFields: availableFields, fieldValues: user?.metaFields]"/>

</div>

</div>
<!-- commission exceptions -->
<div id="commission-exception" class="box-cards">
    <div class="box-cards-title">
        <a class="btn-open" href="#"><span><g:message code="partner.commission.exception"/></span></a>
    </div>

    <div class="box-card-hold">
        <g:render template="commissionExceptions" model="[partner: partner]"/>
    </div>
</div>

<div><br/></div>

<!-- referral commissions -->
<div id="referral-commissions" class="box-cards">
    <div class="box-cards-title">
        <a class="btn-open" href="#"><span><g:message code="partner.referral.commissions"/></span></a>
    </div>

    <div class="box-card-hold">
        <g:render template="referralCommissions" model="[partner: partner]"/>
    </div>
</div>

<div><br/></div>

<div class="buttons">
    <ul>
        <li>
            <a onclick="$('#user-edit-form').submit()" class="submit save"><span><g:message code="button.save"/></span>
            </a>
        </li>
        <li>
            <g:link action="list" class="submit cancel"><span><g:message code="button.cancel"/></span></g:link>
        </li>
    </ul>
</div>

</fieldset>
</g:form>
</div>
</div>
</body>
</html>
