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

<%@ page import="com.sapienter.jbilling.server.util.ServerConstants; org.quartz.SimpleTrigger" %>

<div id="plugin-parameters">
    <div class="form-columns">
		<div class="one_column">

            <g:set var="parameterIndex" value="${0}"/>
            <g:set var="parameters" value="${pluginws ? new HashMap<String, String>(pluginws?.getParameters()) : new HashMap<String, String>()}"/>
            <g:each var="${param}" in="${parametersDesc}">
                <div class="row">
                    <label class = "labelWrap">
                       <g:if test="${param.required==true}">
                        	${param.name}<font color='red'>*</font>
                       </g:if>
                       <g:else>
                        	${param.name}
                       </g:else>
                    </label>
                    <div class="inp-bg">
                        <g:set var="value" value="${pluginws?.getParameters()?.get(param.name)}"/>
                        <g:if test="${param.name == ServerConstants.PARAM_REPEAT}">
                            <g:textField class="field" name="plg-parm-${param.name}" value="${value?:SimpleTrigger.REPEAT_INDEFINITELY}" />
                        </g:if>
                        <g:else>
                            <g:if test="${param.isPassword==true}">
                                <g:passwordField class="field" name="plg-parm-${param.name}" value="${value}" />
                        	</g:if>
                       		<g:else>
                           		<g:textField class="field" name="plg-parm-${param.name}" value="${value}" />
                        	</g:else>
                        </g:else>
                    </div>
                </div>
                %{
                    parameters.remove(param.name)
                }%
            </g:each>

            <g:each var="${parameterEntry}" in="${parameters.entrySet()}">
                <g:set var="parameterIndex" value="${parameterIndex + 1}"/>

                <g:applyLayout name="form/attribute">
                    <content tag="name">
                        <g:textField class="field" name="plgDynamic.${parameterIndex}.name" value="${parameterEntry.key}"/>
                    </content>
                    <content tag="value">
                        <div class="inp-bg inp4">
                        <g:textField class="field" name="plgDynamic.${parameterIndex}.value" value="${parameterEntry.value}"/>
                        </div>
                    </content>

                    <a onclick="removePluginParameter(this, ${parameterIndex})">
                        <img src="${resource(dir: 'images', file: 'cross.png')}" alt="remove"/>
                    </a>
                </g:applyLayout>
            </g:each>


            <g:set var="parameterIndex" value="${parameterIndex + 1}"/>
            <g:applyLayout name="form/attribute">
                <content tag="name">
                    <g:textField class="field" name="plgDynamic.${parameterIndex}.name"/>
                </content>
                <content tag="value">
                    <div class="inp-bg inp4">
                    <g:textField class="field" name="plgDynamic.${parameterIndex}.value"/>
                    </div>
                </content>

                <a onclick="addPluginParameter(this, ${parameterIndex})">
                    <img src="${resource(dir:'images', file:'add.png')}" alt="add"/>
                </a>
            </g:applyLayout>

            <g:hiddenField name="parameterIndexField" value="${parameterIndex}"/>

        </div>
    </div>

    <script type="text/javascript">

        $(document).ready(function() {
            // Adjust dynamic attributes padding
            $('.dynamicAttrs').removeClass().addClass("plugin-attribute-dynamic")
        });

        function addPluginParameter(element, parameterIndex) {

            $('#parameterIndexField').val(parameterIndex+1);

            $.ajax({
                type: 'POST',
                url: '${createLink(action: 'addPluginParameter')}',
                data: $('#plugin-parameters').parents('form').serialize(),
                success: function(data) {
                    $('#plugin-parameters').replaceWith(data);
                    //alert(data);
                }
            });
        }

        function removePluginParameter(element, parameterIndex) {

            $('#parameterIndexField').val(parameterIndex);

            $.ajax({
                type: 'POST',
                url: '${createLink(action: 'removePluginParameter')}',
                data: $('#plugin-parameters').parents('form').serialize(),
                success: function(data) {
                    $('#plugin-parameters').replaceWith(data);
                    //alert(data);
                }
            });
        }
    </script>
</div>
