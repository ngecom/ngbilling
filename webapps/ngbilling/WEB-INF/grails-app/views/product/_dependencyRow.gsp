<g:set var="id_sub1" value="${''+obj.minimum + ':' + (obj.maximum?obj.maximum:'') + ':' + obj.dependentId}"/>
<g:set var="id_sub2" value="${type?'Types':'Items'}"/>
<g:set var="name" value="${id_sub2+':'+id_sub1}"/>
<g:set var="trId" value="${name+'.'+obj.dependentId}"/>
<tr class="dependency-tr small-width" id="${trId}">
    <td>${obj.dependentId}</td>
    <td>${obj.dependentDescription}</td>
    <td>${obj.minimum}</td>
    <td>${obj.maximum?:''}</td>
    <td>
        <a href="#" onclick="removeDependency('${trId}', '${obj.dependentId}', '${obj.dependentDescription}'); return false;" style="float: right;">
            <img src="${resource(dir:'images', file:'cross.png')}" alt="remove"/>
        </a>
    </td>
    <g:hiddenField name="dependency.${name}" value="${obj.dependentDescription}"/>
</tr>