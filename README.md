# ngbilling
OpenSource Next Generation Billing and Rating for Telecom. This can be also used as Subscription Billing for B2B and B2C Systems. Some of the interesting supported usecases are available in last sections. Customized plugins can be configured easly to add features in Billing plugin stack. 
 
# Supported Business in Base Free version.  
  * Telecom Subscription Billing that supports different billing frequencies(Monthly,Yearly,Weekly and Daily).
  * Telecom Flat rating .
  * Authorize.net Payment plugin.
  * Apply Discounts and Adjustments(Credit Memo's).
  * B2B and B2C Subscription billing.
  * Auto Payment Allocations.
 
# Supported Features in Base Free version 
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
    
  # Supported UseCases by Free version
    [I'm an inline-style link](https://www.google.com)

