public class TransactionLogHandler {
    public static void doHandlerException(System.Exception ex, String processName){
        //TransactionLogHandler.doHandlerException();
        Error_Log__c errLog = new Error_Log__c();
        errLog.Log_Details__c = ex.getStackTraceString() + ' message is : '+ ex.getMessage() + ' Cause : ' +
            ex.getCause() + ' TypeName : ' + ex.getTypeName() + ' LineNumber : ' + ex.getLineNumber();
        errLog.Log_DateTime__c =  System.now();
        errLog.Process_Name__c = processName;
        
        insert errLog;
    }
    
    public static void doHandleExceptionWithError(String errors, String processName){
        //TransactionLogHandler.doHandlerException();
        Error_Log__c errLog = new Error_Log__c();
        errLog.Log_Details__c = errors;
        errLog.Log_DateTime__c =  System.now();
        errLog.Process_Name__c = processName;
        
        insert errLog;
    }


}