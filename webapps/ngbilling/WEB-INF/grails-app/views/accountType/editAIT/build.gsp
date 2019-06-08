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

<%@ page import="com.sapienter.jbilling.server.metafields.DataType" contentType="text/html;charset=UTF-8" %>

<%--
  Account Information Type builder view

  @author Panche Isajeski
  @since 05/24/2013
--%>

<g:if test="${params.template}">
    <!-- render the template -->
    <g:render template="${params.template}"/>
</g:if>

<g:else>

    <html>
    <head>

        <meta name="layout" content="builder"/>
        <r:require module="errors" />
        <r:script disposition="head">
            $(document).ready(function() {
                $('#builder-tabs').tabs();

                // prevent the Save Changes button to be clicked more than once.
                $('.ait-btn-box .submit.save').on('click', function (e) {
                    var saveInProgress = $('#saveInProgress').val();

                    if (saveInProgress == "true") {
                        e.preventDefault();
                    } else {
                        $('#saveInProgress').val("true");
                    }
                });
                changeMetafieldDataType();
            });

            function changeMetafieldDataType(){
               $('#metaField\\.dataType').on("change", function() {
                if ($(this).val() == '${DataType.ENUMERATION}' || $(this).val() == '${DataType.LIST}') {
                    $('.field-name').hide().find('input').prop('disabled', 'true');
                    $('.field-enumeration').show().find('select').prop('disabled', '');
                    $('.field-filename').hide().find('input').prop('disabled', 'true')
                } else if ($(this).val() == '${DataType.SCRIPT}'){
                    $('.field-name').show().find('input').prop('disabled', '');
                    $('.field-enumeration').hide().find('select').prop('disabled', 'true');
                    $('.field-filename').show().find('input').prop('disabled', '')
                } else {
                    $('.field-name').show().find('input').prop('disabled', '');
                    $('.field-enumeration').hide().find('select').prop('disabled', 'true');
                    $('.field-filename').hide().find('input').prop('disabled', 'true')
                }
            }).change();
		}
        </r:script>
    </head>
    <body>
    <content tag="builder">
        <div id="builder-tabs">
            <ul>
                <li><a href="${createLink(action: 'editAIT', event: 'details')}"><g:message code="account.information.type.details.title"/></a></li>
                <li><a href="${createLink(action: 'editAIT', event: 'metaFields')}"><g:message code="account.information.type.metafields.title"/></a></li>
                <g:if test="${ait?.id == 0}">
                    <li><a href="${createLink(action: 'editAIT', event: 'metaFieldGroups')}"><g:message code="account.information.type.metafield.groups.title"/></a></li>
                </g:if>
            </ul>
        </div>

        <div class="btn-box ait-btn-box">
            <g:remoteLink class="submit save" action="editAIT" params="[_eventId: 'addMetaField']" update="column2" method="GET">
                <span><g:message code="button.new.metafield"/></span>
            </g:remoteLink>
        </div>

    </content>

    <content tag="review">
        <g:render template="reviewAIT"/>
    </content>
    </body>
    </html>

</g:else>