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


<%@ page import="com.sapienter.jbilling.server.util.db.EnumerationDTO; com.sapienter.jbilling.server.util.ServerConstants" %>

<%--
  Account Information Type Details view

  @author Panche Isajeski
  @since 05/24/2013
--%>


<g:set var="isNew" value="${!ait || !ait?.id || ait?.id == 0}"/>

<div id="details-box">
    <br/>
    <div id="error-messages" class="msg-box error" style="display: none;">
        <ul></ul>
    </div>

    <g:formRemote name="ait-details-form" url="[action: 'editAIT']" update="column2" method="GET">
        <g:hiddenField name="_eventId" value="update"/>
        <g:hiddenField name="execution" value="${flowExecutionKey}"/>

        <div class="form-columns">

            <g:applyLayout name="form/text">
                <content tag="label"><g:message code="account.information.type.id.label"/></content>

                <g:if test="${!isNew}">
                    <span>${ait.id}</span>
                </g:if>
                <g:else>
                    <em><g:message code="prompt.id.new"/></em>
                </g:else>

                <g:hiddenField name="ait.id" value="${ait?.id}"/>
            </g:applyLayout>

            <g:applyLayout name="form/input">
                <content tag="label">
                <g:message code="account.information.type.name.label" /></content>
                <content tag="label.for">name</content>
                <g:textField class="field text" name="name" value="${ait?.name}"/>
            </g:applyLayout>

            <g:applyLayout name="form/text">
                <content tag="label">
                    <g:message code="account.information.type.display.label" /></content>
                <content tag="label.for">displayOrder</content>
                <div class="inp-bg inp4">
                    <g:textField class="field" name="displayOrder" value="${ait?.displayOrder}"/>
                </div>
            </g:applyLayout>
            <g:applyLayout name="form/checkbox">
                <content tag="label"><g:message code="prompt.use.in.notifications"/></content>
                <content tag="label.for">useForNotifications</content>
                <g:checkBox id="useForNotifications" class="cb checkbox" name="useForNotifications" checked="${ait?.useForNotifications}"/>
            </g:applyLayout>
        </div>

    </g:formRemote>


<script type="text/javascript">

    var submitForm = function() {
        var form = $('#ait-details-form');
        form.submit();
    };

    $('#ait-details-form').find('input.text').blur(function() {
        submitForm();
    });

    $('#ait-details-form').find('input').blur(function() {
        submitForm();
    });

    var validator = $('#ait-details-form').validate();
    validator.init();
    validator.hideErrors();


    $('#useForNotifications').click(function() {
		$('#infoTypeName-change-dialog').dialog('open');
	});

    $('#infoTypeName-change-dialog').dialog({
        autoOpen: false,
        height: 200,
        width: 375,
        modal: true,
        buttons: {
            '<g:message code="prompt.yes"/>': function() {
                if(!$('#useForNotifications').is(':checked')) {
				$('#useForNotifications').prop('checked', false);
                } else {
			$('#useForNotifications').prop('checked', true);
                }

                $(this).dialog('close');
            },
            '<g:message code="prompt.no"/>': function() {
		if($('#useForNotifications').is(':checked')) {
			$('#useForNotifications').prop('checked', false);
		} else {
			$('#useForNotifications').prop('checked', true);
                }

                $(this).dialog('close');
            }
        }
    });

</script>
<div id="infoTypeName-change-dialog" title="${message(code: 'popup.confirm.title')}">
        <table style="margin: 3px 0 0 10px">
            <tbody>
            <tr>
                <td valign="top">
                    <img src="${resource(dir:'images', file:'icon34.gif')}" alt="confirm">
                </td>
                <td class="col2" style="padding-left: 7px">
                    <g:message code="ait.prompt.checked.notification" />
                </td>
            </tr>
            </tbody>
        </table>
</div>

</div>