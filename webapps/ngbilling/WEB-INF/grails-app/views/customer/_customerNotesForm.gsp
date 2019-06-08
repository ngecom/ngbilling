<g:applyLayout name="form/input">
    <content tag="label"><g:message code="customer.detail.note.form.title"/></content>
    <content tag="label.for">notes.noteTitle</content>
    <g:textField class="field" name="notes.noteTitle" value="" id="noteTitle${selected?.id?:""}"/>
</g:applyLayout>
<g:hiddenField name="notes.dateCreated" value="${null}" id="dateCreated"/>
<g:hiddenField name="notes.userId" value="${session['user_id']}"/>
<label class="lb"><g:message code="customer.detail.note.form.content"/></label> <br>
<g:textArea name="notes.noteContent" value="" rows="5" cols="50" id="noteContent${selected?.id?:""}"/>
