public with sharing class barcodeScannerController {
    @AuraEnabled
    public static void insertPackageRecord(String payload) {
        Map<String,object> mappedBarcodeValues =(Map<String,object>)JSON.deserializeUntyped(payload);
        System.debug(mappedBarcodeValues);
        String trackingNumber = (String)mappedBarcodeValues.get('pckgNumber');
        list<Package__c> existingPackage = [Select Id, Tracking_Number__c from Package__c where Tracking_Number__c =:trackingNumber];
        if (existingPackage.isEmpty()) {
            Package__c pckg = new Package__c();
            pckg.Name = (String) mappedBarcodeValues.get('fullName');
            pckg.Email__c = (String) mappedBarcodeValues.get('email');
            pckg.Tracking_Number__c = (String) mappedBarcodeValues.get('pckgNumber');
            Tenant__c tenant = [SELECT Id, Email__c, Unit_Number__c FROM Tenant__c WHERE Email__c = :pckg.Email__c LIMIT 1];
            pckg.Tenant__c = tenant.Id;
            insert pckg;
            
        } else {
            System.debug('This package already exists.');
        }
    }
}
