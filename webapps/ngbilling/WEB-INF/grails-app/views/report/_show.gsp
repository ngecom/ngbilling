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

<%@ page import="com.sapienter.jbilling.server.report.ReportExportFormat; com.sapienter.jbilling.server.user.db.CompanyDTO" %>

<%--
  Report details template.

  @author Brian Cowdery
  @since  07-Mar-2011
--%>

<%
	def company = CompanyDTO.get(session['company_id'])
	def childEntities = CompanyDTO.findAllByParent(company)
%>
<div class="column-hold">
    <div class="heading">
        <strong><g:message code="${selected.name}"/></strong>
    </div>
    <g:form name="run-report-form" url="[action: 'run', id: selected.id]" target="_blank" method="GET">
        <div class="box">
            <div class="sub-box">
              <!-- report info -->
              <table class="dataTable" cellspacing="0" cellpadding="0">
                  <tbody>
                  <tr>
                      <td><g:message code="report.label.id"/></td>
                      <td class="value">${selected.id}</td>
                  </tr>
                  <tr>
                      <td><g:message code="report.label.type"/></td>
                      <td class="value">${selected.type.getDescription(session['language_id'])}</td>
                  </tr>
                  <tr>
                      <td><g:message code="report.label.design"/></td>
                      <td class="value">
                          <em title="${selected.reportFilePath}">${selected.fileName}</em>
                      </td>
                  </tr>
                  </tbody>
              </table>
  
              <!-- report description -->
              <p class="description">
                  ${selected.getDescription(session['language_id'])}
              </p>
  
              <hr/>
  
              <g:hiddenField id="valid" name="valid" value="" />
              <!-- report parameters -->
              <g:render template="/report/${selected.type.name}/${selected.name}"/>
  			  
  			  <g:if test="${childEntities?.size() > 0 && company?.parent == null }">
  			  <hr/>
  			  <div class="form-columns">
  			  	<g:applyLayout name="form/select">
                	<content tag="label"><g:message code="report.label.child.company"/></content>
                    <content tag="label.for">childs</content>
                    <g:select multiple="true" name="childs" from="${childEntities}"
                    	                			  optionKey="id" optionValue="${{it?.description}}" />
                </g:applyLayout>
              </div>
              </g:if>
              
            
              <br/>&nbsp;
            </div>
        </div>

        <div class="btn-box">
            <a class="submit edit" onclick="submitForm()">
                <span><g:message code="button.run.report"/></span>
            </a>

            <span>
                <g:select name="format"
                          from="${ReportExportFormat.values()}"
                          noSelection="['': message(code: 'report.format.HTML')]"
                          valueMessagePrefix="report.format"/>
            </span>
        </div>
    </g:form>
</div>

<script type="text/javascript">
	
	var selectedReportName = '${selected.name}';
	
    $(setTimeout(
        function() {
            var validator = $('#run-report-form').validate();
            validator.init();
            validator.hideErrors();
        }, 500)
    );
    function submitForm(){
    	if (selectedReportName == 'total_invoiced' ||
    		selectedReportName == 'total_invoiced_per_customer' ||
    		selectedReportName == 'top_customers' ||
    		selectedReportName == 'user_signups' ||
    		selectedReportName == 'total_payments') {
    		if (!validateDate($("#start_date"))) return false;
    		if (!validateDate($("#end_date"))) return false;  
    	}
        if($('#valid').val()=="false"){
            $("#error-messages ul li").html("Please enter a valid date");
        } else{	
            $('#run-report-form').submit();
        }
    };
</script>