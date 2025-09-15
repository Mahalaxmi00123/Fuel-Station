public with sharing class FuelStationService {

    /**
     * Record a new fuel transaction
     * @param customerId - Customer__c Id
     * @param stationId - Fuel_Station__c Id
     * @param amount - Total amount paid
     * @param quantity - Liters of fuel purchased
     * @return Id of created Fuel_Transaction__c
     */
    @AuraEnabled
    public static Id createTransaction(Id customerId, Id stationId, Decimal amount, Decimal quantity) {
        if(customerId == null || stationId == null) {
            throw new AuraHandledException('❌ Customer and Station are required.');
        }

        // Create transaction
        Fuel_Transaction__c txn = new Fuel_Transaction__c(
            Customer__c = customerId,
            Station__c = stationId,
            Amount__c = amount,
            Quantity__c = quantity
        );
        insert txn;

        // Update loyalty points
        updateLoyaltyPoints(customerId, amount);

        // Update stock
        adjustStock(stationId, quantity);

        return txn.Id;
    }

    /**
     * Update customer loyalty points
     * Formula: 1 point per 100 currency
     */
    private static void updateLoyaltyPoints(Id customerId, Decimal amount) {
        Customer__c cust = [SELECT Id, Loyalty_Points__c FROM Customer__c WHERE Id = :customerId LIMIT 1];
        Decimal newPoints = amount != null ? (amount / 100) : 0;
        cust.Loyalty_Points__c = (cust.Loyalty_Points__c != null ? cust.Loyalty_Points__c : 0) + newPoints;
        update cust;
    }

    /**
     * Adjust fuel stock after transaction
     */
    private static void adjustStock(Id stationId, Decimal quantity) {
        Fuel_Station__c station = [SELECT Id, Stock_Level__c FROM Fuel_Station__c WHERE Id = :stationId LIMIT 1];
        if(station.Stock_Level__c == null) {
            station.Stock_Level__c = 0;
        }
        station.Stock_Level__c = station.Stock_Level__c - quantity;
        update station;
    }

    /**
     * Get current stock level of a station
     */
    @AuraEnabled(cacheable=true)
    public static Decimal getStockLevel(Id stationId) {
        Fuel_Station__c station = [SELECT Stock_Level__c FROM Fuel_Station__c WHERE Id = :stationId LIMIT 1];
        return station.Stock_Level__c;
    }

    /**
     * Get customer loyalty balance
     */
    @AuraEnabled(cacheable=true)
    public static Decimal getLoyaltyBalance(Id customerId) {
        Customer__c cust = [SELECT Loyalty_Points__c FROM Customer__c WHERE Id = :customerId LIMIT 1];
        return cust.Loyalty_Points__c;
    }
}
