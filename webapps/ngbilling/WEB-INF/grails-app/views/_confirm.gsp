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

<%--
    Popup confirmation dialog.

    This dialog can operate in both AJAX and non-AJAX modes. In AJAX mode a target can be re-rendered
    using the return value from the AJAX call (see g:formRemote #update).

    Parameters:
        controller  Name of the controller
        action      Name of the controller action
        id          ID value for the action

    Optional parameters:
        formParams  A map of key value parameters to pass to the action

        ajax        If true, use an AJAX remote form to call the defined controller/action/id
        update      Element to update with AJAX return value

        onYes       Javascript to execute when "Yes" is clicked
        onNo        Javascript to execute when "No" is clicked


    The rendered confirmation dialog can be shown hidden using the element ID "confirm-dialog-${action}-${name}" where the
    ID value is that of the passed ID value of the action.

    To open, use "$('#confirm-dialog-action-123'}').dialog('open');" or the shorthand "showConfirm('action-123');"
 --%>

<g:set var="name" value="${[action, id].collect{ it }.join('-')}"/>

<div id="confirm-dialog-${name}" class="bg-lightbox" title="<g:message code="popup.confirm.title"/>" style="display:none;">
    <!-- command form -->
    <g:if test="${ajax}">
        <g:formRemote name="confirm-command-form-${name}" url="[controller: controller, action: action, id: id]" update="${update}">
            <g:hiddenField name="id" value="${id}"/>
            <g:each var="param" in="${formParams?.entrySet()}">
                <g:if test="${param.value != null && param.value != 'null' }">
                    <g:hiddenField name="${param.key}" value="${param.value}"/>
                </g:if>
            </g:each>
        </g:formRemote>
    </g:if>
    <g:else>
        <g:form name="confirm-command-form-${name}" url="[controller: controller, action: action, id: id]">
            <g:hiddenField name="id" value="${id}"/>
            <g:each var="param" in="${formParams?.entrySet()}">
                <g:if test="${param.value != null && param.value != 'null' }">
                    <g:hiddenField name="${param.key}" value="${param.value}"/>
                </g:if>
            </g:each>
        </g:form>
    </g:else>

    <!-- confirm dialog content body -->
    <table style="margin: 3px 0 0 10px">
        <tbody><tr>
            <td valign="top">
                <img src="${resource(dir:'images', file:'icon34.gif')}" alt="confirm">
            </td>
            <td class="col2" style="padding-left: 7px">
            
            	<p id="confirm-dialog-${name }-msg">
	            	<g:if test="${message}">
		            	<g:message code="${message}" args="[id]"/>	
	            	</g:if>
            	</p>
                
            </td>
        </tr></tbody>
    </table>
</div>

<script type="text/javascript">
    $(function() {
        setTimeout(function() {
            $('#confirm-dialog-${name}.ui-dialog-content').remove();
            $('#confirm-dialog-${name}').dialog({
                autoOpen: false,
                height: 200,
                width: 375,
                modal: true,
                buttons: {
                    '<g:message code="prompt.yes"/>': function() {
                        <%out.println(onYes)%>;
                        $("#confirm-command-form-${name}").submit();
                        $(this).dialog('close');
                    },
                    '<g:message code="prompt.no"/>': function() {
                        <%out.println(onNo)%>;
                        $(this).dialog('close');
                    }
                }
            });
        }, 100);
    });


    function showConfirm(name) {
        $('#confirm-dialog-' + name).dialog('open');
    }
//This function can be used when two different dialog are present in single page.
    function showConfirmAnother(name) {
        $('#confirm-dialog-' + name).dialog('open');
    }
</script>
