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
    The controller will update this template whether JQGrid
     is enable or not

    @author Nelson Secchi
    @since 29/04/2014
 --%>
<%@ page import="com.sapienter.jbilling.common.CommonConstants" %>

<g:preferenceEquals preferenceId="${CommonConstants.PREFERENCE_USE_JQGRID}" value="1">
    <g:render template="categoriesGrid" model=""/>
</g:preferenceEquals>
<g:preferenceIsNullOrEquals preferenceId="${CommonConstants.PREFERENCE_USE_JQGRID}" value="0">
    <g:render template="categories" model="['lst': lst]"/>
</g:preferenceIsNullOrEquals>
