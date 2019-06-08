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
    a person's phone number. A phone number consist of a country code, area code and a
    number. The country code and area code are rendered as drop downs and the phone
    number is rendered as input field. When a user changes a value in the country
    code drop down then the values in the area code drop down are automatically changed.
    This allows the user to only select an area code that is valid for the selected
    country.

    Whenever a user makes a change in any of the field a java script code will try to
    update the value of the hidden field with name="metaField_${field.id}.value". The
    value that this hidden field holds will be stored into the database. The hidden
    field will hold a value only if the three fields are defined. The logic will not
    save partial phone numbers. The value of the hidden field is also formatted with
    in following format <country_code>-<area_code>-<phone_number>. When the user
    wants to edit already persisted phone number that the java script in this file
    knows how to parse the phone numbers and set all the input fields.
--}%

<r:script disposition="head">

    var countries = new Array('', '1', '44');

    var areas = new Array();
    //US area codes
    areas['1'] = new Array('',
            '201','202','203','204','205','206','207','208','209','210','212','213',
            '214','215','216','217','218','219','224','225','228','229','231','234',
            '239','240','248','250','251','252','253','254','256','260','262','267',
            '269','270','276','281','289','301','302','303','304','305','306','307',
            '308','309','310','312','313','314','315','316','317','318','319','320',
            '321','323','325','330','331','334','336','337','339','340','347','351',
            '352','360','361','385','386','401','402','403','404','405','406','407',
            '408','409','410','412','413','414','415','416','417','418','419','423',
            '424','425','430','432','434','435','440','442','443','450','458','469',
            '470','475','478','479','480','484','501','502','503','504','505','506',
            '507','508','509','510','512','513','514','514','515','516','517','518',
            '519','519','520','530','539','540','541','551','559','561','562','563',
            '567','570','571','573','574','575','580','585','586','601','602','603',
            '604','605','606','607','608','609','610','612','613','614','615','616',
            '617','618','619','620','623','626','630','631','636','641','646','647',
            '650','651','657','660','661','662','671','678','681','682','684','701',
            '702','703','704','705','706','707','708','709','712','713','714','715',
            '716','717','718','719','720','724','727','731','732','734','740','747',
            '754','757','760','762','763','765','769','770','772','773','774','775',
            '778','778','779','780','780','781','785','786','787','801','802','803',
            '804','805','806','807','808','810','812','813','814','815','816','817',
            '818','819','828','830','831','832','843','845','847','848','850','856',
            '857','858','859','860','862','863','864','865','867','870','872','878',
            '901','902','903','904','905','906','907','908','909','910','912','913',
            '914','915','916','917','918','919','920','925','928','929','931','936',
            '937','938','939','940','941','947','949','951','952','954','956','970',
            '971','972','973','978','979','980','985','989');

    //UK area codes
    areas['44'] = new Array('',
            '0113','0114','0115','0116','0117','0118','01200','01202','01204','01205',
            '01206','01207','01208','01209','0121','01223','01224','01225','01226',
            '01227','01228','01229','01233','01234','01235','01236','01237','01239',
            '01241','01242','01243','01244','01245','01246','01248','01249','01250',
            '01252','01253','01254','01255','01256','01257','01258','01259','01260',
            '01261','01262','01263','01264','01267','01268','01269','01270','01271',
            '01273','01274','01275','01276','01277','01278','01279','01280','01282',
            '01283','01284','01285','01286','01287','01288','01289','01290','01291',
            '01292','01293','01294','01295','01296','01297','01298','01299','01300',
            '01301','01302','01303','01304','01305','01306','01307','01308','01309',
            '0131','01320','01322','01323','01324','01325','01326','01327','01328',
            '01329','01330','01332','01333','01334','01335','01337','01339','01340',
            '01341','01342','01343','01344','01346','01347','01348','01349','01350',
            '01352','01353','01354','01355','01356','01357','01358','01359','01360',
            '01361','01362','01363','01364','01366','01367','01368','01369','01371',
            '01372','01373','01375','01376','01377','01379','01380','01381','01382',
            '01383','01384','01386','01387','013873','01388','01389','01392','01394',
            '01395','01397','01398','01400','01403','01404','01405','01406','01407',
            '01408','01409','0141','01420','01422','01423','01424','01425','01427',
            '01428','01429','01430','01431','01432','01433','01434','01435','01436',
            '01437','01438','01439','01440','01442','01443','01444','01445','01446',
            '01449','01450','01451','01452','01453','01454','01455','01456','01457',
            '01458','01460','01461','01462','01463','01464','01465','01466','01467',
            '01469','01470','01471','01472','01473','01474','01475','01476','01477',
            '01478','01479','01480','01481','01482','01483','01484','01485','01487',
            '01488','01489','01490','01491','01492','01493','01494','01495','01496',
            '01497','01499','01501','01502','01503','01505','01506','01507','01508',
            '01509','0151','01520','01522','01524','015242','01525','01526','01527',
            '01528','01529','01530','01531','01534','01535','01536','01538','01539',
            '015394','015395','015396','01540','01542','01543','01544','01545','01546',
            '01547','01548','01549','01550','01553','01554','01555','01556','01557',
            '01558','01559','01560','01561','01562','01563','01564','01565','01566',
            '01567','01568','01569','01570','01571','01572','01573','01575','01576',
            '01577','01578','01579','01580','01581','01582','01583','01584','01586',
            '01588','01590','01591','01592','01593','01594','01595','01597','01598',
            '01599','01600','01603','01604','01606','01608','01609','0161','01620',
            '01621','01622','01623','01624','01625','01626','01628','01629','01630',
            '01631','01633','01634','01635','01636','01637','01638','01639','01641',
            '01642','01643','01644','01646','01647','01650','01651','01652','01653',
            '01654','01655','01656','01659','01661','01663','01664','01665','01666',
            '01667','01668','01669','01670','01671','01672','01673','01674','01675',
            '01676','01677','01678','01680','01681','01683','01684','01685','01686',
            '01687','01688','01689','01690','01691','01692','01694','01695','01697',
            '016973','016974','01698','01700','01702','01704','01706','01707','01708',
            '01709','01720','01721','01722','01723','01724','01725','01726','01727',
            '01728','01729','01730','01732','01733','01736','01737','01738','01740',
            '01743','01744','01745','01746','01747','01748','01749','01750','01751',
            '01752','01753','01754','01756','01757','01758','01759','01760','01761',
            '01763','01764','01765','01766','01767','01768','017683','017684','017687',
            '01769','01770','01771','01772','01773','01775','01776','01777','01778',
            '01779','01780','01782','01784','01785','01786','01787','01788','01789',
            '01790','01792','01793','01794','01795','01796','01797','01798','01799',
            '01803','01805','01806','01807','01808','01809','01821','01822','01823',
            '01824','01825','01827','01828','01829','01830','01832','01833','01834',
            '01835','01837','01838','01840','01841','01842','01843','01844','01845',
            '01847','01848','01851','01852','01854','01855','01856','01857','01858',
            '01859','01862','01863','01864','01865','01866','01869','01870','01871',
            '01872','01873','01874','01875','01876','01877','01878','01879','01880',
            '01882','01883','01884','01885','01886','01887','01888','01889','01890',
            '01892','01895','01896','01899','01900','01902','01903','01904','01905',
            '01908','01909','0191','01920','01922','01923','01924','01925','01926',
            '01928','01929','01931','01932','01933','01934','01935','01937','01938',
            '01939','01942','01943','01944','01945','01946','019467','01947','01948',
            '01949','01950','01951','01952','01953','01954','01955','01957','01959',
            '01962','01963','01964','01967','01968','01969','01970','01971','01972',
            '01974','01975','01977','01978','01980','01981','01982','01983','01984',
            '01985','01986','01987','01988','01989','01992','01993','01994','01995',
            '01997','020','023','024','028','029');

    $(document).ready(function() {

//      fills the country code drop down
        loadCountryCodes();

//      when phone code selection changes update the
//      area code drop down and update the selected value
        $("#phone${field.id}\\.countryCode").change(function () {
            loadAreaCodes();
            updatePhoneValue();
        })

//      when area code selection changes update the selected value
        $("#phone${field.id}\\.areaCode").change(function () {
            updatePhoneValue();
        })

//      ensure only digits can be input in the number field
        $("#phone${field.id}\\.number").keydown(function(event) {
            // Allow: backspace, delete, tab, escape, and enter
            if ( event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 ||
                 // Allow: Ctrl+A
                (event.keyCode == 65 && event.ctrlKey === true) ||
                 // Allow: home, end, left, right
                (event.keyCode >= 35 && event.keyCode <= 39)) {
                     // let it happen, don't do anything
                     return;
            }
            else {
                // Ensure that it is a number and stop the keypress
                if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105 )) {
                    event.preventDefault();
                }
            }
        });

