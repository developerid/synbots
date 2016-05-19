trigger RestrictInvoiceDeletion on Invoice__c (before delete) {
    //With each of the invoices targeted by the trigger
      // and that have line items, add an error to prevent them
      // from being deletecd.
      for(Invoice__C invoice :
      [SELECT Id FROM Invoice__c WHERE ID IN (SELECT Invoice__C FROM Line_Item__c) AND ID IN : Trigger.old])
      {
          Trigger.oldMap.get(invoice.Id).addError('Cannot delete invoices with lineitems');
      }
}