
public with sharing class BulkOrderService {

    /**
     * Create a new bulk order
     * @param customerId - Corporate Customer__c Id
     * @param stationId - Fuel_Station__c Id
     * @param quantity - Requested fuel quantity
     * @return Id of created Bulk_Order__c record
     */
    @AuraEnabled
    public static Id createBulkOrder(Id customerId, Id stationId, Decimal quantity) {
        if(customerId == null || stationId == null || quantity == null || quantity <= 0) {
            throw new AuraHandledException('❌ Customer, Station, and valid Quantity are required.');
        }

        Bulk_Order__c order = new Bulk_Order__c(
            Customer__c = customerId,
            Station__c = stationId,
            Quantity__c = quantity,
            Status__c = 'Pending Approval'
        );
        insert order;

        return order.Id;
    }

    /**
     * Approve bulk order → changes status + reduces station stock
     */
    @AuraEnabled
    public static void approveBulkOrder(Id orderId) {
        Bulk_Order__c order = [SELECT Id, Station__c, Quantity__c, Status__c 
                               FROM Bulk_Order__c WHERE Id = :orderId LIMIT 1];
        
        if(order.Status__c != 'Pending Approval') {
            throw new AuraHandledException('❌ Only Pending Approval orders can be approved.');
        }

        Fuel_Station__c station = [SELECT Id, Stock_Level__c FROM Fuel_Station__c WHERE Id = :order.Station__c LIMIT 1];
        if(station.Stock_Level__c < order.Quantity__c) {
            throw new AuraHandledException('⚠️ Not enough stock available.');
        }

        // Update stock
        station.Stock_Level__c -= order.Quantity__c;
        update station;

        // Update order status
        order.Status__c = 'Approved';
        update order;
    }

    /**
     * Mark bulk order as delivered
     */
    @AuraEnabled
    public static void deliverBulkOrder(Id orderId) {
        Bulk_Order__c order = [SELECT Id, Status__c FROM Bulk_Order__c WHERE Id = :orderId LIMIT 1];
        
        if(order.Status__c != 'Approved') {
            throw new AuraHandledException('❌ Only Approved orders can be delivered.');
        }

        order.Status__c = 'Delivered';
        update order;
    }

    /**
     * Cancel bulk order (only if pending)
     */
    @AuraEnabled
    public static void cancelBulkOrder(Id orderId) {
        Bulk_Order__c order = [SELECT Id, Status__c FROM Bulk_Order__c WHERE Id = :orderId LIMIT 1];

        if(order.Status__c != 'Pending Approval') {
            throw new AuraHandledException('❌ Only Pending Approval orders can be cancelled.');
        }

        order.Status__c = 'Cancelled';
        update order;
    }
}
