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

<%--
  Shows a contact type.

  @author Brian Cowdery
  @since  27-Jan-2011
--%>

<div class="column-hold">
    <div class="heading">
        <strong>
            ${selected.getDescription(session['language_id'])}
            <em>${selected.id}</em>
        </strong>
    </div>

    <div class="box">
        <div class="sub-box">
          <fieldset>
            <div class="form-columns">
                <g:applyLayout name="form/text">
                    <content tag="label"><g:message code="contact.type.label.primary"/></content>
                    <g:formatBoolean boolean="${selected?.isPrimary > 0}"/>
                </g:applyLayout>

                <g:each var="language" in="${languages}">
                    <g:applyLayout name="form/text">
                        <content tag="label">${language.description}</content>
                        ${selected?.getDescriptionDTO(language.id)?.getContent()}
                    </g:applyLayout>
                </g:each>
            </div>
        </fieldset>
      </div>
    </div>

    <div class="btn-box buttons">
        <div class="row"></div>
    </div>
</div>