//      when key is release on this field update the selected value
        $("#phone${field.id}\\.number").keyup(function() {
            updatePhoneValue();
        });

//      update the values in the components from database values
        var number = $('#metaField_${field.id}\\.value').val();
        if(!isEmpty(number)){
            var numberParts = number.split("-");
            if(numberParts.length === 3){
                $("#phone${field.id}\\.countryCode").val(numberParts[0]);
                loadAreaCodes(); //make sure the area codes are loaded before selecting one
                $("#phone${field.id}\\.areaCode").val(numberParts[1]);
                $("#phone${field.id}\\.number").val(numberParts[2]);
            }
        }

    });

    function loadCountryCodes(){
        $("#phone${field.id}\\.countryCode option").remove();
        countries.forEach(function(entry) {
            $("#phone${field.id}\\.countryCode").append('<option value="' + entry + '">' + entry + '</option>');
        });
    }

    function loadAreaCodes(){
        var selCountry = $("#phone${field.id}\\.countryCode").val();

        $("#phone${field.id}\\.areaCode option").remove();

        if(!isEmpty(selCountry)){
            areas[selCountry].forEach(function(entry){
                $("#phone${field.id}\\.areaCode").append('<option value="' + entry + '">' + entry + '</option>');
            });
        }
    }

    function updatePhoneValue(){
        var country = $("#phone${field.id}\\.countryCode").val()
        var area = $("#phone${field.id}\\.areaCode").val()
        var number = $("#phone${field.id}\\.number").val()

        if(isEmpty(country) || isEmpty(area) || isEmpty(number)){
            $('#metaField_${field.id}\\.value').val('')
        } else {
           $('#metaField_${field.id}\\.value').val(country + '-' + area + '-' + number)
        }
    }

    function isEmpty(str) {
        return (!str || 0 === str.length);
    }

</r:script>

<g:applyLayout name="form/select">

    %{--this is the value is saved in database--}%
    <g:hiddenField name="metaField_${field.id}.value" value="${fieldValue}" />

    <content tag="label"><g:message code="${field.name}"/><g:if test="${field.mandatory}"><span id="mandatory-meta-field">*</span></g:if></content>
    <content tag="label.for">metaField_${field.id}.value</content>
    <span>
        <g:select id="phone${field.id}.countryCode" style="width: 55px"
                  name="phone${field.id}.countryCode" from="${[]}" />
        <g:select id="phone${field.id}.areaCode" style="width: 65px"
                  name="phone${field.id}.areaCode" from="${[]}" />
        <g:textField id="phone${field.id}.number" style="width: 85px"
                     class="field text {validate:{ digits: true }}"
                     name="phone${field.id}.number" />
    </span>
</g:applyLayout>