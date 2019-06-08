<div class="table-box">
    <table id="notes" cellspacing="0" cellpadding="0">
        <thead>
        <tr class="ui-widget-header" >
        <th width="150px"><g:message code="customer.detail.note.form.author"/></th>
        <th width="150px"><g:message code="customer.detail.note.form.createdDate"/></th>
        <th width="150px"><g:message code="customer.detail.note.form.title"/></th>
        <th width="550px"><g:message code="customer.detail.note.form.content"/></th>
        </thead>
        <tbody>
        <g:if test="${!isNew}">

            <g:if test="${customerNotes}">
                <g:each in="${customerNotes}">
                    <tr>
                        <g:hiddenField name="notes.noteId" value="${it?.noteId}"/>
                        <td>${it?.user.userName}</td>
                        <td><g:formatDate date="${it?.creationTime}" type="date" style="MEDIUM"/>  </td>
                        <td>   ${it?.noteTitle} <input type='hidden' name ='notes.noteTitle' value='"+noteTitle.val()+"'> </td>
                        <td> ${it?.noteContent} <input type='hidden' name ='notes.noteContent' value='"+noteContent.val()+"'></td>
                    </tr>
                </g:each>

            </g:if>
            <g:else>
                <p><em><g:message code="customer.detail.note.empty.message"/></em></p>
            </g:else>

        </g:if>
        </tr>

        </tbody>
    </table>

    <div class="row">
        <util:remotePaginate controller="customerInspector" action="subNotes" total="${customerNotesTotal}" update="test" params="[id:user.id]"/>
    </div>
</div>
