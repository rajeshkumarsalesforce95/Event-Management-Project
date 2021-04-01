/**
 * @File Name          : CustomSearchController.cls
 * @Description        : 
 * @Author             : Rajesh Kumar (Developer)
 * @Group              : 
 * @Last Modified By   : Rajesh Kumar (Developer)
 * @Last Modified On   : 5/31/2020, 10:37:01 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    03/17/2021   Rajesh Kumar (Developer)     Initial Version
**/
public class LocationTriggerHandler {
    
    @future(callout=true)
    public static void verifyAddress( String recordId ){
        Location__c loc = [Select Id, Name, VerifiedAddress__c, Street__c, City__c, Postal_Code__c, 
                           State__c From Location__c Where Id=: recordId];
        //https://us-street.api.smartystreets.com/street-address?auth-id=c74b7c5e-e817-b0b7-f6e5-ace4870019ff&auth-token=6gm9i5Mremt2AmG3OWeO                   
        String baseURL = 'https://us-street.api.smartystreets.com/street-address?auth-id=c74b7c5e-e817-b0b7-f6e5-ace4870019ff&auth-token=6gm9i5Mremt2AmG3OWeO';
        baseURL+= '&street='+EncodingUtil.urlEncode(loc.Street__c, 'UTF-8')
                  +'&city='+EncodingUtil.urlEncode(loc.City__c, 'UTF-8')
                  +'&state='+EncodingUtil.urlEncode(loc.State__c, 'UTF-8')
                  +'&zipcode='+EncodingUtil.urlEncode(loc.Postal_Code__c, 'UTF-8')
                  +'&match=invalid&candidates=10';
        
        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint(baseURL);
        //httpReq.setHeader('Content-Type', 'application/json');
        
        Http http = new Http();
        
        HttpResponse httpRes = new HttpResponse();
        
        try{
            httpRes = http.send(httpReq);
            System.debug(' ResponseBody :'+httpRes.getBody());
            if( httpRes.getStatusCode() == 200 && httpRes.getStatus() =='OK'){
                System.debug('httpRes.getStatusCode() =' +httpRes.getStatusCode());
                String responseBody = httpRes.getBody();
                if(!String.isBlank(responseBody) && responseBody.length() > 2){
                    loc.VerifiedAddress__c = true;
                }else{
                    loc.VerifiedAddress__c = false;
                }
                update loc;
            }else{
                TransactionLogHandler.doHandleExceptionWithError( httpRes.getBody() , 'LocationTriggerHandler');
            }
        }catch(System.CalloutException ex ){
            System.debug(' Exception Executed '+ex.getStackTraceString());
            TransactionLogHandler.doHandlerException(ex, 'LocationTriggerHandler');
        }
    }
}