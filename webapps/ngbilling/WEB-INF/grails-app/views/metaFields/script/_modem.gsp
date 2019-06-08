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

%{--
    This script can be used in a meta field of type SCRIPT. It can be used to record
    a customer modem type/location. A modem can be Residential, Commercial or Other.
    When the modem is neither Residential or Commercial than it is classified as Other.
    When the modem is Other the user must have the option so save extra information
    with to explain where is the modem. This script will render three radio buttons
    in a group. The radio buttons are "Residential", "Commercial" and "Other". The
    the user selects "Other" additional input field is enabled where the customer will
    input the extra information for the modem. The additional input field is not
    available for other two options.

    Whenever a user makes a change in any of the field a java script code will try to
    update the value of the hidden field with name="metaField_${field.id}.value". The
    value that this hidden field holds will be stored into the database. The hidden
    field will store the information about the selected radio button, but also if
    the selection is "Other" it will store the value stored at the additional input
    field. The java script in this script is also able to parse the result stored in
    database and display it in the fields.
--}%

<r:script disposition="head">
    $(document).ready(function() {
        setup();

        $('.modem${field.id}').change(function() {
           updateOtherInput();
           updateOtherLocationValue();
        });

        $('#modem${field.id}OthLoc').keyup(function(){
           updateOtherLocationValue();
        });
    });

    function setup(){
        var value = $('#metaField_${field.id}\\.value').val();
        var values = value.split("[");
        $('#modem${field.id}'+values[0]).prop('checked', true);
        if(values.length > 1){
            $('#modem${field.id}OthLoc').val(values[1].split("]")[0]);
        }
        updateOtherInput();
    }

    function updateOtherInput(){
        var selectedValue = $("input[name='modem${field.id}']:checked").val()

        if(selectedValue && selectedValue == 'Other'){
            $('#modem${field.id}OthLoc').prop('disabled', '');
        } else {
            $('#modem${field.id}OthLoc').val('').prop('disabled', 'true');
        }
    }

    function updateOtherLocationValue(){
        var selectedValue = $("input[name='modem${field.id}']:checked").val();
        if(selectedValue == 'Other'){
            var otherLocation = $('#modem${field.id}OthLoc').val();
            $('#metaField_${field.id}\\.value').val(selectedValue+'['+otherLocation + ']');
        } else {
            $('#metaField_${field.id}\\.value').val(selectedValue);
        }
    }
</r:script>

<g:applyLayout name="form/radio">
    %{--this is the value is saved in database--}%
    <g:hiddenField name="metaField_${field.id}.value" value="${fieldValue}" />
    <content tag="label"><g:message code="${field.name}"/><g:if test="${field.mandatory}"><span id="mandatory-meta-field">*</span></g:if></content>
    <content tag="label.for">metaField_${field.id}.value</content>
    <div style="float:left">
        <g:radio id="modem${field.id}Residential" class="modem${field.id}"
                 name="modem${field.id}" value="Residential"/>Residential
        <br>
        <g:radio id="modem${field.id}Commercial" class="modem${field.id}"
                 name="modem${field.id}" value="Commercial"/>Commercial
        <br>
        <g:radio id="modem${field.id}Other" class="modem${field.id}"
                 name="modem${field.id}" value="Other"/>Other

        <g:textField id="modem${field.id}OthLoc" style="width: 85px"
                     class="field" name="modem${field.id}OthLoc" />
    </div>
</g:applyLayout>