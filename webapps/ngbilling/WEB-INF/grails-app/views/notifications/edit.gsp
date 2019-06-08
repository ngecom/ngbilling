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
<%@page import="com.sapienter.jbilling.server.util.ServerConstants"%>
<%@page import="com.sapienter.jbilling.server.notification.NotificationMediumType"%>


<html>
<head>
    <meta name="layout" content="main" />

	<r:script>
		//test cursor position code
		var targetElement;
		var position;
		var glFlag= false;//implement onchange
		var askPreference='${askPreference}';
		var callAction= null;
        
		$(function (){
			//alert('on document ready' + ${languageId});
			$("#language.id").val(${languageId});
		});
		
		//function Show_Popup(action, userid) {	
		//	$('#popup').fadeIn('fast');
		//	$('#window').fadeIn('fast');
		//}
		
		function Close_Popup(popUpRef) {	
			checkCookieValue();
			justGo();
		}
		
		function checkCookieValue(){
			//alert("Called checkcookievalue()");
			var doNotAskJS = $('#popupCheckbox:checked').val();	
			//alert('Checbox value=' + doNotAskJS);
			if ('on' == doNotAskJS) {
				//alert("its on");
				$('#doNotAskAgain').val(true);
			} else {
				$('#doNotAskAgain').val(false);
			}
		}
		
		function anychange(elm) {
			glFlag=true;
			elementClick(elm);
		}
		
		function saveFirst(popUpRef) {
			$(popUpRef).dialog('close');
			checkCookieValue();
			$('#askPreference').val('saveFirst');
			glFlag=false;
			document.forms["notifications"].action='/jbilling/notifications/saveAndRedirect/' + $('#_id').val();
            document.forms["notifications"].submit();
		}
		
		function justGo(){
			glFlag= false;
			$('#askPreference').val('justGo');
			//alert (document.getElementById('language.id').value);
		    document.forms["notifications"].action='/jbilling/notifications/edit/' + $('#_id').val();
		    document.forms["notifications"].submit();	
		}

        function cancelAfterChange() { 
        	if (glFlag) {
                if ( null == askPreference || '' == askPreference ) {
                	callAction= 'saveAndCancel';
                    showConfirm('saveAndCancel-' + ${params.id});
                    return false;
                }
        	} else { return true; }
        }

        function saveAndCancel(popUpRef) {
            $(popUpRef).dialog('close');
            $('#askPreference').val('saveFirst');
            glFlag=false;
            document.forms["notifications"].action='/jbilling/notifications/saveAndCancel/' + $('#_id').val();
            document.forms["notifications"].submit();
        }

        function cancelNoSave(popUpRef) {
            $(popUpRef).dialog('close');
            glFlag=false;
            document.forms["notifications"].action='/jbilling/notifications/cancelEdit/' + $('#_id').val();
            document.forms["notifications"].submit();
        }
		
		function lchange() {
			if (glFlag) {
				if ( null == askPreference || '' == askPreference ) {
                    //Show_Popup(null,null);
					showConfirm('saveAndRedirect-' + ${params.id});
				} else if ('saveFirst' == askPreference ) {
					saveFirst();
				} else {
					justGo();
				}			
			} else {
				justGo();	
			}
		}
		
		function elementClick(tempElm) { 
			//alert('msie=' + $.browser.msie);
			//alert('mozilla='+$.browser.mozilla);	
			targetElement= tempElm;
			//position= tempElm.SelectionStart
		}
		
		function testfunc(testval) { 
			//alert ('testfunc called. Elm=' + testval);
            if ( null == targetElement || targetElement.name == 'useFlag') {
                return;
            }
            //alert(targetElement.name + " and value " + testval);
            
			if ($.browser.msie) {
				//if (document.selection) {
					targetElement.focus();
					sel = document.selection.createRange();
					sel.text = testval;
				//}
			} else if ($.browser.mozilla) {
				//alert('not ie');
				var startPos = targetElement.selectionStart;
				var endPos = targetElement.selectionEnd;
				//alert('Start=' + startPos + ' End=' + endPos);
				targetElement.value = targetElement.value.substring(0, startPos)
    				+ testval
    				+ targetElement.value.substring(endPos, targetElement.value.length);
			} else {
				targetElement.value+=testval;
			}
			//to record changes
			glFlag=true;
			//alert(targetElement.Text);
			//alert(targetElement.SelectionStart);
			//alert(targetElement.Text.Substring(0, targetElement.SelectionStart).Length);
		}

        function toggleSelect(element){
           var valueCheckbox = $(element).is(':checked')
           if(valueCheckbox) {
               enableSelect('#selectAttType');
               enableSelect('#attDesign');
           }
           else {
               disableSelect('#selectAttType');
               disableSelect('#attDesign');
           }
        }

        function enableSelect(element) {
            $(element).removeAttr('disabled');
        }

        function disableSelect(element) {
           $(element).attr('disabled','disabled');
        }

	</r:script>

    <g:if test="${dto?.includeAttachment!=1}">
        <script type="text/javascript">
            $(function () {
                disableSelect('#selectAttType');
                disableSelect('#attDesign');
		});
        </script>
    </g:if>

