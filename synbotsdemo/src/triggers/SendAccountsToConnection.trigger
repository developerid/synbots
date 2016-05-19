trigger SendAccountsToConnection on Account (after insert) {
        PartnerNetworkConnection conn = [select Id, ConnectionStatus, ConnectionName from PartnerNetworkConnection  where ConnectionStatus = 'Accepted' and ConnectionName = 'SYNTEL'];
        List<PartnerNetworkRecordConnection> recordConnectionToInsert  = new List<PartnerNetworkRecordConnection>  ();
        for (Account acc : Trigger.new){
            PartnerNetworkRecordConnection newrecord = new PartnerNetworkRecordConnection();

            newrecord.ConnectionId = conn.Id;
            newrecord.LocalRecordId = acc.id;  
            newrecord.SendClosedTasks = false;
            newrecord.SendOpenTasks = false;
            newrecord.SendEmails = false;
            recordConnectionToInsert.add(newrecord);
        }
        if (recordConnectionToInsert.size() > 0){
            System.debug('>>> Sharing ' + recordConnectionToInsert.size() + ' records'+recordConnectionToInsert);
            insert recordConnectionToInsert;
        }
}