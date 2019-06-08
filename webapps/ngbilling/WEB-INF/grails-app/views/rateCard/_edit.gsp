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

  @author Brian Cowdery
  @since  27-Jan-2011
--%>

<div class="column-hold">
    <g:set var="isNew" value="${!rateCard || !rateCard?.id || rateCard?.id == 0}"/>

    <div class="heading">
        <g:if test="${isNew}">
            <strong><g:message code="rate.card.add.title"/></strong>
        </g:if>
        <g:else>
            <strong><g:message code="rate.card.edit.title"/></strong>
        </g:else>
    </div>

    <g:uploadForm id="rate-card-form" name="rate-card-form" url="[action: 'save']">

    <div class="box">
        <fieldset>
            <div class="form-columns">
                <g:hiddenField name="id" value="${rateCard?.id}"/>

                <g:applyLayout name="form/input">
                    <content tag="label"><g:message code="rate.card.name"/></content>
                    <content tag="label.for">name</content>
                    <g:textField class="field" name="name" value="${rateCard?.name}"/>
                </g:applyLayout>

                <g:if test="${!isNew}">
                    <g:applyLayout name="form/text">
                        <content tag="label"><g:message code="rate.card.table.name"/></content>
                        <content tag="label.for">tableName</content>
                        <g:textField class="field" name="tableName" value="${rateCard?.tableName}"/>
                    </g:applyLayout>
                </g:if>

                <g:applyLayout name="form/text">
                    <content tag="label"><g:message code="rate.card.csv.file"/></content>
                    <input type="file" name="rates"/>
                </g:applyLayout>

                <g:applyLayout name="form/text">
                    <content tag="label">&nbsp;</content>
                    <a href="${resource(dir:'examples', file:'example_rate_card.csv')}">example_rate_card.csv</a>
                </g:applyLayout>
            </div>
        </fieldset>
    </div>

    </g:uploadForm>

    <div class="btn-box buttons">
        <ul>
            <li><a class="submit save" onclick="$('#rate-card-form').submit();"><span><g:message code="button.save"/></span></a></li>
            <li><a class="submit cancel" onclick="closePanel(this);"><span><g:message code="button.cancel"/></span></a></li>
        </ul>
    </div>
</div>