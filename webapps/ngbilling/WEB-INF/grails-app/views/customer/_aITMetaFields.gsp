<div id="ait-inner-${ait.id}" class="form-columns">
	<%
  	def aitMetaFields =  ait?.metaFields?.sort { it.displayOrder }
   	def leftColumnFields = []
  	def rightColumnFields = []
  	aitMetaFields.eachWithIndex { field, index ->
    if(index > aitMetaFields.size()/2){
   		rightColumnFields << field
  	} else {
      	leftColumnFields << field
    }
    }
   	%>
   	<div class="column">
    	<g:if test="${leftColumnFields.size() > 0}">
           	<g:render template="/metaFields/editMetaFields" model="[
                                                availableFields: leftColumnFields,
                                                fieldValues: values,
                                                groupId: ait.id
                                        ]"/>
     	</g:if>
	</div>
 	<div class="column">
   		<g:if test="${rightColumnFields.size() > 0}">
       		<g:render template="/metaFields/editMetaFields" model="[
                                                availableFields: rightColumnFields,
                                                fieldValues: values,
                                                groupId: ait.id
                                        ]"/>
    	</g:if>
 	</div>
</div>