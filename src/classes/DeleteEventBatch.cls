public class DeleteEventBatch implements Database.Batchable<sObject>{
    
    public database.QueryLocator start(Database.BatchableContext bc){
        String query = 'Select id,name from Event__c WHERE Live__c=true AND End_Date_Time__c < LAST_N_MONTHS:2';
        return database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Event__c> eventList){
        if(!eventList.isEmpty()){
            List<Database.DeleteResult> deleteResult = Database.delete(eventList);
            for(Database.DeleteResult result : deleteResult){
                if(!result.isSuccess()){
                    List<Database.Error> errors = result.getErrors();
                    String errorInString = String.join(errors, ',');
                    TransactionLogHandler.doHandleExceptionWithError(errorInString, 'DeleteEventBatch');
                }
            }
        }
    }
    
    public void finish(Database.BatchableContext bc){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setSubject('Batch Processing Completed.');
        List<String> toAddress = new List<String>();
        toAddress.add('rajesh.salesforce95@gmail.com');
        mail.setToAddresses( toAddress);
        mail.setSenderDisplayName('Event Management System');
            
        mail.setHtmlBody('The DeleteEventBatch Batch Processing has been Completed. ');
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});
    }

}