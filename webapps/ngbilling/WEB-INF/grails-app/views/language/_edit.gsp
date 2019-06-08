%{--
  JBILLING CONFIDENTIAL
  _____________________

  [2003] - [2012] Enterprise jBilling Software Ltd.
  All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Enterprise jBilling Software.
  The intellectual and technical concepts contained
  herein are proprietary to Enterprise jBilling Software
  and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden.
  --}%
<%@ page contentType="text/html;charset=UTF-8" %>

<%--
  Shows edit form for a contact type.

  @author Neeraj Bhatt
  @since  10-June-2014
--%>

<div class="column-hold">
    <g:set var="isNew" value="${!language || !language?.id || language?.id == 0}"/>

    <div class="heading">
        <g:if test="${isNew}">
            <strong><g:message code="language.add.title"/></strong>
        </g:if>
        <g:else>
            <strong><g:message code="language.edit.title"/></strong>
        </g:else>
    </div>

    <g:form  name="language-form" id="language-form" url="[action: 'save']" >

    <div class="box">
        <div class="sub-box">
          <fieldset>
            <div class="form-columns">
                <g:hiddenField name="id" value="${language?.id}"/>
                <g:applyLayout name="form/input">
                    <content tag="label"><g:message code="language.label.code"/></content>
                    <content tag="label.for">code</content>
                    <g:textField class="field" name="code" value="${language?.code}"/>
                </g:applyLayout>


                    <g:applyLayout name="form/input">
                        <content tag="label"><g:message code="language.label.description"/></content>
                        <content tag="label.for">description</content>
                        <g:textField class="field" name="description" value="${language?.description}"/>
                    </g:applyLayout>
            </div>
        </fieldset>
      </div>
    </div>
    </g:form>
    <div class="btn-box buttons">
        <ul>
            <li><a class="submit save" onclick="$('#language-form').submit();"><span><g:message code="button.save"/></span></a></li>
            <li><g:link controller="language" action="list" class="submit cancel" params="[id:language?.id]"><span><g:message code="button.cancel"/></span></g:link></li>
        </ul>
    </div>
</div>