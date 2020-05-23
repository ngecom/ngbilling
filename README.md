# OpenSource Billing Based on JBilling And CgRates 
OpenSource Next Generation Billing and Rating platform for subscription billing,payments and Dunning. Its plug-in architecture allows you to easily apply custom logic and integrate with third party systems easly. Some of the interesting supported usecases are available in last sections. Customized plugins can be configured easly to add features in Billing plugin stack. More than 100+ customization plugins on base platform.

# Technology Stack.
  * Java
  * Grails
  * Mysql,Postgres,MSSQL,Oracle 
  * Go Lang
  
# OpenSource Community Stack
  * JBilling Core
  * CGRates (Thanks to great Team -http://www.cgrates.org/) . Performance based rating system with multiple integrations. 
  * Java lovers - OpenRate for Rating . We prefer CGRates even if we are Java experts.
  
# Supported Business in Base version.  
  * Telecom Subscription Billing that supports different billing frequencies(Monthly,Yearly,Weekly and Daily).
  * Telecom Flat rating .
  * Authorize.net Payment plugin.
  * Apply Discounts and Adjustments(Credit Memo's).
  * B2B and B2C Subscription billing.
  * Auto Payment Allocations.
  * Asset Management that supports DID numbers and Serial Number of Devices.
  * Agents And Commissions.
  * Company Hierarchies.
  * Add your own custom fields and Validation through configuration.
  * AccountType differentiates Billing cycle,Invoice design, Credit limt and  Notifications for different Account categories. 
  * Rating based on CGRates or OpenRate. 
  
# Supported Features in Base version 
  * Configurable Framework with plugin extentions. 
  * Scalable Design.
  * Complex Account Structures with multilevel Hierarchy(Level 1 to Level 'N').
  * Custom Fields can be added through User Interface.
  * Good Looking UI for Customers and Admin.(Role access SQL can be provided based on Request)
  * Role Based Security.
  * 1 Format Invoice Template.
  * Catalog Management.
  * Multiple Language Support.
  * Multiple Currency Support.
  * Automated payment processing(1 Free plugin for Authorize.net).
  * Tax percentage support.
  * Absolute discounts.
  * Notifications(Invoice,Payment,Customer,Order)
  * Flat Rating supported. Additional plugins needs to install for Bundles and flexi rating policies
  * Generate product based commission for Agents.
  * Calculate commission based on Generated Invoices and Setup Referal Percentage.
  * Hierachy management that supports multiples levels of contract managment and invoice can be generated based on levels.
  * Customer fields can be added against Customer, Address, Order and Payment.
  * The Account Type entity provides the ability to assign every customer a pre-determined BillingCycle,InvoiceDesign,
    Credit Limit and Credit Notifications. It also generates a new level for Pricing Resolutions, which helps to determine
    pricing for products at the Account Type level. An AccountType must be assigned to any new customer.
          ![alt text](https://github.com/ngecom/ngbilling/blob/master/usermanual/images/AccountType.png)
# Installation
   # Pre-Requisites
   * Java 8.
   * Postgres SQL 9.3 or above
   * Operating System Windows/Linux.
  # NgBilling installation
   * Download the code and extract to a Local Folder.
   * ngbilling-master.zip
   * Extract to Local folder
      Example :- /home/rakesh/Downloads/ngbilling-master
  # Setting up the Database
   * Login to Postgres. 
       psql -U postgres
        (Login may ask for password provide the password which was given during postgres installation)
   * Create database database_name.(Create under specific role if required)  
       CREATE DATABASE ngbillingbase
       WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'en_US.UTF-8'
       LC_CTYPE = 'en_US.UTF-8'
       CONNECTION LIMIT = -1;
   * Logout from postgres by entering \q and Run the below command 
       psql ngbillingbase < /home/rakesh/Downloads/ngbilling-master/sql/ngbillingbase.sql
   * Above script will load all required tables to database.
  
   # Login to NGBilling
   * Start the Server
      * sudo /home/rakesh/Downloads/ngbilling-master/bin/startup.sh
   * Go to the browser and type localhost:8080/ngbilling
   * Login with username and Password admin/ngAdmin123$
    
  # Supported UseCases by Base version
  
   # Subscription Billing
   You are running a VOIP/MVNO/Online business platform and need to offer recurring products and/or charge based on usage.
   Your products may need to offer free periods,discount policies and add-ons and you need the flexibility to specify 
   how products should be invoiced like group subscriptions on one invoice and configure how the system should behave 
   upon cancellation,pro-rate on Entry and Exit.SaaS solutions often lack of flexibility and make it really hard to debug
   the system and expose your most precious customer data.
   NGBilling has been designed specifically to address those needs:
   * It allows you to configure your products and plans into a catalog with multiple price options, and allows you to 
        customize the behavior of the system
   * System offers a set of powerful REST APIs for all the subscription management and expose to  multiple clients
         (creation/upgrade/downgrade/cancellation)    
   * Invoices and payments allocation can happen immediately or at a later date after Billing based on Confioguration.
   * It provides traceability through audit and operation history.
   * System provides hooks to plug custom business logic.
   * It comes with analytics reports that allow you to customize the reports.
   * It comes with Multiple Billing Frequencies (Monthly, Yearlly,Weekly,Daily). 
   * ProRate on Entry and Exit of subscription services.

  # Payment and Invoice Platform For e-commerce sites.
   You are running a large ecommerce operation across the world: you need to process payments in multiple currencies,
   and accept many different payment methods (credit and debit cards, online money transfers, etc.). System support 
   different payment flows and interact with many different payment gateways. Invoices needs to be settled  with 
   different invoice status like Open,Closed,Partially Paid.
   NgBilling is an ideal and well proven solution to address this problem:
   * It provides generic payment APIs that abstract this complexity from the web developers and front-end teams
   * It is designed around a robust payment core system, that ensures safe payment transitions, provides audit trail
     and full payment history and inquiry and notifies other systems about the status of the payments
   * Its plugin capability allows you to extend the platform to connect to any gateway, or add specific pieces 
     of custom business logic
   * Multiple Invoice status maintained against allocated payments. Close Invoices, Partially Paid, Open Invoice and 
     Carry Forwarded Invoices.
     
   # Dunning And Debt Collection.
   Your customer is not paying Invoices and you have complex dunning policies to be included in different stages.
   Reminder emails and Notifications needs to be send to alert the customer that your invoice is due and has 
   reached different stages.
   NgBilling is an ideal and well proven solution to address this problem:
   * System provides comfigurable multiple stages for dunning.
   * Notifications and Alerts for each stage.
   * Overdue payments can be configured for each stage.
   * DebtCollection and WriteOff can be scheduled after specific stage.
     
   # Customer SelfCare Management Portal.
   Your customer wants to make payments online and modify his subscriptions and add-ons. This can be easly 
   achieved through customer portal. 
   NgBilling is an ideal and well proven solution to address this problem:
   * Customer Profile Management 
   * Online Payments And AutoPay
   * Billing Inquiries and Invoice download
   * Account level balances.
   * Add and Delete Subscriptions.
   * Payment inquiries.         
  
   # Free Support for Base versions.
   * Deployment and Configuration issues - rksahadevan@gmail.com 
   * Source Code request - rksahadevan@gmail.com
   * Customizations and Operational Support - info@ngecom.com
   * Feasibility of Analyzing usecases to identify customization required or not- rksahadevan@gmail.com
   * Free Support - https://groups.google.com/forum/#!forum/ngbilling

 



  

  

  


    
