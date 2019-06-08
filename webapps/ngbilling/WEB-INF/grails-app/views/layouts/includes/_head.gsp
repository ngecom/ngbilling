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
  Content for the head region of all jBilling layouts.

  @author Brian Cowdery
  @since  23-11-2010
--%>

<meta http-equiv="content-type" content="text/html; charset=utf-8" />

<title><g:layoutTitle default="NGBilling" /></title>

<link rel="shortcut icon" href="${resource(dir:'images', file:'favicon.ico')}" type="image/x-icon" />

<r:require modules="jquery, core, ui, input"/>

<r:script disposition='head'>
    var canReloadMessages = true;

    function renderMessages() {
        if(canReloadMessages) {
            $.ajax({
                url: "${resource(dir:'')}/messages",
                global: false,
                async: false,
                cache: false,
                success: function(data) { $("#messages").replaceWith(data); }
            });
        }
    }

    function renderBreadcrumbs() {
        $.ajax({
            url: "${resource(dir:'')}/breadcrumb",
            global: false,
            success: function(data) { $("#breadcrumbs").replaceWith(data); }
       });
    }
</r:script>

<g:if test="${ajaxListeners == null || ajaxListeners}">
<r:script disposition='head'>
    <g:render template="/layouts/includes/messageBreadCrumbListeners"/>
</r:script>
</g:if>

<r:require module="jquery-ui"/>
<r:external file="/js/jquery-ui/i18n/jquery.ui.datepicker-${session.locale.language}.js"/>

<r:require module="jquery-validate"/>
<r:external file="/js/jquery-validate/i18n/messages_${session.locale.language}.js"/>

<r:script disposition='head'>
    $(document).ready(function() {
        $.validator.setDefaults({
            errorContainer: "#error-messages",
            errorLabelContainer: "#error-messages ul",
            wrapper: "li",
            meta: "validate"
        });

        // minor bug with the filter input fields - this should happen automatically
        // but the 'keyup' event doesn't always bind correctly from the validator itself
        $('#filters-form').delegate('input', 'keyup', function() {
            $('#filters-form').valid();
        });
    })
</r:script>
