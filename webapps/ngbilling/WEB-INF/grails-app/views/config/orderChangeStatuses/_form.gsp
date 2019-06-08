<%@ page import="com.sapienter.jbilling.server.util.ServerConstants; com.sapienter.jbilling.server.util.db.LanguageDTO" %>

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

<div class="form-edit">

    <div class="heading">
        <strong><g:message code="configuration.title.orderChangeStatuses"/></strong>
    </div>
    <div class="form-hold">
        <div class="form-columns single">
            <g:applyLayout name="form/select">
                <content tag="label"><g:message code="configuration.orderChangeStatuses.edit.for.language"/></content>
                <content tag="label.for">filterStatusId</content>
                <g:select id="language_selector"
                        from="${languages}"
                        optionKey="id" optionValue="description"
                        name="languageId"
                        onchange="onLanguageChange(this);"
                        value="${ServerConstants.LANGUAGE_ENGLISH_ID}"/>
            </g:applyLayout>
        </div>
    </div>

    <g:form name="save-orderChangeStatuses-form" action="saveOrderChangeStatuses">
        <g:render template="/config/orderChangeStatuses/statuses" model="[statuses: statuses, languages: languages]"/>
    </g:form>

    <g:javascript>
        function onLanguageChange(selector) {
            var languageId = $(selector).val();
            $("div[class^='lang_description']").hide();
            $('div.lang_description_' + languageId).show();
            if (languageId != ${ServerConstants.LANGUAGE_ENGLISH_ID}) {
                $('div.lang_description_' + ${ServerConstants.LANGUAGE_ENGLISH_ID}).show();
            }
        }
    </g:javascript>



</div>