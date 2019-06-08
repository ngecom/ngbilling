package jbilling
import com.sapienter.jbilling.common.XSSChecker

/**
* Security filter implemented for Salesforce branch issue #5687 Review and respond to Portswigger Security Scan
* This analyzes the common requests in the system and verifies that the data being supplied agrees with the
* expected format of data to parseout any scripts. This is to prevent Reflective XSS attacks
*/
class SecurityFilters {

    def filters = {
    	//All contoller list methods. Returning false from here prevents the request from being processed
        allList(controller:'*', action:'list') {
        
            before = {
            	if(params?.order!=null && params?.order!='null' && params?.order!='' && params?.order!='asc' && params?.order!='desc' ){
            		System.out.println("Security filter reject: Invalid order param value")
					return false;
            	} else if(params?.sort!=null && params?.sort!='null' && (params?.sort?.indexOf('\'') >= 0 || params?.sort?.indexOf('"') >= 0)){
            		System.out.println("Security filter reject: Invalid sort param value")
            		log.debug("Security filter reject: Invalid sort param value")
            		return false;
            	} else if(params?.contactFieldTypes!=null && params?.contactFieldTypes!='null' && !(params['contactFieldTypes']).isNumber()){
            		System.out.println("Security filter reject: Invalid contactFieldTypes param value")
            		return false;
            	}
            }
            after = { Map model ->

            }
            afterView = { Exception e ->

            }
        }
        
        all(controller:'*', action:'*') {
        
            before = {
            	def value = request?.getHeader('Referer');
                if(new XSSChecker().hasScript(value)){
                	System.out.println("Security filter reject: Invalid Referer header value")
                	return false
                } else if(params?.template!=null && params?.template!='null' && !params?.template?.matches("[a-zA-Z/]*")){
                	System.out.println("Security filter reject: Invalid template name")
                	return false
                }            
            }
            after = { Map model ->

            }
            afterView = { Exception e ->

            }
        }
    }
    
}
