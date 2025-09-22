# Phase 3: Data Modeling & Relationships (Fuel Station Project)
This phase defines the data model, objects, and relationships required for the Fuel Station project in Salesforce.

## 1. Standard & Custom Objects
- Standard Objects: Account (Fuel Station), Contact (Station Manager / Employee), Opportunity (Fuel Sales Deals), Product (Fuel Types)
- Custom Objects: 
  • Pump (individual fuel dispensing units)
  • Fuel Transaction (each sale at pump)
  • Maintenance Record (service logs of pumps & stations)
  • Fuel Inventory (track stock levels of petrol, diesel, CNG)

## 2. Fields
- Pump Object: Pump ID, Pump Type, Status (Active/Inactive), Last Service Date
- Fuel Transaction: Transaction ID, Fuel Type, Quantity, Amount, Date & Time
- Fuel Inventory: Fuel Type, Opening Balance, Current Stock, Last Refill Date
- Maintenance Record: Pump ID, Service Date, Issue Reported, Technician Name

## 3. Record Types, Page Layouts & Compact Layouts
- Record Types for Fuel Transaction: Retail Sale, Bulk Sale
- Record Types for Maintenance: Preventive Maintenance, Breakdown Repair
- Page Layouts customized for each object to capture relevant data
- Compact Layouts to display Pump ID, Pump Type, and Status at glance

## 4. Schema Builder & Relationships
- Account ↔ Pump: One-to-Many (One station has many pumps)
- Pump ↔ Fuel Transaction: One-to-Many (One pump can have multiple transactions)
- Pump ↔ Maintenance Record: One-to-Many (Each pump can have multiple service logs)
- Account ↔ Fuel Inventory: One-to-One (Each station has a single inventory record)

## 5. Relationship Types
- Lookup Relationship: Pump to Account
- Master-Detail Relationship: Fuel Transaction to Pump, Maintenance Record to Pump
- Junction Object (if needed): Fuel Supply Contracts (between Fuel Supplier and Station)
- External Objects: Fuel Supplier Data (via integration)

## 6. Reference Screenshots
![Buyer Page Layout](image1.png)
![Fuel Detail Fields](image2.png)
![Fuel Detail Object Details](image3.png)