<style type="text/css">
    <!--
    div.scroll {
        height: 400px;
        width: 350px;
        overflow: auto;
        border: 1px solid #666;
        padding: 1px;
        position:relative;
        float:right;
    }
    -->
<%--  
	#popup {
		height: 100%;
		width: 100%;
		background: #000000;
		position: absolute;
		top: 0;
		-moz-opacity: 0.75;
		-khtml-opacity: 0.75;
		opacity: 0.75;
		filter: alpha(opacity = 75);
	}
	
	#window {
		width: 600px;
		height: 300px;
		margin: 0 auto;
		border: 1px solid #000000;
		background: #ffffff;
		position: absolute;
		top: 200px;
		left: 25%;
	}
--%>
</style>
</head>
<body>

<div class="form-edit">
	<div class="heading">
		<strong>
			<g:message code="prompt.edit.notification"/> - ${dto?.notificationMessageType?.getDescription(languageId)}
		</strong>
	</div>

	<div class="form-hold">
    	<g:form name="notifications" controller="notifications" action="saveNotification">
    
    		<g:hiddenField name="_id" value="${params.id}" />
    		<g:hiddenField id="doNotAskAgain" name="doNotAskAgain" value="${false}"/>
    		<g:hiddenField id="askPreference" name="askPreference" value="${askPreference}"/>
    		<g:hiddenField name="msgDTOId" value="${dto?.getId()}" />
    		<g:hiddenField name="entity.id" value="${entityId}" />
    		<g:hiddenField name="_languageId" value="${languageId}"/>
    
    		<fieldset>
    			<div class="form-columns">
    				<div class="column" style="width:70%;">
    					<div class="row">
    						<label for="useFlag"><g:message code="title.notification.active"/>:</label>
    						<div class="checkboxArea">
    							<g:checkBox onchange="anychange(this)" name="useFlag" style="height: 15px;"
    								checked="${(dto?.getUseFlag() > 0)}" class="cb checkbox"/>
    						</div>
    					</div>
    					<div class="row">
    						<label><g:message code="prompt.edit.notification.language" />:</label>
    						<div style="width: 220px; " class="selectArea">
    							<g:select name="language.id"
    								from="${com.sapienter.jbilling.server.util.db.LanguageDTO.list()}"
    								optionKey="id" optionValue="description" value="${languageId}"
    								onchange="lchange()" />
    						</div>
    					</div>
    					<g:set var="flag" value="${true}" />
    					<div class="row">
    						<label><g:message code="prompt.edit.notification.subject" />:</label>
    						<div class="inp-bg">
    							<g:each in="${dto?.getNotificationMessageSections()}"
    								var="section">
    								<g:if test="${(section.section == 1)}">
    									<g:hiddenField
    										name="messageSections[${section.section}].id"
    										value="${section.id}" />
    									<g:hiddenField
    										name="messageSections[${section.section}].section"
    										value="${section.section}" />
    									<g:set var="tempContent" value="" />
    									<g:each in="${section.getNotificationMessageLines().sort{it.id}}"
    										var="line">
    										<g:set var="tempContent"
    											value="${tempContent=tempContent + line?.getContent()}" />
    									</g:each>
    									<input class="field" type="text" onclick="elementClick(this)" onChange="anychange(this)" size="30"
    										name="messageSections[${section.section}].notificationMessageLines.content"
    										value="${tempContent}" />
    									<g:set var="flag" value="${false}" />
    								</g:if>
    							</g:each> 
    							<g:if test="${flag}">
    								<g:hiddenField
    										name="messageSections[1].id" value="" />
    								<g:hiddenField
    										name="messageSections[1].section" value="1" />
    								<g:textField class="field" onclick="elementClick(this)" onchange="anychange(this)" size="30"
    									name="messageSections[1].notificationMessageLines.content"
    									value="" />
    							</g:if>
    						</div>
    					</div>

                        <g:if test="${dto == null}"><g:set var="mediumTypes" value="${new ArrayList<>(Arrays.asList(NotificationMediumType.values()))}"/></g:if>
                        <g:else><g:set var="mediumTypes" value="${dto?.mediumTypes}"/></g:else>
                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="prompt.edit.notification.mediumTypes"/></content>
                            <content tag="label.for">mediumTypes</content>
                            <g:select name="mediumTypes" multiple="true"
                                      from="${NotificationMediumType.values()}"
                                      value="${mediumTypes}"/>
                        </g:applyLayout>
                        <div class="row">
    						<label for="includeAttachment"><g:message code="prompt.notification.attachment.add" default="Add Attachment?"/>:</label>
    						<div class="checkboxArea">
    					        <g:checkBox name="includeAttachment" class="cb checkbox" onchange="toggleSelect(this);" checked="${(dto?.getIncludeAttachment() > 0)}" style="height: 15px;"/>
    						</div>
    					</div>
                        <div class="row">
    						<label><g:message code="prompt.select.notification.type" default="Select Type" />:</label>
    						<div style="width: 220px; " class="selectArea">
                                <g:select id="selectAttType" name="attachmentType" from="${['pdf']}"/>
    						</div>
    					</div>
                        <div class="row">
    						<label><g:message code="prompt.notification.design" default="Enter Design" />:</label>
                                <g:textField id="attDesign" name="attachmentDesign" value="${dto?.attachmentDesign}" size="30"/>
    					</div>
                        <div class="row">
                            <div style="display: inline">
                                <label for="notifyUser"><g:message code="prompt.notification.user" default="Notify User?"/>:</label>
                                <div class="checkboxArea">
                                    <g:checkBox name="notifyUser" class="cb checkbox" onchange="toggleSelect(this);" checked="true" style="height: 15px;" disabled="true"/>
                                </div>
                            </div>
                            <div style="display: inline">
                                <label for="notifyParent"><g:message code="prompt.notification.parent" default="Notify Parent?"/>:</label>
                                <div class="checkboxArea">
                                    <g:checkBox name="notifyParent" class="cb checkbox" onchange="toggleSelect(this);"  checked="${(dto?.getNotifyParent() > 0)}" style="height: 15px;"/>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div style="display: inline">
                                <label for="notifyAdmin"><g:message code="prompt.notification.admin" default="Notify Admin?"/>:</label>
                                <div class="checkboxArea">
                                    <g:checkBox name="notifyAdmin" class="cb checkbox" onchange="toggleSelect(this);"  checked="${(dto?.getNotifyAdmin() > 0)}" style="height: 15px;"/>
                                </div>
                            </div>
                            <div style="display: inline">
                                <label for="notifyAllParents"><g:message code="prompt.notification.all.parents" default="Notify All Parents?"/>:</label>
                                <div class="checkboxArea">
                                    <g:checkBox name="notifyAllParents" class="cb checkbox" onchange="toggleSelect(this);"  checked="${(dto?.getNotifyAllParents() > 0)}" style="height: 15px;"/>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <label for="notifyPartner"><g:message code="prompt.notification.partner" default="Notify Partner?"/>:</label>
                            <div class="checkboxArea">
                                <g:checkBox name="notifyPartner" class="cb checkbox" onchange="toggleSelect(this);"  checked="${(dto?.getNotifyPartner() > 0)}" style="height: 15px;"/>
                            </div>
                        </div>
    					<g:set var="flag" value="${true}" />
    					<div class="row">
    						<label><g:message code="prompt.edit.notification.bodytext" />:</label>
    						<div style='float: left;' >
    							<g:each in="${dto?.getNotificationMessageSections()}"
    								var="section">
    								<g:if test="${(section.section == 2)}">
    									<g:hiddenField
    										name="messageSections[${section.section}].id"
    										value="${section.id}" />
    									<g:hiddenField
    										name="messageSections[${section.section}].section"
    										value="${section.section}" />
    									<g:set var="tempContent" value="" />
    									<g:each in="${section.getNotificationMessageLines().sort{it.id}}"
    										var="line">
    										<g:set var="tempContent"
    											value="${tempContent=tempContent + line?.getContent()}" />
    									</g:each>
    									<g:textArea class="field" onclick="elementClick(this)" onchange="anychange(this)" cols="20" rows="10"
    										name="messageSections[${section.section}].notificationMessageLines.content"
    										value="${tempContent}" />
    									<g:set var="flag" value="${false}" />
    								</g:if>
    							</g:each> 
    							<g:if test="${flag}">
    								<g:hiddenField
    										name="messageSections[2].id" value="" />
    								<g:hiddenField
    										name="messageSections[2].section" value="2" />
    								<g:textArea onclick="elementClick(this)" onchange="anychange(this)" cols="20" rows="10"
    									name="messageSections[2].notificationMessageLines.content"
    									value="" />
    							</g:if>
    						</div>
    					</div>
    					<g:set var="flag" value="${true}" />
    					<div class="row">
    						<label><g:message code="prompt.edit.notification.bodyhtml" />:</label>
    						<div style='float: left;'>
    							<g:each in="${dto?.getNotificationMessageSections()}"
    								var="section">
    								<g:if test="${(section?.section == 3)}">
    									<g:hiddenField
    										name="messageSections[${section.section}].id"
    										value="${section?.id}" />
    									<g:hiddenField
    										name="messageSections[${section.section}].section"
    										value="${section?.section}" />
    									<g:set var="tempContent" value="" />
    									<g:each in="${section?.getNotificationMessageLines().sort{it.id}}"
    										var="line">
    										<g:set var="tempContent"
    											value="${tempContent=tempContent + line?.getContent()}" />
    									</g:each>
    									<g:textArea  class="field" onclick="elementClick(this)" onchange="anychange(this)" cols="20" rows="10"
    										name="messageSections[${section.section}].notificationMessageLines.content"
    										value="${tempContent}" />
    									<g:set var="flag" value="${false}" />
    								</g:if>
    							</g:each>
    							<g:if test="${flag}">
    								<g:hiddenField
    										name="messageSections[3].id" value="" />
    								<g:hiddenField
    										name="messageSections[3].section" value="3" />
    								<g:textArea onclick="elementClick(this)" onchange="anychange(this)" cols="20" rows="10"
    									name="messageSections[3].notificationMessageLines.content"
    									value="" />
    							</g:if>
                            </div>
                        </div>
    				</div>
    				<!-- 
                    </div>
                    <div class="form-columns">
    				<div class="column">
    					<div class="row">
    					</div>
    				</div>
    				 -->
                    
                    <div class="scroll" style="width:25%;">
                        <div class="column" style="width:80%;">
            				<div class="row">
            					<label><g:message code="prompt.tokens"/> </label>
            				</div>
                            <g:render template="tokens/common"/>
                            
                            <g:if test="${messageTypeId == ServerConstants.NOTIFICATION_TYPE_INVOICE_REMINDER.intValue()}">
                                <g:render template="tokens/invoiceReminder"/>
                            </g:if>
                            
                            <g:if test="${messageTypeId == ServerConstants.NOTIFICATION_TYPE_INVOICE_EMAIL.intValue()}">
                                <g:render template="tokens/invoiceEmail"/>
                            </g:if>
                            
							<g:if test="${isOrderTypeNotification}">
                                <g:render template="tokens/orderExpiry"/>
                            </g:if>

							<g:if test="${isPaymentTypeNotification}">
								<g:render template="tokens/payment"/>
							</g:if>
                            
                            <g:if test="${messageTypeId == ServerConstants.NOTIFICATION_TYPE_CREDIT_CARD_UPDATE.intValue()}">
                                <g:render template="tokens/upgradeCC"/>
                            </g:if>
                            
                            <g:if test="${messageTypeId == ServerConstants.NOTIFICATION_TYPE_USER_REACTIVATED.intValue()}">
                                <g:render template="tokens/ageingMessage"/>
                            </g:if>
                            
                        </div> <!-- column -->
                    </div> <!-- scroll -->
    			</div> <!-- form-columns -->
    		</fieldset>
            <div class="row">&nbsp;</div>
    		<div class="btn-box">
    			<a href="javascript:void(0)" onclick="$('#notifications').submit();" class="submit save">
    				<span><g:message code="button.save"/></span></a>
    			<a href="${createLink(action: 'cancelEdit', params: [id: messageTypeId])}" onclick="return cancelAfterChange();" class="submit cancel">
    					<span><g:message code="button.cancel"/></span></a>
    		</div>
    	</g:form>
	</div>
</div>

<g:render template="/confirm"
  model="[message: 'prompt.notifications.changed',
      controller: 'notifications',
      action: 'saveAndRedirect',
      id: params.id,
      onYes: 'saveFirst(this)',
      onNo: 'Close_Popup(this)',
      doNotSubmitPopup: true
     ]"/>

<g:render template="/confirm"
  model="[message: 'prompt.notifications.changed',
      controller: 'notifications',
      action: 'saveAndCancel',
      id: params.id,
      onYes: 'saveAndCancel(this)',
      onNo: 'cancelNoSave(this)',
      doNotSubmitPopup: true
     ]"/>
</body>
</html>
