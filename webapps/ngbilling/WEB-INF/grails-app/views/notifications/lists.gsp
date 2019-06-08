<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
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

<g:form>
	<g:hiddenField name="selectedId" value="0" />
	<div class="heading">
	    <strong><g:message code="title.notification"/></strong>
	    <strong><g:message code="title.notification.active"/></strong>
	</div>
	
	<div class="box">
		<div class="sub-box">
			<ul>
				<g:each in="${lst}" status="idx" var="dto">
					<li>
					<g:remoteLink action="edit" id="${dto.id}" 
				     			before="register(this);" onSuccess="render(data, next);">
						<strong><g:hiddenField id="typeId" name="typeId${idx}"
							value="${dto?.getId()}" /> ${StringEscapeUtils.escapeHtml(dto?.getDescription(languageId))}
						</strong>
	                    <strong><g:message code="table.id.format" args="[dto.id as String]"/></strong>
						<strong align="right">
							<g:set var="flag" value="${true}"/> 
							<g:each status="iter" var="var" in="${dto.getNotificationMessages()}">
								<g:if test="${languageId == var.getLanguage().getId() 
									&& var.getEntity().getId() == entityId && var.getUseFlag() > 0}">
									${message( code: 'prompt.yes')}
									<g:set var="flag" value="${false}"/>
								</g:if>
							</g:each> 
							<g:if test="${flag}">
								${message( code: 'prompt.no')}
							</g:if>
						</strong>
					</g:remoteLink>
					</li>
				</g:each>
			</ul>
		</div>
	</div>
	
	<%-- 
	<script language="javascript">
	$(function ()
	{
		$('.sub-table tr', this).click(function()
		{
			$(".Highlight").removeClass();
			$(this).addClass('Highlight');
		});

		$('.sub-table tr', this).dblclick(function()
		{
			var typeId = $(this).find("#typeId").val();	    	
	    	document.getElementById("selectedId").value= typeId;	
			document.forms[0].action='/jbilling/notifications/edit/' + typeId;
			document.forms[0].submit();
		});
	});
	</script>
	<div>
	<table id="catTbl" cellspacing='4' class="sub-table">
		<thead>
			<tr>
				<th><g:message code="title.notification" /></th>
				<th><g:message code="title.notification.active" /></th>
			</tr>
		</thead>
		<tbody>
			<g:each in="${lst}" status="idx" var="dto">
				<tr>
					<td><g:hiddenField id="typeId" name="typeId${idx}"
						value="${dto?.getId()}" /> ${dto.getDescription(languageId)}
					</td>
					<td align="right"><g:set var="flag" value="${true}" /> 
						<g:each status="iter" var="var" in="${dto.getNotificationMessages()}">
						<g:if test="${languageId == var.getLanguage().getId() 
							&& var.getEntity().getId() == entityId && var.getUseFlag() > 0}">
							Yes
							<g:set var="flag" value="${false}" />
						</g:if>
					</g:each> <g:if test="${flag}">
						No
					</g:if></td>
				</tr>
			</g:each>
		</tbody>
	</table>
	</div>
	--%>
</g:form>
