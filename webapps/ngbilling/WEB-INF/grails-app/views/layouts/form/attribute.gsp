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

<%--
  Layout for an attribute name / value pair.

  Usage:

    <g:applyLayout name="form/checkbox">
        <content tag="header.class">className</content>
        <content tag="header.name.title">titleName</content>
        <content tag="header.name">name</content>
        <content tag="header.value.title">valueTitle</content>
        <content tag="header.value">value</content>
        <content tag="name">
            <g:textField class="className" title="someTitle" name="someName"/>
        </content>
        <content tag="value">
            <div class="inp-bg">
                <g:textField class="className" title="someTitle" name="someName"/>
            </div>
        </content>
    </g:applyLayout>


  @author Brian Cowdery
  @since  25-11-2010
--%>
<%@page defaultCodec="none" %>
<div class="row dynamicAttrs">

    <table>
        <thead>
            <tr>
                <td>
                    <div style="font-size: small" title="${pageProperty(name:'page.header.name.title')}" class="${pageProperty(name:'page.header.class')}">
                        <g:pageProperty name="page.header.name"/>
                    </div>
                </td>
                <td>
                    <div style="font-size: small" title="${pageProperty( name: 'page.header.value.title')}" class=" ${pageProperty(name: 'page.header.class')}">
                        <g:pageProperty name="page.header.value"/>
                    </div>
                </td>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <div class="inp-bg inp4">
                        <g:pageProperty name="page.name"/>
                    </div>
                </td>
                <td>
                    <g:pageProperty name="page.value"/>
                </td>
                <td>
                    <g:layoutBody/>
                </td>
            </tr>
        </tbody>
    </table>
</div>