%{--
  JBILLING CONFIDENTIAL
  _____________________

  [2003] - [2014] Enterprise jBilling Software Ltd.
  All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Enterprise jBilling Software.
  The intellectual and technical concepts contained
  herein are proprietary to Enterprise jBilling Software
  and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden.
  --}%

%{--
    Register listeners that will update the messages and breadcrumbs when an ajax call is made.
--}%

$(document).ajaxSuccess(function(e, xhr, settings) {
    //Change introduced to prevent validation messages from being wiped out due to an ajax call in _header.gsp.
    if(settings.url.indexOf("/user/getAdminByCompany") >= 0){
        //Do not re render messages/breadcrumbs for this ajax call
        return;
    }
    renderMessages();
    renderBreadcrumbs();
});
$(document).ajaxError(function(e, xhr, settings) {
    renderMessages();
});
$(document).on('mousedown', function() {
    canReloadMessages = true;
});
$(document).on('keypress', function() {
    canReloadMessages = true;
});
