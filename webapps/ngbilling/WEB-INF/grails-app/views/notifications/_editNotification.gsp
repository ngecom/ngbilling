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
  Shows an edit form for a currency (used to create new currencies).

  @author Shweta Gupta
  @since  11-Jun-2012
--%>

<div class="column-hold">
    <div class="heading">
        <strong>
                <g:message code="notification.add.title"/>
        </strong>
    </div>

    <g:form name="save-notification-form" url="[action: 'saveNotificationMessage']">

        <div class="box">
            <div class="sub-box">
              <fieldset>
                <div class="form-columns">
                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="notification.id"/></content>

                        <em><g:message code="prompt.id.new"/></em>
                    </g:applyLayout>

                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="notification.category.description"/></content>

                        <em>${category?.description}</em>

                        <g:hiddenField name="categoryId" value="${category?.id}"/>
                    </g:applyLayout>


                    <g:applyLayout name="form/input">
                        <content tag="label"><g:message code="notification.description"/></content>
                        <content tag="label.for">description</content>
                        <g:textField class="field" name="description" />
                    </g:applyLayout>
                </div>
            </fieldset>
          </div>
        </div>

    </g:form>

    <div class="buttons">
        <ul>
            <li><a onclick="$('#save-notification-form').submit();" class="submit save"><span><g:message code="button.save"/></span></a></li>
            <li><g:link action="list" id="${selectedCategoryId}" class="submit cancel"><span><g:message code="button.cancel"/></span></g:link></li>
        </ul>
    </div>
</div>
