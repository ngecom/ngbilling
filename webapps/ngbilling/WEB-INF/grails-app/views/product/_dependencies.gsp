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

<%@ page contentType="text/html;charset=UTF-8" %>

<%--
  Product dependencies

  @author Shweta Gupta
  @since  30-May-2013
--%>

<div class="content">
    <table class="dataTable" cellspacing="0" cellpadding="0" style="width: 66%">
        <tr>
            <td class="short-width1">
                <g:applyLayout name="form/select">
                    <content tag="label"><g:message code="product.dependencies.category"/></content>

                    <div id="product.dependencyItemTypes" style="display: inline;">
                        <g:select name="product.dependencyItemTypes"
                                  from="${dependencyItemTypes}"
                                  optionKey="id"
                                  optionValue="description"
                                  value=""
                                  noSelection="['':'-']"
                                  style="width:50%;"/>
                    </div>
                </g:applyLayout>
            </td>
            <td class="short-width1">
                <g:applyLayout name="form/select">
                    <content tag="label"><g:message code="product.dependencies.product"/></content>

                    <div id="product.dependencyItems" style="display: inline;">
                        <g:select name="product.dependencyItems"
                                  from="${dependencyItems}"
                                  optionKey="id"
                                  optionValue="description"
                                  value=""
                                  noSelection="['':'-']"
                                  style="width:50%;"/>
                    </div>

                </g:applyLayout>
            </td>
            <td class="short-width2">
                <g:applyLayout name="form/text">
                    <content tag="label"><g:message code="product.detail.dependencies.min.title"/></content>
                    <g:textField name="product.dependencyMin" value="0" class="narrow"/>
                </g:applyLayout>
            </td>
            <td class="short-width2">
                <g:applyLayout name="form/text">
                    <content tag="label"><g:message code="product.detail.dependencies.max.title"/></content>
                    <g:textField name="product.dependencyMax" value="" class="narrow"/>
                </g:applyLayout>
            </td>
            <td class="short-width3">
                <a href="#" onclick="addDependency(); return false;">
                    <img name="add" src="${resource(dir:'images', file:'add.png')}"
                         alt="Add"/>
                </a>
            </td>
        </tr>
    </table>

    <div class="form-columns">
        <span><g:message code="product.detail.dependencies.products.title"/></span>
        <table class="dataTable" cellspacing="0" cellpadding="0" width="100%">
            <thead>
            <tr class="dependency-th small-width">
                <th><g:message code="product.detail.dependencies.id.title"/></th>
                <th><g:message code="product.detail.dependencies.name.title"/></th>
                <th><g:message code="product.detail.dependencies.min.title"/></th>
                <th><g:message code="product.detail.dependencies.max.title"/></th>
                <th></th>
            </tr>
            </thead>
            <tbody id="dependencyItems">
                <%-- items --%>
                <g:each var="depItem" in="${dependentItems}">
                    <g:render template="dependencyRow" model="[obj:depItem, type:false]"  />
                </g:each>
            </tbody>
        </table>


        <span><g:message code="product.detail.dependencies.categories.title"/></span>
        <table class="dataTable" cellspacing="0" cellpadding="0" width="100%">
            <thead>
            <tr class="dependency-th small-width">
                <th><g:message code="product.detail.dependencies.id.title"/></th>
                <th><g:message code="product.detail.dependencies.name.title"/></th>
                <th><g:message code="product.detail.dependencies.min.title"/></th>
                <th><g:message code="product.detail.dependencies.max.title"/></th>
                <th></th>
            </tr>
            </thead>
            <tbody id="dependencyTypes">
                <%-- item types --%>
                <g:each var="depType" in="${dependentTypes}">
                    <g:render template="dependencyRow" model="[obj:depType, type:true]"  />
                </g:each>
            </tbody>
        </table>
    </div>
    <script type="text/javascript">
        $('div[id="product.dependencyItemTypes"]').delegate("select","change",function(){
            var typeId = $('select[id="product.dependencyItemTypes"]').val();
            var toExcludeItemIds = [];
            var id;
            $('tr[id^="Items"]').each(function() {
                id = $(this).attr('id');
                id = id.split('.')[1];
                toExcludeItemIds.push( id );
            });

            toExcludeItemIds.push('${selectedProduct?.id}');
            toExcludeItemIds.push('${selectedProduct?.id}');
            $.ajax({
                url: '${createLink(controller: 'product', action: 'getItemsByItemType')}',
                data: {typeId: typeId, toExcludeItemIds: toExcludeItemIds},
                cache: false,
                success: function(html) {
                    $('div[id="product.dependencyItems"]').html(html);
                    $('select[id="product.dependencyItems"]').attr('style','width:50%');
                    var minDefaultValue = $('select[id="product.dependencyItems"]').find('option').length>1 ? 1 : 0
                    $('input[id="product.dependencyMin"]').val(minDefaultValue);
                }
            });
        });

        function addDependency(){
            var typeId = $('select[id="product.dependencyItemTypes"]').val();
            var itemId = $('select[id="product.dependencyItems"]').val();
            var min = $('input[id="product.dependencyMin"]').val();
            var max = $('input[id="product.dependencyMax"]').val();

            var typeIds = [];
            $('select[id="product.dependencyItemTypes"]').find('option').each(function() {
                typeIds.push( $(this).val() );
            });

            var itemIds = [];
            $('select[id="product.dependencyItems"]').find('option').each(function() {
                itemIds.push( $(this).val() );
            });

            var toExcludeItemIds = [];
            var id;
            $('tr[id^="Items"]').each(function() {
                id = $(this).attr('id');
                id = id.split('.')[1];
                toExcludeItemIds.push( id );
            });

            var toExcludeTypeIds = [];
            $('tr[id^="Types"]').each(function() {
                id = $(this).attr('id');
                id = id.split('.')[1];
                toExcludeTypeIds.push( id );
            });

            callGetDependencyList(toExcludeTypeIds, toExcludeItemIds, typeIds, itemIds, typeId, itemId);
            callAddDependencyRow(typeId, itemId, min, max);
        }

        function removeDependency(trId, id, name){
            $('tr[id="'+trId+'"]').remove();

            var type = trId.split('.')[0];
            if(type.indexOf('Types')>=0){
                $('select[id="product.dependencyItemTypes"]').append('<option value="'+id+'">'+name+'</option>');
            }

            $('select[id="product.dependencyItemTypes"]').val('') ;
            $('select[id="product.dependencyItems"]').val('');
            $('select[id="product.dependencyItems"]').html('<option>-</option>');
        }

        function callGetDependencyList(toExcludeTypeIds, toExcludeItemIds, typeIds, itemIds, typeId, itemId){
            $.ajax({
                url: '${createLink(controller: 'product', action: 'getDependencyList')}',
                data: {toExcludeTypeIds: toExcludeTypeIds, toExcludeItemIds: toExcludeItemIds, typeIds: typeIds, itemIds: itemIds, typeId: typeId, itemId: itemId},
                cache: false,
                success: function(html){
                    if(typeId!="" && itemId==""){
                        $('div[id="product.dependencyItemTypes"]').html(html);
                        $('select[id="product.dependencyItemTypes"]').attr('style','width:50%');

                        $('select[id="product.dependencyItems"]').html('<option>-</option>');
                        $('select[id="product.dependencyItems"]').attr('style','width:50%');
                    } else if(typeId!="" && itemId!=""){
                        $('div[id="product.dependencyItems"]').html(html);
                        $('select[id="product.dependencyItems"]').attr('style','width:50%');
                    }
                }
            });
        }

        function callAddDependencyRow(typeId, itemId, min, max){
            $.ajax({
                url: '${createLink(controller: 'product', action: 'addDependencyRow')}',
                data: {typeId: typeId, itemId: itemId, min: min, max: max},
                cache: false,
                success: function(html) {
                    if(typeId!="" && itemId==""){
                        $('tbody[id="dependencyTypes"]').append(html);
                    } else if(typeId!="" && itemId!=""){
                        $('tbody[id="dependencyItems"]').append(html);
                    }
                }
            });
        }

    </script>
</div>