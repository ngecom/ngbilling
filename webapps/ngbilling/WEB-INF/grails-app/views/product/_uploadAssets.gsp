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

<%@ page import="com.sapienter.jbilling.server.item.db.AssetDTO" %>

<%--
  Template lets the user select a file with assets for upload

  @author Gerhard Maree
  @since  14-May-2013
--%>


<div class="column-hold">
    <div class="heading">
        <strong>
            <g:message code="asset.heading.upload"/>
        </strong>
    </div>

    <div class="box">
        <div class="sub-box">
            <p><g:message code="asset.upload.format"/></p><br/>

            <p><g:message code="asset.upload.label.columns"/>
            <strong>'${product.findItemTypeWithAssetManagement().assetIdentifierLabel ?: message([code:  'asset.detail.identifier'])}' (*), '<g:message code="asset.detail.notes"/>'
            <g:each in="${category.assetMetaFields.sort {it.displayOrder}}" var="metaField">
                , ${"'"+metaField.name + (metaField.mandatory ? "' (*)" : "'") }
            </g:each>
            </strong></p><br/>

            <p><g:message code="asset.upload.groups" /> </p><br/>

            <p><g:message code="asset.upload.defaults" args="${[category.description,defaultStatus.description]}" /> </p><br/>

            <g:uploadForm name="upload-assets-form" url="[action: 'uploadAssets']">
                <g:hiddenField name="prodId" value="${product.id}"/>
                <g:applyLayout name="form/text">
                    <content tag="label"><g:message code="asset.label.csv.file"/></content>
                    <input type="file" name="assetFile"/>
                </g:applyLayout>
                <div class="btn-row">
                    <br/>
                    <a onclick="$('#upload-assets-form').submit();" class="submit save"><span><g:message
                            code="button.upload"/></span></a>
                </div>
            </g:uploadForm>

        </div>
    </div>

</div>

