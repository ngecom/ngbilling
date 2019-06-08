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

<%--
  Shows language.

  @author Neeraj Bhatt
  @since  09-Jun-2014
--%>

<div class="column-hold">
    <div class="heading">
        <strong>
            ${selected.getDescription()}
        </strong>
    </div>

    <div class="box">
        <div class="sub-box">
          <table class="dataTable" cellspacing="0" cellpadding="0">
            <tbody>
            <tr>
                <td><g:message code="language.label.id"/></td>
                <td class="value">${selected.id}</td>
            </tr>
            <tr>
                <td><g:message code="language.label.code"/></td>
                <td class="value">
                    <div style="word-wrap: break-word; width: 690px;"><span>${selected.getCode()}</span></div>
                </td>
            </tr>
            <tr>
                <td><g:message code="language.label.description"/></td>
                <td class="value">${selected.getDescription()}</td>
            </tr>
            </tbody>
        </table>
      </div>
    </div>

    <div class="btn-box">
        <div class="row">
            <g:remoteLink action='edit' class="submit add"  update="column2" params="[id:selected.id]"><span><g:message code="button.edit"/></span></g:remoteLink>
        </div>
    </div>

    <g:render template="/confirm"
              model="['message': 'language.delete.confirm',
                      'controller': 'language',
                      'action': 'delete',
                      'id': selected.id,
                      'ajax': true,
                      'update': 'column1',
                     ]"/>
</div>
