public with sharing class barcodeScannerController {
    @AuraEnabled
    public static void insertPackageRecord(String payload) {
        Map<String,object> mappedBarcodeValues =(Map<String,object>)JSON.deserializeUntyped(payload);
        System.debug(mappedBarcodeValues);
        String trackingNumber = (String)mappedBarcodeValues.get('pckgNumber');
        String packageEmail = (String)mappedBarcodeValues.get('email');
        String unitNumber = (String)mappedBarcodeValues.get('unitNumber');
        list<Package__c> existingPackage = [Select Id, Tracking_Number__c from Package__c where Tracking_Number__c =:trackingNumber];
        list<Tenant__c> tenant = [SELECT Id, Email__c, Unit_Number__c FROM Tenant__c WHERE Email__c = :packageEmail AND Unit_Number__c=:unitNumber];
        if(!tenant.isEmpty()){
            if (existingPackage.isEmpty()) {
                Package__c pckg = new Package__c();
                pckg.Name = (String) mappedBarcodeValues.get('firstName')+(String) mappedBarcodeValues.get('lastName');
                pckg.Email__c = (String) mappedBarcodeValues.get('email');
                pckg.Tracking_Number__c = (String) mappedBarcodeValues.get('pckgNumber');
                pckg.Tenant__c = tenant[0].Id;
                insert pckg;
            } else {
                System.debug('This package already exists.');
            }
        }else {
            System.debug('Tenant with information given on package does not live in this address! This package will be sent back to the sender.');
        }
    }
        
}
