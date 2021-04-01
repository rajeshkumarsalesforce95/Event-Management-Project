@RestResource(urlMapping='/v1/event')
global class EventManager {
 	/*
 	 * ENDURL - https://innovexsoftwaretechnologie4-dev-ed.my.salesforce.com/services/apexrest/v1/event
 	 * METHOD - GET
 	 * 
 	 * GET
 	 * PUT
 	 * PATCH
 	 * 
 	 * 
 	 */
    
    @HttpGet
    global static List<Event__c> getEventsRecords(){
        List<Event__c> eventList = [SELECT Id, IsDeleted, Name, CreatedDate,Event_Organizer__c,Event_Organizer__r.name, End_Date_Time__c, 
                            Event_Detail__c, Event_Type__c, Frequency__c, Live__c, Location_Verified__c, Location__c,Location__r.name,
                            Location__r.City__c,Location__r.Country__c,Location__r.Postal_Code__c, Location__r.State__c, Location__r.Street__c,
                            Max_Seats__c, Name__c, Recurring__c, 
                            Remaining_Seats__c, Start_DateTime__c, Status__c, 
                            PeopleAttending__c FROM Event__c];
        return eventList;
    }
    
    @HttpPost
    global static String createEvents(){
        return 'Hello POST';
    }
        
 	 
    
}